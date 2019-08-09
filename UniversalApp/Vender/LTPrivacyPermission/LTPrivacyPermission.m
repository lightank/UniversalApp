//
//  LTPrivacyPermission.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/8/24.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "LTPrivacyPermission.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <EventKit/EventKit.h>
#import <AddressBook/AddressBook.h>
#import <HealthKit/HealthKit.h>
#import <CoreLocation/CoreLocation.h>

#if __has_include(<CoreTelephony/CTCellularData.h>)
#import <CoreTelephony/CTCellularData.h>

#ifndef LTLTPrivacyPermissionCoreTelephonyAvailable
#define LTLTPrivacyPermissionCoreTelephonyAvailable
#endif

#endif

#if __has_include(<Speech/Speech.h>)
#import <Speech/Speech.h>

#ifndef LTLTPrivacyPermissionSpeechAvailable
#define LTLTPrivacyPermissionSpeechAvailable
#endif

#endif

#if __has_include(<MediaPlayer/MediaPlayer.h>)
#import <MediaPlayer/MediaPlayer.h>

#ifndef LTLTPrivacyPermissionMediaLibraryAvailable
#define LTLTPrivacyPermissionMediaLibraryAvailable
#endif

#endif

#if __has_include(<Contacts/Contacts.h>)
#import <Contacts/Contacts.h>

#ifndef LTLTPrivacyPermissionContactAvailable
#define LTLTPrivacyPermissionContactAvailable
#endif

#endif

#if __has_include(<UserNotifications/UserNotifications.h>)
#import <UserNotifications/UserNotifications.h>

#ifndef LTLTPrivacyPermissionUserNotificationsAvailable
#define LTLTPrivacyPermissionUserNotificationsAvailable
#endif

#endif

//#define LT_Permission_Photo

@interface LTPrivacyPermission () <CLLocationManagerDelegate>

/**  定位  */
@property (nonatomic, strong) CLLocationManager *locationManager;

/**  定位  */
@property (nonatomic, assign) LTPrivacyPermissionType locationType;
/**  完成回调  */
@property (nonatomic, copy) LTPrivacyPermissionCompletionBlock completionBlock;

@end


@implementation LTPrivacyPermission

+ (LTPrivacyPermission *)sharedPermission
{
    static dispatch_once_t onceToken;
    static LTPrivacyPermission *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedPermission];
}

- (void)privacyPermissionWithType:(LTPrivacyPermissionType)type
                       completion:(LTPrivacyPermissionCompletionBlock)completion
        shouldAccessAuthorization:(BOOL)access
{
    switch (type)
    {
#ifdef LT_Permission_Photo
        case LTPrivacyPermissionTypePhoto:
            [self PhotoAuthorizationWhetherAccessAuthorization:access completion:completion];
            break;
#endif

#ifdef LT_Permission_Camera
        case LTPrivacyPermissionTypeCamera:
            [self AVCaptureDeviceAuthorizationStatusForMediaType:AVMediaTypeVideo shouldAccessAuthorization:access completion:completion];
            break;
#endif

#ifdef LT_Permission_MediaLibrary
        case LTPrivacyPermissionTypeMediaLibrary:
            [self MediaLibraryAuthorizationWhetherAccessAuthorization:access completion:completion];
            break;
#endif

#ifdef LT_Permission_Microphone
        case LTPrivacyPermissionTypeMicrophone:
            [self AVCaptureDeviceAuthorizationStatusForMediaType:AVMediaTypeAudio shouldAccessAuthorization:access completion:completion];
            break;
#endif

#ifdef LT_Permission_Location_Always
        case LTPrivacyPermissionTypeLocationAlways:
            [self LocationAuthorizationStatusForMediaType:LTPrivacyPermissionTypeLocationAlways shouldAccessAuthorization:access completion:completion];
            break;
#endif

#ifdef LT_Permission_Location_WhenInUse
        case LTPrivacyPermissionTypeLocationWhenInUse:
            [self LocationAuthorizationStatusForMediaType:LTPrivacyPermissionTypeLocationWhenInUse shouldAccessAuthorization:access completion:completion];
            break;
#endif

#ifdef LT_Permission_Location_AlwaysAndWhenInUse
        case LTPrivacyPermissionTypeLocationAlwaysAndWhenInUse:
            [self LocationAuthorizationStatusForMediaType:LTPrivacyPermissionTypeLocationWhenInUse shouldAccessAuthorization:access completion:completion];
            break;
#endif

#ifdef LT_Permission_PushNotification
        case LTPrivacyPermissionTypePushNotification:
            [self PushNotificationAuthorizationWhetherAccessAuthorization:access completion:completion];
            break;
#endif

#ifdef LT_Permission_Speech
        case LTPrivacyPermissionTypeSpeech:
            [self SpeechAuthorizationWhetherAccessAuthorization:access completion:completion];
            break;
#endif

#ifdef LT_Permission_Calendar
        case LTPrivacyPermissionTypeCalendar:
            [self EKEventStoreAuthorizationStatusForEntityType:EKEntityTypeEvent shouldAccessAuthorization:access completion:completion];
            break;
#endif

#ifdef LT_Permission_Reminder
        case LTPrivacyPermissionTypeReminder:
            [self EKEventStoreAuthorizationStatusForEntityType:EKEntityTypeReminder shouldAccessAuthorization:access completion:completion];
            break;
#endif

#ifdef LT_Permission_Contact
        case LTPrivacyPermissionTypeContact:
            [self ContactAuthorizationWhetherAccessAuthorization:access completion:completion];
            break;
#endif

#ifdef LT_Permission_Network
        case LTPrivacyPermissionTypeNetwork:
            [self NetworkAuthorizationWhetherAccessAuthorization:access completion:completion];
            break;
#endif

        case LTPrivacyPermissionTypeUnknown:
            break;

        default:
            break;
    }
}


