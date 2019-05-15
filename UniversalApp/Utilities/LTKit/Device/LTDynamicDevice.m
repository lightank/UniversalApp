//
//  LTDynamicDevice.m
//  UniversalApp
//
//  Created by 李桓宇 on 2019/4/26.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import "LTDynamicDevice.h"
#import <CoreMotion/CoreMotion.h>
#import <CoreBluetooth/CoreBluetooth.h>


@interface LTDynamicDevice () <CBCentralManagerDelegate>

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) CBCentralManager *bluetoothManager;

@property (nonatomic, strong) NSOperationQueue *gyroQueue;;

/**  蓝牙代理是否已经回调  */
@property (nonatomic, assign) BOOL isBluetoothCalled;
@property (nonatomic, copy) LTDeviceBluetoothBlock bluetoothBlock;

/**  蓝牙是否开启,如果直接取值,可能取到默认值NO,建议延迟在调用 [LTDynamicDevice sharedInstance] 后两秒再获取值,也可以通过block实时获取值  */
@property (nonatomic, assign, readonly) BOOL isOpenBluetooth;


@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic) ABAddressBookRef addressBook;
#if LTContactAvailable
@property (nonatomic, copy) NSArray *contactskeys;
@property (nonatomic, strong) CNContactStore *contactStore API_AVAILABLE(ios(9.0));
#endif
@end

@implementation LTDynamicDevice

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LTDynamicDevice *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
        [self initializeProperty:instance];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

+ (void)initializeProperty:(LTDynamicDevice *)device
{
    device.motionManager = [[CMMotionManager alloc] init];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], CBCentralManagerOptionShowPowerAlertKey,nil];
    device.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:device queue:nil options:options];
    device.isBluetoothCalled = NO;
    device.queue = dispatch_queue_create("com.addressBook.queue", DISPATCH_QUEUE_SERIAL);
}

#pragma mark - 蓝牙
+ (void)isOpenBluetooth:(LTDeviceBluetoothBlock)completeBlock
{
    if ([LTDynamicDevice sharedInstance].isBluetoothCalled)
    {
        if (completeBlock)
        {
            completeBlock([LTDynamicDevice sharedInstance].isOpenBluetooth);
        }
    }
    else
    {
        [LTDynamicDevice sharedInstance].bluetoothBlock = completeBlock;
    }

}

#pragma mark - 陀螺仪
+ (void)gyroData:(LTDeviceGyroDataBlock)completeBlock updateInterval:(NSTimeInterval)gyroUpdateInterval stopWhenSuccess:(BOOL)stop
{
    // 1.初始化运动管理对象
    // 2.判断陀螺仪是否可用
    if (![[LTDynamicDevice sharedInstance].motionManager isGyroAvailable])
    {
        if (completeBlock)
        {
            completeBlock(NO, NO, 0, 0, 0);
        }
    }
    // 3.设置陀螺仪更新频率，以秒为单位
    [LTDynamicDevice sharedInstance].motionManager.gyroUpdateInterval = gyroUpdateInterval;
    // 4.开始实时获取
    [LTDynamicDevice sharedInstance].gyroQueue = [[NSOperationQueue alloc] init];
    if (![[LTDynamicDevice sharedInstance].motionManager isGyroActive])
    {
        [[LTDynamicDevice sharedInstance].motionManager startGyroUpdatesToQueue:[LTDynamicDevice sharedInstance].gyroQueue withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
            // 是否停止陀螺仪
            if (stop)
            {
                [self.class stopGyroUpdates];
            }
            //获取陀螺仪数据
            double x = gyroData.rotationRate.x;
            double y = gyroData.rotationRate.y;
            double z = gyroData.rotationRate.z;
            if (completeBlock)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completeBlock(YES, YES, x, y, z);
                });
            }
        }];
    }
}

+ (void)stopGyroUpdates
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[LTDynamicDevice sharedInstance].motionManager stopGyroUpdates];
        [[LTDynamicDevice sharedInstance].gyroQueue waitUntilAllOperationsAreFinished];
    });
}

