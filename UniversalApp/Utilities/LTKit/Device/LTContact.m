//
//  LTContact.m
//  UniversalApp
//
//  Created by 李桓宇 on 2019/4/26.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import "LTContact.h"

@implementation LTContact

#if LTContactAvailable
- (instancetype)initWithCNContact:(CNContact *)contact
{
    self = [super init];
    if (self)
    {
        self.contactType = contact.contactType == CNContactTypePerson ? LTContactTypePerson : LTContactTypeOrigination;
        
        self.fullName = [CNContactFormatter stringFromContact:contact style:CNContactFormatterStyleFullName];
        self.familyName = contact.familyName;
        self.givenName = contact.givenName;
        self.nameSuffix = contact.nameSuffix;
        self.namePrefix = contact.namePrefix;
        self.nickname = contact.nickname;
        self.middleName = contact.middleName;
        
        if ([contact isKeyAvailable:CNContactOrganizationNameKey])
        {
            self.organizationName = contact.organizationName;
        }
        
        if ([contact isKeyAvailable:CNContactDepartmentNameKey])
        {
            self.departmentName = contact.departmentName;
        }
        
        if ([contact isKeyAvailable:CNContactJobTitleKey])
        {
            self.jobTitle = contact.jobTitle;
        }
        
        if ([contact isKeyAvailable:CNContactNoteKey])
        {
            self.note = contact.note;
        }
        
        if ([contact isKeyAvailable:CNContactPhoneticFamilyNameKey])
        {
            self.phoneticFamilyName = contact.phoneticFamilyName;
        }
        if ([contact isKeyAvailable:CNContactPhoneticGivenNameKey])
        {
            self.phoneticGivenName = contact.phoneticGivenName;
        }
        
        if ([contact isKeyAvailable:CNContactPhoneticMiddleNameKey])
        {
            self.phoneticMiddleName = contact.phoneticMiddleName;
        }
        
        if ([contact isKeyAvailable:CNContactImageDataKey])
        {
            self.imageData = contact.imageData;
            self.image = [UIImage imageWithData:contact.imageData];
        }
        
        if ([contact isKeyAvailable:CNContactThumbnailImageDataKey])
        {
            self.thumbnailImageData = contact.thumbnailImageData;
            self.thumbnailImage = [UIImage imageWithData:contact.thumbnailImageData];
        }
        
        if ([contact isKeyAvailable:CNContactPhoneNumbersKey])
        {
            // 号码
            NSMutableArray *phones = [NSMutableArray array];
            for (CNLabeledValue *labeledValue in contact.phoneNumbers)
            {
                LTPhone *phoneModel = [[LTPhone alloc] initWithLabeledValue:labeledValue];
                [phones addObject:phoneModel];
            }
            self.phones = phones;
        }
        
        if ([contact isKeyAvailable:CNContactEmailAddressesKey])
        {
            // 电子邮件
            NSMutableArray *emails = [NSMutableArray array];
            for (CNLabeledValue *labeledValue in contact.emailAddresses)
            {
                LTEmail *emailModel = [[LTEmail alloc] initWithLabeledValue:labeledValue];
                [emails addObject:emailModel];
            }
            self.emails = emails;
        }
        
        if ([contact isKeyAvailable:CNContactPostalAddressesKey])
        {
            // 地址
            NSMutableArray *addresses = [NSMutableArray array];
            for (CNLabeledValue *labeledValue in contact.postalAddresses)
            {
                LTAddress *addressModel = [[LTAddress alloc] initWithLabeledValue:labeledValue];
                [addresses addObject:addressModel];
            }
            self.addresses = addresses;
        }
        
        // 生日
        LTBirthday *birthday = [[LTBirthday alloc] initWithCNContact:contact];
        self.birthday = birthday;
        
        if ([contact isKeyAvailable:CNContactInstantMessageAddressesKey])
        {
            // 即时通讯
            NSMutableArray *messages = [NSMutableArray array];
            for (CNLabeledValue *labeledValue in contact.instantMessageAddresses)
            {
                LTMessage *messageModel = [[LTMessage alloc] initWithLabeledValue:labeledValue];
                [messages addObject:messageModel];
            }
            self.messages = messages;
        }
        
        if ([contact isKeyAvailable:CNContactSocialProfilesKey])
        {
            // 社交
            NSMutableArray *socials = [NSMutableArray array];
            for (CNLabeledValue *labeledValue in contact.socialProfiles)
            {
                LTSocialProfile *socialModel = [[LTSocialProfile alloc] initWithLabeledValue:labeledValue];
                [socials addObject:socialModel];
            }
            self.socials = socials;
        }
        
        if ([contact isKeyAvailable:CNContactRelationsKey])
        {
            // 关联人
            NSMutableArray *relations = [NSMutableArray array];
            for (CNLabeledValue *labeledValue in contact.contactRelations)
            {
                LTContactRelation *relationModel = [[LTContactRelation alloc] initWithLabeledValue:labeledValue];
                [relations addObject:relationModel];
            }
            self.relations = relations;
        }
        
        if ([contact isKeyAvailable:CNContactUrlAddressesKey])
        {
            // URL
            NSMutableArray *urlAddresses = [NSMutableArray array];
            for (CNLabeledValue *labeledValue in contact.urlAddresses)
            {
                LTUrlAddress *urlModel = [[LTUrlAddress alloc] initWithLabeledValue:labeledValue];
                [urlAddresses addObject:urlModel];
            }
            self.urls = urlAddresses;
        }
    }
    return self;
}