- (void)accessPrivacyPermissionWithType:(LTPrivacyPermissionType)type
                             completion:(LTPrivacyPermissionCompletionBlock)completion
{
    [self privacyPermissionWithType:type completion:completion shouldAccessAuthorization:YES];
}

- (void)checkPrivacyPermissionWithType:(LTPrivacyPermissionType)type
                            completion:(LTPrivacyPermissionCompletionBlock)completion
{
    [self privacyPermissionWithType:type completion:completion shouldAccessAuthorization:NO];
}

- (void)completionWithAuthorized:(BOOL)authorized permissionType:(LTPrivacyPermissionType)type authorizationStatus:(LTPrivacyPermissionAuthorizationStatus)status completion:(LTPrivacyPermissionCompletionBlock)completion
{
    if (completion)
    {
        if ([NSThread currentThread].isMainThread)
        {
            completion(authorized, type, status);
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(authorized, type, status);
            });
        }
    }
}

#pragma mark - 单个授权
#ifdef LT_Permission_Photo
- (void)PhotoAuthorizationWhetherAccessAuthorization:(BOOL)access completion:(LTPrivacyPermissionCompletionBlock)completion
{
    LTPrivacyPermissionType permissionType = LTPrivacyPermissionTypePhoto;
    if (access)
    {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (status)
                {
                    case PHAuthorizationStatusNotDetermined:
                        [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusNotDetermined completion:completion];
                        break;
                        
                    case PHAuthorizationStatusRestricted:
                        [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusRestricted completion:completion];
                        break;
                        
                    case PHAuthorizationStatusDenied:
                        [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusDenied completion:completion];
                        break;
                        
                    case PHAuthorizationStatusAuthorized:
                        [self completionWithAuthorized:YES permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusAuthorized completion:completion];
                        break;
                }
            });
        }];
    }
    else
    {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        switch (status)
        {
            case PHAuthorizationStatusNotDetermined:
                [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusNotDetermined completion:completion];
                break;
                
            case PHAuthorizationStatusRestricted:
                [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusRestricted completion:completion];
                break;
                
            case PHAuthorizationStatusDenied:
                [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusDenied completion:completion];
                break;
                
            case PHAuthorizationStatusAuthorized:
                [self completionWithAuthorized:YES permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusAuthorized completion:completion];
                break;
        }
    }
}
#endif