#pragma mark - 通讯录
+ (void)accessContacts:(LTDeviceContactBlock)completeBlock
{
    dispatch_async([LTDynamicDevice sharedInstance].queue, ^{
        NSMutableArray *contacts = [NSMutableArray array];
        if ([self isIOS9OrLater])
        {
            if (@available(iOS 9.0, *))
            {
#if LTContactAvailable
                CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:[LTDynamicDevice sharedInstance].contactskeys];
                [[LTDynamicDevice sharedInstance].contactStore enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                    LTContact *mycontact = [[LTContact alloc] initWithCNContact:contact];
                    [contacts addObject:mycontact];
                }];
#endif
            }
        }
        else
        {
            CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople([LTDynamicDevice sharedInstance].addressBook);
            CFIndex count = CFArrayGetCount(allPeople);
            for (int i = 0; i < count; i++)
            {
                ABRecordRef record = CFArrayGetValueAtIndex(allPeople, i);
                LTContact *personModel = [[LTContact alloc] initWithRecord:record];
                [contacts addObject:personModel];
            }
            CFRelease(allPeople);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completeBlock)
            {
                completeBlock(contacts);
            }
        });
    });
}


+ (void)accessSortedContacts:(LTDeviceSortedContactBlock)completeBlock
{
    dispatch_async([LTDynamicDevice sharedInstance].queue, ^{
        NSMutableDictionary *contactsDictionary = [NSMutableDictionary dictionary];
        if ([self isIOS9OrLater])
        {
            if (@available(iOS 9.0, *))
            {
#if LTContactAvailable
                CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:[LTDynamicDevice sharedInstance].contactskeys];
                [[LTDynamicDevice sharedInstance].contactStore enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull cncontact, BOOL * _Nonnull stop) {
                    LTContact *contact = [[LTContact alloc] initWithCNContact:cncontact];
                    //获取到姓名的大写首字母
                    NSString *firstLetter = [self getFirstLetterFromString:contact.fullName];
                    //如果该字母对应的联系人模型不为空,则将此联系人模型添加到此数组中
                    if (contactsDictionary[firstLetter])
                    {
                        [contactsDictionary[firstLetter] addObject:contact];
                    }
                    else    //没有出现过该首字母，则在字典中新增一组key-value
                    {
                        //创建新发可变数组存储该首字母对应的联系人模型
                        NSMutableArray *mArr = [NSMutableArray array];
                        [mArr addObject:contact];
                        //将首字母-姓名数组作为key-value加入到字典中
                        [contactsDictionary setObject:mArr forKey:firstLetter];
                    }
                }];
#endif
            }
        }
        else
        {
            CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople([LTDynamicDevice sharedInstance].addressBook);
            CFIndex count = CFArrayGetCount(allPeople);
            for (int i = 0; i < count; i++)
            {
                ABRecordRef record = CFArrayGetValueAtIndex(allPeople, i);
                LTContact *contact = [[LTContact alloc] initWithRecord:record];
                //获取到姓名的大写首字母
                NSString *firstLetter = [self getFirstLetterFromString:contact.fullName];
                //如果该字母对应的联系人模型不为空,则将此联系人模型添加到此数组中
                if (contactsDictionary[firstLetter])
                {
                    [contactsDictionary[firstLetter] addObject:contact];
                }
                //没有出现过该首字母，则在字典中新增一组key-value
                else
                {
                    //创建新发可变数组存储该首字母对应的联系人模型
                    NSMutableArray *mArr = [NSMutableArray array];
                    [mArr addObject:contact];
                    //将首字母-姓名数组作为key-value加入到字典中
                    [contactsDictionary setObject:mArr forKey:firstLetter];
                }
            }
            CFRelease(allPeople);
        }
        
        // 将addressBookDict字典中的所有Key值进行排序: A~Z
        NSArray *nameKeys = [[contactsDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
        NSMutableDictionary *dicts = @{}.mutableCopy;
        for (NSString *key in contactsDictionary)
        {
            NSMutableArray *mArr = contactsDictionary[key];
            dicts[key] = [mArr sortedArrayUsingComparator:^NSComparisonResult(LTContact * _Nonnull obj1, LTContact * _Nonnull obj2) {
                NSString *firstName = [self.class transformToPinyin:obj1.fullName];
                NSString *secondName = [self.class transformToPinyin:obj2.fullName];;
                return [firstName compare:secondName options:NSCaseInsensitiveSearch];
            }];
        }
        
        // 将 "#" 排列在 A~Z 的后面
        if ([nameKeys.firstObject isEqualToString:@"#"])
        {
            NSMutableArray *mutableNamekeys = [NSMutableArray arrayWithArray:nameKeys];
            [mutableNamekeys insertObject:nameKeys.firstObject atIndex:nameKeys.count];
            [mutableNamekeys removeObjectAtIndex:0];
            nameKeys = mutableNamekeys.copy;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completeBlock)
            {
                completeBlock(dicts, nameKeys);
            }
        });
    });
}