#endif

- (instancetype)initWithRecord:(ABRecordRef)record
{
    self = [super init];
    if (self)
    {
        CFNumberRef type = ABRecordCopyValue(record, kABPersonKindProperty);
        self.contactType = type == kABPersonKindPerson ? LTContactTypePerson : LTContactTypeOrigination;
        CFRelease(type);
        NSString *fullName = CFBridgingRelease(ABRecordCopyCompositeName(record));
        NSString *firstName = CFBridgingRelease(ABRecordCopyValue(record, kABPersonFirstNameProperty));
        NSString *lastName = CFBridgingRelease(ABRecordCopyValue(record, kABPersonLastNameProperty));
        
        NSString *namePrefix = CFBridgingRelease(ABRecordCopyValue(record, kABPersonPrefixProperty));
        NSString *nameSuffix = CFBridgingRelease(ABRecordCopyValue(record, kABPersonSuffixProperty));
        NSString *nickname = CFBridgingRelease(ABRecordCopyValue(record, kABPersonNicknameProperty));
        NSString *middleName = CFBridgingRelease(ABRecordCopyValue(record, kABPersonMiddleNameProperty));
        NSString *organizationName = CFBridgingRelease(ABRecordCopyValue(record, kABPersonOrganizationProperty));
        NSString *departmentName = CFBridgingRelease(ABRecordCopyValue(record, kABPersonDepartmentProperty));
        NSString *jobTitle = CFBridgingRelease(ABRecordCopyValue(record, kABPersonJobTitleProperty));
        NSString *note = CFBridgingRelease(ABRecordCopyValue(record, kABPersonNoteProperty));
        NSString *phoneticFamilyName = CFBridgingRelease(ABRecordCopyValue(record, kABPersonFirstNamePhoneticProperty));
        NSString *phoneticGivenName = CFBridgingRelease(ABRecordCopyValue(record, kABPersonLastNamePhoneticProperty));
        NSString *phoneticMiddleName = CFBridgingRelease(ABRecordCopyValue(record, kABPersonMiddleNamePhoneticProperty));
        
        NSData *imageData = CFBridgingRelease(ABPersonCopyImageDataWithFormat(record, kABPersonImageFormatOriginalSize));
        
        NSData *thumbnailImageData = CFBridgingRelease(ABPersonCopyImageDataWithFormat(record, kABPersonImageFormatThumbnail));
        
        NSDate *creationDate = CFBridgingRelease(ABRecordCopyValue(record, kABPersonCreationDateProperty));
        NSDate *modificationDate = CFBridgingRelease(ABRecordCopyValue(record, kABPersonModificationDateProperty));
        
        self.fullName = fullName;
        self.familyName = firstName;
        self.givenName = lastName;
        self.namePrefix = namePrefix;
        self.nameSuffix = nameSuffix;
        self.nickname = nickname;
        self.middleName = middleName;
        self.organizationName = organizationName;
        self.departmentName = departmentName;
        self.jobTitle = jobTitle;
        self.note = note;
        self.phoneticFamilyName = phoneticFamilyName;
        self.phoneticMiddleName = phoneticMiddleName;
        self.phoneticGivenName = phoneticGivenName;
        self.imageData = imageData;
        self.image = [UIImage imageWithData:imageData];
        self.thumbnailImageData = thumbnailImageData;
        self.thumbnailImage = [UIImage imageWithData:thumbnailImageData];
        self.creationDate = creationDate;
        self.modificationDate = modificationDate;
        
        // 号码
        ABMultiValueRef multiPhones = ABRecordCopyValue(record, kABPersonPhoneProperty);
        CFIndex phoneCount = ABMultiValueGetCount(multiPhones);
        NSMutableArray *phones = [NSMutableArray array];
        for (CFIndex i = 0; i < phoneCount; i++)
        {
            LTPhone *phoneModel = [[LTPhone alloc] initWithMultiValue:multiPhones index:i];
            [phones addObject:phoneModel];
        }
        CFRelease(multiPhones);
        self.phones = phones;
        
        // 电子邮件
        ABMultiValueRef multiEmails = ABRecordCopyValue(record, kABPersonEmailProperty);
        CFIndex emailCount = ABMultiValueGetCount(multiEmails);
        NSMutableArray *emails = [NSMutableArray array];
        for (CFIndex i = 0; i < emailCount; i++)
        {
            LTEmail *emailModel = [[LTEmail alloc] initWithMultiValue:multiEmails index:i];
            [emails addObject:emailModel];
        }
        CFRelease(multiEmails);
        self.emails = emails;
        
        // 地址
        ABMultiValueRef multiAddresses = ABRecordCopyValue(record, kABPersonAddressProperty);
        CFIndex addressCount = ABMultiValueGetCount(multiAddresses);
        NSMutableArray *addresses = [NSMutableArray array];
        for (CFIndex i = 0; i < addressCount; i++)
        {
            LTAddress *addressModel = [[LTAddress alloc] initWithMultiValue:multiAddresses index:i];
            [addresses addObject:addressModel];
        }
        CFRelease(multiAddresses);
        self.addresses = addresses;
        
        // 生日
        LTBirthday *birthday = [[LTBirthday alloc] initWithRecord:record];
        self.birthday = birthday;
        
        // 即时通讯
        ABMultiValueRef multiMessages = ABRecordCopyValue(record, kABPersonInstantMessageProperty);
        CFIndex messageCount = ABMultiValueGetCount(multiMessages);
        NSMutableArray *messages = [NSMutableArray array];
        for (CFIndex i = 0; i < messageCount; i++)
        {
            LTMessage *messageModel = [[LTMessage alloc] initWithMultiValue:multiMessages index:i];
            [messages addObject:messageModel];
        }
        CFRelease(multiMessages);
        self.messages = messages;
        
        // 社交
        ABMultiValueRef multiSocials = ABRecordCopyValue(record, kABPersonSocialProfileProperty);
        CFIndex socialCount = ABMultiValueGetCount(multiSocials);
        NSMutableArray *socials = [NSMutableArray array];
        for (CFIndex i = 0; i < socialCount; i++)
        {
            LTSocialProfile *socialModel = [[LTSocialProfile alloc] initWithMultiValue:multiSocials index:i];
            [socials addObject:socialModel];
        }
        CFRelease(multiSocials);
        self.socials = socials;
        
        // 关联人
        ABMultiValueRef multiRelations = ABRecordCopyValue(record, kABPersonRelatedNamesProperty);
        CFIndex relationCount = ABMultiValueGetCount(multiRelations);
        NSMutableArray *relations = [NSMutableArray array];
        for (CFIndex i = 0; i < relationCount; i++)
        {
            LTContactRelation *relationModel = [[LTContactRelation alloc] initWithMultiValue:multiRelations index:i];
            [relations addObject:relationModel];
        }
        CFRelease(multiRelations);
        self.relations = relations;
        
        // URL
        ABMultiValueRef multiURLs = ABRecordCopyValue(record, kABPersonURLProperty);
        CFIndex urlCount = ABMultiValueGetCount(multiURLs);
        NSMutableArray *urls = [NSMutableArray array];
        for (CFIndex i = 0; i < urlCount; i ++)
        {
            LTUrlAddress *urlModel = [[LTUrlAddress alloc] initWithMultiValue:multiURLs index:i];
            [urls addObject:urlModel];
        }
        CFRelease(multiURLs);
        self.urls = urls;
    }
    return self;
}