#if defined(LT_Permission_Camera) || defined(LT_Permission_Microphone)
- (void)AVCaptureDeviceAuthorizationStatusForMediaType:(AVMediaType)mediaType shouldAccessAuthorization:(BOOL)access completion:(LTPrivacyPermissionCompletionBlock)completion
{
    if (!(mediaType == AVMediaTypeVideo || mediaType == AVMediaTypeAudio))
    {
        return;
    }
    
    LTPrivacyPermissionType permissionType = LTPrivacyPermissionTypeCamera;
    #ifdef LT_Permission_Camera
    if (mediaType == AVMediaTypeVideo) permissionType = LTPrivacyPermissionTypeCamera;
    #endif
    #ifdef LT_Permission_Microphone
    if (mediaType == AVMediaTypeAudio) permissionType = LTPrivacyPermissionTypeMicrophone;
    #endif
    if (access)
    {
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (status)
                {
                    case AVAuthorizationStatusNotDetermined:
                        [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusNotDetermined completion:completion];
                        break;
                        
                    case AVAuthorizationStatusRestricted:
                        [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusRestricted completion:completion];
                        break;
                        
                    case AVAuthorizationStatusDenied:
                        [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusDenied completion:completion];
                        break;
                        
                    case AVAuthorizationStatusAuthorized:
                        [self completionWithAuthorized:YES permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusAuthorized completion:completion];
                        break;
                }
            });
        }];
    }
    else
    {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        switch (status)
        {
            case AVAuthorizationStatusNotDetermined:
                [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusNotDetermined completion:completion];
                break;
                
            case AVAuthorizationStatusRestricted:
                [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusRestricted completion:completion];
                break;
                
            case AVAuthorizationStatusDenied:
                [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusDenied completion:completion];
                break;
                
            case AVAuthorizationStatusAuthorized:
                [self completionWithAuthorized:YES permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusAuthorized completion:completion];
                break;
        }
    }
}
#endif

#ifdef LT_Permission_MediaLibrary
- (void)MediaLibraryAuthorizationWhetherAccessAuthorization:(BOOL)access completion:(LTPrivacyPermissionCompletionBlock)completion
{
    LTPrivacyPermissionType permissionType = LTPrivacyPermissionTypeMediaLibrary;
    if (access)
    {
#ifdef LTLTPrivacyPermissionMediaLibraryAvailable
        if (@available(iOS 9.3, *)) {
            [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    switch (status)
                    {
                        case MPMediaLibraryAuthorizationStatusNotDetermined:
                            [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusNotDetermined completion:completion];
                            break;
                            
                        case MPMediaLibraryAuthorizationStatusDenied:
                            [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusDenied completion:completion];
                            break;
                            
                        case MPMediaLibraryAuthorizationStatusRestricted:
                            [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusRestricted completion:completion];
                            break;
                            
                        case MPMediaLibraryAuthorizationStatusAuthorized:
                            [self completionWithAuthorized:YES permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusAuthorized completion:completion];
                            break;
                    }
                });
            }];
        }
#elif
        [self completionWithAuthorized:self.isServicesDisabledAuthorize permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusServicesDisabled completion:completion];
#endif
    }
    else
    {
#ifdef LTLTPrivacyPermissionMediaLibraryAvailable
        if (@available(iOS 9.3, *))
        {
            MPMediaLibraryAuthorizationStatus status = [MPMediaLibrary authorizationStatus];
            switch (status)
            {
                case MPMediaLibraryAuthorizationStatusNotDetermined:
                    [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusNotDetermined completion:completion];
                    break;
                    
                case MPMediaLibraryAuthorizationStatusDenied:
                    [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusDenied completion:completion];
                    break;
                    
                case MPMediaLibraryAuthorizationStatusRestricted:
                    [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusRestricted completion:completion];
                    break;
                    
                case MPMediaLibraryAuthorizationStatusAuthorized:
                    [self completionWithAuthorized:YES permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusAuthorized completion:completion];
                    break;
            }
        }
#elif
        [self completionWithAuthorized:self.isServicesDisabledAuthorize permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusServicesDisabled completion:completion];
#endif
    }
}
#endif