+ (void)cleanContactCache
{
    
}

#pragma mark - 获取联系人姓名首字母(传入汉字字符串, 返回大写拼音首字母)
+ (NSString *)getFirstLetterFromString:(NSString *)aString
{
    // 转换为拼音
    NSString *pinyinString = [self transformToPinyin:aString];
    
    // 将拼音首字母装换成大写
    NSString *strPinYin = [[self polyphoneStringHandle:aString pinyinString:pinyinString] uppercaseString];
    // 截取大写首字母
    NSString *firstString = [strPinYin substringToIndex:1];
    // 判断姓名首位是否为大写字母
    NSString * regexA = @"^[A-Z]$";
    NSPredicate *predA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexA];
    // 获取并返回首字母
    return [predA evaluateWithObject:firstString] ? firstString : @"#";
}

+ (NSString *)transformToPinyin:(NSString *)aString
{
    /**
     * 参考博主-庞海礁先生的一文:iOS开发中如何更快的实现汉字转拼音 http://www.olinone.com/?p=131
     */
    NSMutableString *mutableString = [NSMutableString stringWithString:aString];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return [mutableString stringByReplacingOccurrencesOfString:@"'" withString:@""];
}

/**
 多音字处理
 */
+ (NSString *)polyphoneStringHandle:(NSString *)aString pinyinString:(NSString *)pinyinString
{
    if ([aString hasPrefix:@"长"]) { return @"chang";}
    if ([aString hasPrefix:@"沈"]) { return @"shen"; }
    if ([aString hasPrefix:@"厦"]) { return @"xia";  }
    if ([aString hasPrefix:@"地"]) { return @"di";   }
    if ([aString hasPrefix:@"重"]) { return @"chong";}
    return pinyinString;
}


#pragma mark - 蓝牙
#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    _isBluetoothCalled = YES;
    switch (central.state)
    {
        case CBCentralManagerStatePoweredOff:
        case CBCentralManagerStateUnsupported:
            _isOpenBluetooth = NO;
            break;
        case CBCentralManagerStatePoweredOn:
        case CBCentralManagerStateResetting:
        case CBCentralManagerStateUnauthorized:
        case CBCentralManagerStateUnknown:
            _isOpenBluetooth = YES;
            break;
        default:
            _isOpenBluetooth = NO;
            break;
    }
    
    if ([LTDynamicDevice sharedInstance].bluetoothBlock)
    {
        [LTDynamicDevice sharedInstance].bluetoothBlock([LTDynamicDevice sharedInstance].isOpenBluetooth);
        [LTDynamicDevice sharedInstance].bluetoothBlock = nil;
    }
}

#pragma mark - setter and getter
- (dispatch_queue_t)queue
{
    if (!_queue)
    {
        _queue = dispatch_queue_create("com.addressBook.queue", DISPATCH_QUEUE_SERIAL);
    }
    return _queue;
}

#if LTContactAvailable
- (CNContactStore *)contactStore API_AVAILABLE(ios(9.0))
{
    if (!_contactStore)
    {
        _contactStore = [[CNContactStore alloc] init];
    }
    return _contactStore;
}



- (NSArray *)contactskeys
{
    if (!_contactskeys)
    {
        if (@available(iOS 9.0, *))
        {
            _contactskeys = @[[CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName],
                              CNContactPhoneNumbersKey,
                              CNContactOrganizationNameKey,
                              CNContactDepartmentNameKey,
                              CNContactJobTitleKey,
                              CNContactNoteKey,
                              CNContactPhoneticGivenNameKey,
                              CNContactPhoneticFamilyNameKey,
                              CNContactPhoneticMiddleNameKey,
                              CNContactImageDataKey,
                              CNContactThumbnailImageDataKey,
                              CNContactEmailAddressesKey,
                              CNContactPostalAddressesKey,
                              CNContactBirthdayKey,
                              CNContactNonGregorianBirthdayKey,
                              CNContactInstantMessageAddressesKey,
                              CNContactSocialProfilesKey,
                              CNContactRelationsKey,
                              CNContactUrlAddressesKey];
        }
    }
    return _contactskeys;
}

#endif

- (ABAddressBookRef)addressBook
{
    if (!_addressBook)
    {
        _addressBook = ABAddressBookCreate();
    }
    return _addressBook;
}

+ (BOOL)isIOS9OrLater
{
    return ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0);
}

@end