@end

@implementation LTPhone
#if LTContactAvailable
- (instancetype)initWithLabeledValue:(CNLabeledValue *)labeledValue
{
    self = [super init];
    if (self)
    {
        CNPhoneNumber *phoneValue = labeledValue.value;
        NSString *phoneNumber = phoneValue.stringValue;
        self.phone = LTContactFilterPhoneNumber(phoneNumber);
        self.label = [CNLabeledValue localizedStringForLabel:labeledValue.label];
    }
    return self;
}
#endif
- (instancetype)initWithMultiValue:(ABMultiValueRef)multiValue index:(CFIndex)index
{
    self = [super init];
    if (self)
    {
        NSString *label = (NSString *)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(multiValue, index));
        CFStringRef localizedRef = ABAddressBookCopyLocalizedLabel((__bridge CFStringRef)label);
        NSString *localized = nil;
        if (localizedRef)
        {
            localized = [NSString stringWithString:(__bridge NSString *)localizedRef];
            CFRelease(localizedRef);
        }
        self.label = localized;
        NSString *phoneNumber = CFBridgingRelease(ABMultiValueCopyValueAtIndex(multiValue, index));
        self.phone = LTContactFilterPhoneNumber(phoneNumber);
    }
    return self;
}

+ (NSString *)localizedLabel:(NSString*)label
{
    CFStringRef localizedRef = ABAddressBookCopyLocalizedLabel((__bridge CFStringRef)label);
    NSString *localized = nil;
    if (localizedRef){
        localized = [NSString stringWithString:(__bridge NSString*)localizedRef];
        CFRelease(localizedRef);
    }
    return localized;
}