- (void)LocationAuthorizationStatusForMediaType:(LTPrivacyPermissionType)type shouldAccessAuthorization:(BOOL)access completion:(LTPrivacyPermissionCompletionBlock)completion
{
    BOOL isLocation = NO;
    
    BOOL isLocationAlways = NO;
    BOOL isLocationWhenInUse = NO;
    BOOL isLocationAlwaysAndWhenInUse = NO;
    
#ifdef LT_Permission_Location_Always
    isLocationAlways = (type == LTPrivacyPermissionTypeLocationAlways);
#endif
    
#ifdef LT_Permission_Location_WhenInUse
    isLocationWhenInUse = (type == LTPrivacyPermissionTypeLocationWhenInUse);
#endif
    
#ifdef LT_Permission_Location_AlwaysAndWhenInUse
    isLocationAlwaysAndWhenInUse = (type == LTPrivacyPermissionTypeLocationAlwaysAndWhenInUse);
#endif
    
    isLocation = isLocationAlways || isLocationWhenInUse || isLocationAlwaysAndWhenInUse;
    if (!isLocation)
    {
        return;
    }
    
    if (![CLLocationManager locationServicesEnabled])
    {
        [self completionWithAuthorized:self.isServicesDisabledAuthorize permissionType:type authorizationStatus:LTPrivacyPermissionAuthorizationStatusServicesDisabled completion:completion];
        return;
    }
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    switch (status)
    {
        case kCLAuthorizationStatusNotDetermined:
        {
            if (access)
            {
                self.completionBlock = completion;
                self.locationType = type;
                switch (type)
                {
#ifdef LT_Permission_Location_Always
                    case LTPrivacyPermissionTypeLocationAlways:
                    {
                        [self.locationManager requestAlwaysAuthorization];
                    }
                        break;
#endif
                        
#ifdef LT_Permission_Location_WhenInUse
                    case LTPrivacyPermissionTypeLocationWhenInUse:
                    {
                        [self.locationManager requestWhenInUseAuthorization];
                    }
                        break;
#endif

#ifdef LT_Permission_Location_AlwaysAndWhenInUse
                    case LTPrivacyPermissionTypeLocationAlwaysAndWhenInUse:
                    {
                        [self.locationManager requestAlwaysAuthorization];
                        [self.locationManager requestWhenInUseAuthorization];
                    }
                        break;
#endif
                        
                    default:
                        break;
                }
            }
            else
            {
                [self completionWithAuthorized:NO permissionType:type authorizationStatus:LTPrivacyPermissionAuthorizationStatusNotDetermined completion:completion];
            }
        }
            break;
            
        case kCLAuthorizationStatusDenied:
            [self completionWithAuthorized:NO permissionType:type authorizationStatus:LTPrivacyPermissionAuthorizationStatusDenied completion:completion];
            break;
            
        case kCLAuthorizationStatusAuthorizedAlways:
            [self completionWithAuthorized:YES permissionType:type authorizationStatus:LTPrivacyPermissionAuthorizationStatusLocationAlways completion:completion];
            break;
            
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self completionWithAuthorized:YES permissionType:type authorizationStatus:LTPrivacyPermissionAuthorizationStatusLocationWhenInUse completion:completion];
            break;
            
        case kCLAuthorizationStatusRestricted:
            [self completionWithAuthorized:NO permissionType:type authorizationStatus:LTPrivacyPermissionAuthorizationStatusRestricted completion:completion];
            break;
    }
}

#ifdef LT_Permission_PushNotification
- (void)PushNotificationAuthorizationWhetherAccessAuthorization:(BOOL)access completion:(LTPrivacyPermissionCompletionBlock)completion
{
    LTPrivacyPermissionType permissionType = LTPrivacyPermissionTypePushNotification;
#ifdef LTLTPrivacyPermissionUserNotificationsAvailable
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            UNAuthorizationStatus status = settings.authorizationStatus;
            switch (status)
            {
                case UNAuthorizationStatusNotDetermined:
                {
                    if (access)
                    {
                        UNAuthorizationOptions types = UNAuthorizationOptionBadge | UNAuthorizationOptionAlert |UNAuthorizationOptionSound;
                        [center requestAuthorizationWithOptions:types completionHandler:^(BOOL granted, NSError * _Nullable error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self completionWithAuthorized:granted permissionType:permissionType authorizationStatus:granted ? LTPrivacyPermissionAuthorizationStatusAuthorized : LTPrivacyPermissionAuthorizationStatusDenied completion:completion];
                            });
                        }];
                    }
                    else
                    {
                        [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusNotDetermined completion:completion];
                    }
                }
                    break;
                    
                case UNAuthorizationStatusDenied:
                {
                    [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusDenied completion:completion];
                }
                    break;
                    
                case UNAuthorizationStatusAuthorized:
                case UNAuthorizationStatusProvisional:
                {
                    [self completionWithAuthorized:YES permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusAuthorized completion:completion];
                }
                    break;
                    
                default:
                    break;
            }
            
        }];
    }