@end

@implementation LTEmail
#if LTContactAvailable
- (instancetype)initWithLabeledValue:(CNLabeledValue *)labeledValue
{
    self = [super init];
    if (self)
    {
        self.label = [CNLabeledValue localizedStringForLabel:labeledValue.label];
        self.email = labeledValue.value;
    }
    return self;
}
#endif

- (instancetype)initWithMultiValue:(ABMultiValueRef)multiValue index:(CFIndex)index
{
    self = [super init];
    if (self)
    {
        NSString *label = (NSString *)CFBridgingRelease(ABMultiValueCopyLabelAtIndex(multiValue, index));
        CFStringRef localizedRef = ABAddressBookCopyLocalizedLabel((__bridge CFStringRef)label);
        NSString *localized = nil;
        if (localizedRef)
        {
            localized = [NSString stringWithString:(__bridge NSString *)localizedRef];
            CFRelease(localizedRef);
        }
        self.label = localized;
        NSString *emial = CFBridgingRelease(ABMultiValueCopyValueAtIndex(multiValue, index));
        self.email = emial;
    }
    return self;
}

@end

@implementation LTAddress

#if LTContactAvailable
- (instancetype)initWithLabeledValue:(CNLabeledValue *)labeledValue
{
    self = [super init];
    if (self)
    {
        CNPostalAddress *addressValue = labeledValue.value;
        self.label = [CNLabeledValue localizedStringForLabel:labeledValue.label];
        self.street = addressValue.street;
        self.state = addressValue.state;
        self.city = addressValue.city;
        self.postalCode = addressValue.postalCode;
        self.country = addressValue.country;
        self.ISOCountryCode = addressValue.ISOCountryCode;
        
        self.formatterAddress = [CNPostalAddressFormatter stringFromPostalAddress:addressValue style:CNPostalAddressFormatterStyleMailingAddress];
    }
    return self;
}
#endif

- (instancetype)initWithMultiValue:(ABMultiValueRef)multiValue index:(CFIndex)index
{
    self = [super init];
    if (self)
    {
        CFStringRef label = ABMultiValueCopyLabelAtIndex(multiValue, index);
        CFStringRef localLabel = ABAddressBookCopyLocalizedLabel(label);
        CFRelease(label);
        self.label = CFBridgingRelease(localLabel);
        
        NSDictionary *dict = CFBridgingRelease((ABMultiValueCopyValueAtIndex(multiValue, index)));
        self.country = [dict valueForKey:(__bridge NSString *)kABPersonAddressCountryKey];
        self.city = [dict valueForKey:(__bridge NSString *)kABPersonAddressCityKey];
        self.state = [dict valueForKey:(__bridge NSString *)kABPersonAddressStateKey];
        self.street = [dict valueForKey:(__bridge NSString *)kABPersonAddressStreetKey];
        self.postalCode = [dict valueForKey:(__bridge NSString *)kABPersonAddressZIPKey];
        self.ISOCountryCode = [dict valueForKey:(__bridge NSString *)kABPersonAddressCountryCodeKey];
    }
    return self;
}

@end

@implementation LTBirthday

#if LTContactAvailable
- (instancetype)initWithCNContact:(CNContact *)contact
{
    self = [super init];
    if (self)
    {
        if ([contact isKeyAvailable:CNContactBirthdayKey])
        {
            self.brithdayDate = contact.birthday.date;
        }
        
        if ([contact isKeyAvailable:CNContactNonGregorianBirthdayKey])
        {
            self.calendarIdentifier = contact.nonGregorianBirthday.calendar.calendarIdentifier;
            self.era = contact.nonGregorianBirthday.era;
            self.day = contact.nonGregorianBirthday.day;
            self.month = contact.nonGregorianBirthday.month;
            self.year = contact.nonGregorianBirthday.year;
        }
    }
    return self;
}
#endif

- (instancetype)initWithRecord:(ABRecordRef)record
{
    self = [super init];
    if (self)
    {
        self.brithdayDate = CFBridgingRelease(ABRecordCopyValue(record, kABPersonBirthdayProperty));
        
        NSDictionary *dict = CFBridgingRelease((ABRecordCopyValue(record, kABPersonAlternateBirthdayProperty)));
        self.calendarIdentifier = dict[@"calendarIdentifier"];
        self.era = [(NSNumber *)dict[@"era"] integerValue];
        self.year = [(NSNumber *)dict[@"year"] integerValue];
        self.month = [(NSNumber *)dict[@"month"] integerValue];
        self.day = [(NSNumber *)dict[@"day"] integerValue];
    }
    return self;
}

@end

@implementation LTMessage
#if LTContactAvailable
- (instancetype)initWithLabeledValue:(CNLabeledValue *)labeledValue
{
    self = [super init];
    if (self)
    {
        CNInstantMessageAddress *messageValue = labeledValue.value;
        self.service = messageValue.service;
        self.userName = messageValue.username;
    }
    return self;
}
#endif
- (instancetype)initWithMultiValue:(ABMultiValueRef)multiValue index:(CFIndex)index
{
    self = [super init];
    if (self)
    {
        NSDictionary *dict = CFBridgingRelease(ABMultiValueCopyValueAtIndex(multiValue, index));
        self.service = dict[@"service"];
        self.userName = dict[@"username"];
    }
    return self;
}

@end

@implementation LTSocialProfile
#if LTContactAvailable
- (instancetype)initWithLabeledValue:(CNLabeledValue *)labeledValue
{
    self = [super init];
    if (self)
    {
        CNSocialProfile *socialValue = labeledValue.value;
        self.service = socialValue.service;
        self.username = socialValue.username;
        self.urlString = socialValue.urlString;
    }
    return self;
}
#endif

- (instancetype)initWithMultiValue:(ABMultiValueRef)multiValue index:(CFIndex)index
{
    self = [super init];
    if (self)
    {
        NSDictionary *dict = CFBridgingRelease(ABMultiValueCopyValueAtIndex(multiValue, index));
        self.service = dict[@"service"];
        self.username = dict[@"username"];
        self.urlString = dict[@"url"];
    }
    return self;
}

@end

@implementation LTUrlAddress
#if LTContactAvailable
- (instancetype)initWithLabeledValue:(CNLabeledValue *)labeledValue
{
    self = [super init];
    if (self)
    {
        self.label = [CNLabeledValue localizedStringForLabel:labeledValue.label];
        self.urlString = labeledValue.value;
    }
    return self;
}
#endif
- (instancetype)initWithMultiValue:(ABMultiValueRef)multiValue index:(CFIndex)index
{
    self = [super init];
    if (self)
    {
        CFStringRef label = ABMultiValueCopyLabelAtIndex(multiValue, index);
        CFStringRef localLabel = ABAddressBookCopyLocalizedLabel(label);
        CFRelease(label);
        self.label = CFBridgingRelease(localLabel);
        self.urlString = CFBridgingRelease(ABMultiValueCopyValueAtIndex(multiValue, index));
    }
    return self;
}

@end

@implementation LTContactRelation
#if LTContactAvailable
- (instancetype)initWithLabeledValue:(CNLabeledValue *)labeledValue
{
    self = [super init];
    if (self)
    {
        CNContactRelation *relationValue = labeledValue.value;
        self.label = [CNLabeledValue localizedStringForLabel:labeledValue.label];;
        self.name = relationValue.name;
    }
    return self;
}
#endif
- (instancetype)initWithMultiValue:(ABMultiValueRef)multiValue index:(CFIndex)index
{
    self = [super init];
    if (self)
    {
        CFStringRef label = ABMultiValueCopyLabelAtIndex(multiValue, index);
        CFStringRef localLabel = ABAddressBookCopyLocalizedLabel(label);
        CFRelease(label);
        self.label = CFBridgingRelease(localLabel);
        self.name = CFBridgingRelease(ABMultiValueCopyValueAtIndex(multiValue, index));
    }
    return self;
}

@end

@implementation LTSectionPerson


@end