#else
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    UIUserNotificationType status = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
    switch (status)
    {
        case UIUserNotificationTypeNone:
        {
            if (access)
            {
                [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
            }
            [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusUnkonwn completion:completion];
        }
            break;
        case UIUserNotificationTypeBadge:
        case UIUserNotificationTypeSound:
        case UIUserNotificationTypeAlert:
        {
            [self completionWithAuthorized:YES permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusAuthorized completion:completion];
        }
            break;
        default:
            break;
    }
#pragma clang diagnostic pop
#endif
}
#endif

#ifdef LT_Permission_Speech
- (void)SpeechAuthorizationWhetherAccessAuthorization:(BOOL)access completion:(LTPrivacyPermissionCompletionBlock)completion
{
    LTPrivacyPermissionType permissionType = LTPrivacyPermissionTypeSpeech;
    if (access)
    {
#ifdef LTLTPrivacyPermissionSpeechAvailable
        if (@available(iOS 10.0, *)) {
            [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    switch (status)
                    {
                        case SFSpeechRecognizerAuthorizationStatusDenied:
                            [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusDenied completion:completion];
                            break;
                            
                        case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                            [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusNotDetermined completion:completion];
                            break;
                            
                        case SFSpeechRecognizerAuthorizationStatusRestricted:
                            [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusRestricted completion:completion];
                            break;
                            
                        case SFSpeechRecognizerAuthorizationStatusAuthorized:
                            [self completionWithAuthorized:YES permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusAuthorized completion:completion];
                            break;
                    }
                });
            }];
        }
#elif
        [self completionWithAuthorized:self.isServicesDisabledAuthorize permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusServicesDisabled completion:completion];
#endif

    }
    else
    {
#ifdef LTLTPrivacyPermissionSpeechAvailable
        if (@available(iOS 10.0, *))
        {
            SFSpeechRecognizerAuthorizationStatus status = [SFSpeechRecognizer authorizationStatus];
            switch (status)
            {
                case SFSpeechRecognizerAuthorizationStatusDenied:
                    [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusDenied completion:completion];
                    break;
                    
                case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                    [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusNotDetermined completion:completion];
                    break;
                    
                case SFSpeechRecognizerAuthorizationStatusRestricted:
                    [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusRestricted completion:completion];
                    break;
                    
                case SFSpeechRecognizerAuthorizationStatusAuthorized:
                    [self completionWithAuthorized:YES permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusAuthorized completion:completion];
                    break;
            }
        }
#elif
        [self completionWithAuthorized:self.isServicesDisabledAuthorize permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusServicesDisabled completion:completion];
#endif

    }
}
#endif

#ifdef LT_Permission_Contact
- (void)ContactAuthorizationWhetherAccessAuthorization:(BOOL)access completion:(LTPrivacyPermissionCompletionBlock)completion
{
    LTPrivacyPermissionType permissionType = LTPrivacyPermissionTypeContact;
#ifdef  LTLTPrivacyPermissionContactAvailable
    if (@available(iOS 9.0, *))
    {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        switch (status)
        {
            case CNAuthorizationStatusAuthorized:
                [self completionWithAuthorized:YES permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusAuthorized completion:completion];
                break;
                
            case CNAuthorizationStatusDenied:
                [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusDenied completion:completion];
                break;
                
            case CNAuthorizationStatusRestricted:
                [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusRestricted completion:completion];
                break;
                
            case CNAuthorizationStatusNotDetermined:
            {
                if (access)
                {
                    [[CNContactStore new] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self completionWithAuthorized:granted permissionType:permissionType authorizationStatus:granted ? LTPrivacyPermissionAuthorizationStatusAuthorized : LTPrivacyPermissionAuthorizationStatusDenied completion:completion];
                        });
                    }];
                }
                else
                {
                    [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusNotDetermined completion:completion];
                }
            }
                break;
        }
    }
#elif
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    switch (status)
    {
        case kABAuthorizationStatusAuthorized:
        {
            [self completionWithAuthorized:YES permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusAuthorized completion:completion];
        }
            break;
            
        case kABAuthorizationStatusNotDetermined:
        {
            if (access)
            {
                ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
                ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self completionWithAuthorized:granted permissionType:permissionType authorizationStatus:granted ? LTPrivacyPermissionAuthorizationStatusAuthorized : LTPrivacyPermissionAuthorizationStatusDenied completion:completion];
                    });
                });
            }
            else
            {
                [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusNotDetermined completion:completion];
            }
        }
            break;
            
        case kABAuthorizationStatusRestricted:
        {
            [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusRestricted completion:completion];
        }
            break;
            
        case kABAuthorizationStatusDenied:
        {
            [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusDenied completion:completion];
        }
            break;
    }
#pragma clang diagnostic pop
#endif
}
#endif

#if defined(LT_Permission_Calendar) || defined(LT_Permission_Reminder)
- (void)EKEventStoreAuthorizationStatusForEntityType:(EKEntityType)type shouldAccessAuthorization:(BOOL)access completion:(LTPrivacyPermissionCompletionBlock)completion
{
    LTPrivacyPermissionType permissionType = LTPrivacyPermissionTypeUnknown;
    switch (type)
    {
#ifdef LT_Permission_Calendar
        case EKEntityTypeEvent:
            permissionType = LTPrivacyPermissionTypeCalendar;
            break;
#endif
            
#ifdef LT_Permission_Reminder
        case EKEntityTypeReminder:
            permissionType = LTPrivacyPermissionTypeReminder;
            break;
#endif
        default:
            break;
    }

    if (access)
    {
        EKEventStore *eventStore = [[EKEventStore alloc] init];
        [eventStore requestAccessToEntityType:type completion:^(BOOL granted, NSError * _Nullable error) {
            EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:type];
            switch (status)
            {
                case EKAuthorizationStatusNotDetermined:
                    [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusNotDetermined completion:completion];
                    break;
                    
                case EKAuthorizationStatusRestricted:
                    [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusRestricted completion:completion];
                    break;
                    
                case EKAuthorizationStatusDenied:
                    [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusDenied completion:completion];
                    break;
                    
                case EKAuthorizationStatusAuthorized:
                    [self completionWithAuthorized:YES permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusAuthorized completion:completion];
                    break;
            }
        }];
    }
    else
    {
        EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:type];
        switch (status)
        {
            case EKAuthorizationStatusNotDetermined:
                [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusNotDetermined completion:completion];
                break;
                
            case EKAuthorizationStatusRestricted:
                [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusRestricted completion:completion];
                break;
                
            case EKAuthorizationStatusDenied:
                [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusDenied completion:completion];
                break;
                
            case EKAuthorizationStatusAuthorized:
                [self completionWithAuthorized:YES permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusAuthorized completion:completion];
                break;
        }
    }
}
#endif

#ifdef LT_Permission_Network
- (void)NetworkAuthorizationWhetherAccessAuthorization:(BOOL)access completion:(LTPrivacyPermissionCompletionBlock)completion
{
    LTPrivacyPermissionType permissionType = LTPrivacyPermissionTypeNetwork;
#ifdef LTLTPrivacyPermissionCoreTelephonyAvailable
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    CTCellularDataRestrictedState status = cellularData.restrictedState;
    
    switch (status)
    {
        case kCTCellularDataNotRestricted:
        {
            //没有限制
            [self completionWithAuthorized:YES permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusAuthorized completion:completion];
        }
            break;
            
        case kCTCellularDataRestricted:
        {
            //限制
            [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusDenied completion:completion];
        }
            break;
            
        case kCTCellularDataRestrictedStateUnknown:
        {
            if (access)
            {
                [cellularData setCellularDataRestrictionDidUpdateNotifier:^(CTCellularDataRestrictedState newState) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        switch (newState)
                        {
                            case kCTCellularDataNotRestricted:
                            {
                                //没有限制
                                [self completionWithAuthorized:YES permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusAuthorized completion:completion];
                            }
                                break;
                                
                            case kCTCellularDataRestricted:
                            {
                                //限制
                                [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusRestricted completion:completion];
                            }
                                break;
                                
                            case kCTCellularDataRestrictedStateUnknown:
                            {
                                [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusUnkonwn completion:completion];
                            }
                                break;
                        }
                    });
                }];
            }
            else
            {
                [self completionWithAuthorized:NO permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusNotDetermined completion:completion];
            }
        }
            break;
    }
#elif
    [self completionWithAuthorized:self.isServicesDisabledAuthorize permissionType:permissionType authorizationStatus:LTPrivacyPermissionAuthorizationStatusServicesDisabled completion:completion];
#endif
}
#endif

#pragma mark - 系统设置
+ (void)showOpenApplicationSettingsAlertWithTitle:(NSString *)title
                                          message:(NSString *)message
                                cancelActionTitle:(NSString *)cancelActionTitle
                               settingActionTitle:(NSString *)settingActionTitle
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelActionTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *settingAction = [UIAlertAction actionWithTitle:settingActionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openApplicationSettings];
    }];
    
    [alertVC addAction:cancelAction];
    [alertVC addAction:settingAction];
    
    [self.topmostKeyWindowController presentViewController:alertVC animated:YES completion:^{
        
    }];
}

+ (void)openApplicationSettings
{
    NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:settingURL])
    {
        if (@available(iOS 10.0, *))
        {
            [[UIApplication sharedApplication] openURL:settingURL options:@{} completionHandler:nil];
        }
        else
        {
            [[UIApplication sharedApplication] openURL:settingURL];
        }
    }
}

#pragma mark - CLLocationManagerDelegate
#if defined(LT_Permission_Location_Always) || defined(LT_Permission_Location_WhenInUse) || defined(LT_Permission_Location_AlwaysAndWhenInUse)
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status)
    {
        case kCLAuthorizationStatusNotDetermined:
            // 默认会走一遍,所以这个默认什么都不做
            break;
            
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            [self completionWithAuthorized:YES permissionType:self.locationType authorizationStatus:LTPrivacyPermissionAuthorizationStatusLocationWhenInUse completion:self.completionBlock];
        }
            break;
            
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            [self completionWithAuthorized:YES permissionType:self.locationType authorizationStatus:LTPrivacyPermissionAuthorizationStatusLocationAlways completion:self.completionBlock];
        }
            break;
            
        case kCLAuthorizationStatusDenied:
        {
            [self completionWithAuthorized:NO permissionType:self.locationType authorizationStatus:LTPrivacyPermissionAuthorizationStatusDenied completion:self.completionBlock];
        }
            break;
            
        case kCLAuthorizationStatusRestricted:
        {
            [self completionWithAuthorized:NO permissionType:self.locationType authorizationStatus:LTPrivacyPermissionAuthorizationStatusRestricted completion:self.completionBlock];
        }
            break;
    }
}
#endif

#pragma mark - setter and getter
- (CLLocationManager *)locationManager
{
    if (!_locationManager)
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

+ (UIViewController *)topmostKeyWindowController
{
    UIViewController *topController = UIApplication.sharedApplication.keyWindow.rootViewController;
    while ([topController presentedViewController])
    {
        topController = [topController presentedViewController];
    }
    
    while ([topController isKindOfClass:[UITabBarController class]]
           && ((UITabBarController*)topController).selectedViewController)
    {
        topController = ((UITabBarController*)topController).selectedViewController;
    }
    
    while ([topController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topController topViewController])
    {
        topController = [(UINavigationController*)topController topViewController];
        
        while ([topController isKindOfClass:[UITabBarController class]]
               && ((UITabBarController*)topController).selectedViewController)
        {
            topController = ((UITabBarController*)topController).selectedViewController;
        }
    }
    
    return topController;
}

@end
