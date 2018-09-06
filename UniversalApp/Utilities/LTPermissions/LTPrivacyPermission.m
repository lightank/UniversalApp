//
//  LTPrivacyPermission.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/8/24.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "LTPrivacyPermission.h"
@import Photos;
@import AVFoundation;
@import EventKit;
@import Contacts;
@import AddressBook;
@import Speech;
@import HealthKit;
@import MediaPlayer;
@import UserNotifications;
@import CoreLocation;
@import CoreTelephony;

static LTPrivacyPermission *_instance = nil;
static double const kLTPrivacyPermissionTypeLocationDistanceFilter = 10; //`Positioning accuracy` -> 定位精度

@interface LTPrivacyPermission () <CLLocationManagerDelegate>

/**  定位  */
@property (nonatomic, strong) CLLocationManager *locationManager;
/**  定位回调  */
@property (nonatomic, copy) CompletionBlock locationCompletion;

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

- (void)accessPrivacyPermissionWithType:(LTPrivacyPermissionType)type
                             completion:(CompletionBlock)completion
{
    switch (type)
    {
        case LTPrivacyPermissionTypePhoto:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                switch (status)
                {
                    case PHAuthorizationStatusNotDetermined:
                        completion(NO, LTPrivacyPermissionAuthorizationStatusNotDetermined);
                        break;
                        
                    case PHAuthorizationStatusRestricted:
                        completion(NO, LTPrivacyPermissionAuthorizationStatusRestricted);
                        break;
                        
                    case PHAuthorizationStatusDenied:
                        completion(NO, LTPrivacyPermissionAuthorizationStatusDenied);
                        break;
                        
                    case PHAuthorizationStatusAuthorized:
                        completion(YES, LTPrivacyPermissionAuthorizationStatusAuthorized);
                        break;
                }
            }];
        }
            break;
            
        case LTPrivacyPermissionTypeCamera:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                switch (status)
                {
                    case AVAuthorizationStatusNotDetermined:
                        completion(NO, LTPrivacyPermissionAuthorizationStatusNotDetermined);
                        break;
                        
                    case AVAuthorizationStatusRestricted:
                        completion(NO, LTPrivacyPermissionAuthorizationStatusRestricted);
                        break;
                        
                    case AVAuthorizationStatusDenied:
                        completion(NO, LTPrivacyPermissionAuthorizationStatusDenied);
                        break;
                        
                    case AVAuthorizationStatusAuthorized:
                        completion(YES, LTPrivacyPermissionAuthorizationStatusAuthorized);
                        break;
                }
            }];
        }
            break;
            
        case LTPrivacyPermissionTypeMedia:
        {
            if (@available(iOS 9.3, *))
            {
                [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
                    switch (status)
                    {
                        case MPMediaLibraryAuthorizationStatusNotDetermined:
                            completion(NO, LTPrivacyPermissionAuthorizationStatusNotDetermined);
                            break;
                            
                        case MPMediaLibraryAuthorizationStatusDenied:
                            completion(NO, LTPrivacyPermissionAuthorizationStatusDenied);
                            break;
                            
                        case MPMediaLibraryAuthorizationStatusRestricted:
                            completion(NO, LTPrivacyPermissionAuthorizationStatusRestricted);
                            break;
                            
                        case MPMediaLibraryAuthorizationStatusAuthorized:
                            completion(YES, LTPrivacyPermissionAuthorizationStatusNotDetermined);
                            break;
                    }
                }];
            }
            else
            {
                completion(NO, LTPrivacyPermissionAuthorizationStatusServicesDisabled);
            }
        }
            break;
            
        case LTPrivacyPermissionTypeMicrophone:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
                switch (status)
                {
                    case AVAuthorizationStatusDenied:
                        completion(NO, LTPrivacyPermissionAuthorizationStatusDenied);
                        break;
                        
                    case AVAuthorizationStatusNotDetermined:
                        completion(NO, LTPrivacyPermissionAuthorizationStatusNotDetermined);
                        break;
                        
                    case AVAuthorizationStatusRestricted:
                        completion(NO, LTPrivacyPermissionAuthorizationStatusRestricted);
                        break;
                        
                    case AVAuthorizationStatusAuthorized:
                        completion(YES, LTPrivacyPermissionAuthorizationStatusAuthorized);
                        break;
                }
            }];
        }
            break;
            
        case LTPrivacyPermissionTypeLocationAlways:
        case LTPrivacyPermissionTypeLocationWhenInUse:
        case LTPrivacyPermissionTypeLocationAlwaysAndWhenInUse:
        {
            if (![CLLocationManager locationServicesEnabled])
            {
                completion(NO, LTPrivacyPermissionAuthorizationStatusServicesDisabled);
                break;
            }
            
            CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
            if (status == kCLAuthorizationStatusNotDetermined)
            {
                self.locationCompletion = completion;
                
                switch (type)
                {
                    case LTPrivacyPermissionTypeLocationAlways:
                    {
                        [self.locationManager requestAlwaysAuthorization];
                    }
                        break;
                        
                    case LTPrivacyPermissionTypeLocationWhenInUse:
                    {
                        [self.locationManager requestWhenInUseAuthorization];
                    }
                        break;
                        
                    case LTPrivacyPermissionTypeLocationAlwaysAndWhenInUse:
                    {
                        [self.locationManager requestAlwaysAuthorization];
                        [self.locationManager requestWhenInUseAuthorization];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
            else if (status == kCLAuthorizationStatusDenied)
            {
                completion(NO, LTPrivacyPermissionAuthorizationStatusDenied);
            }
            else if (status == kCLAuthorizationStatusAuthorizedAlways)
            {
                completion(YES, LTPrivacyPermissionAuthorizationStatusLocationAlways);
            }
            else if (status == kCLAuthorizationStatusAuthorizedWhenInUse)
            {
                completion(YES, LTPrivacyPermissionAuthorizationStatusLocationWhenInUse);
            }
            else if (status == kCLAuthorizationStatusRestricted)
            {
                completion(NO, LTPrivacyPermissionAuthorizationStatusRestricted);
            }
        }
            break;
            
        case LTPrivacyPermissionTypePushNotification:
        {
            if (@available(iOS 10.0, *))
            {
                UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
                UNAuthorizationOptions types = UNAuthorizationOptionBadge | UNAuthorizationOptionAlert |UNAuthorizationOptionSound;
                [center requestAuthorizationWithOptions:types completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    //Queue: com.apple.usernotifications.UNUserNotificationServiceConnection.call-out (serial) 非主队列回调
                    if (granted)
                    {
                        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                completion(YES, LTPrivacyPermissionAuthorizationStatusAuthorized);
                            });
                        }];
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(NO, LTPrivacyPermissionAuthorizationStatusDenied);
                        });
                    }
                }];
            }
            else
            {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
                [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
#pragma clang diagnostic pop
            }

        }
            break;
            
        case LTPrivacyPermissionTypeSpeech:
        {
            if (@available(iOS 10, *))
            {
                [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
                    if (status == SFSpeechRecognizerAuthorizationStatusDenied)
                    {
                        completion(NO, LTPrivacyPermissionAuthorizationStatusDenied);
                    }
                    else if (status == SFSpeechRecognizerAuthorizationStatusNotDetermined)
                    {
                        completion(NO, LTPrivacyPermissionAuthorizationStatusNotDetermined);
                    }
                    else if (status == SFSpeechRecognizerAuthorizationStatusRestricted)
                    {
                        completion(NO, LTPrivacyPermissionAuthorizationStatusRestricted);
                    }
                    else if (status == SFSpeechRecognizerAuthorizationStatusAuthorized)
                    {
                        completion(YES, LTPrivacyPermissionAuthorizationStatusAuthorized);
                    }
                }];
            }
            else
            {
                completion(NO, LTPrivacyPermissionAuthorizationStatusServicesDisabled);
            }
        }
            break;
            
        case LTPrivacyPermissionTypeEvent:
        {
            EKEventStore *store = [[EKEventStore alloc] init];
            [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
                EKAuthorizationStatus status = [EKEventStore  authorizationStatusForEntityType:EKEntityTypeEvent];
                switch (status)
                {
                    case EKAuthorizationStatusAuthorized:
                        completion(YES, LTPrivacyPermissionAuthorizationStatusAuthorized);
                        break;
                        
                    case EKAuthorizationStatusDenied:
                        completion(NO, LTPrivacyPermissionAuthorizationStatusDenied);
                        break;
                        
                    case EKAuthorizationStatusNotDetermined:
                        completion(NO, LTPrivacyPermissionAuthorizationStatusNotDetermined);
                        break;
                        
                    case EKAuthorizationStatusRestricted:
                        completion(NO, LTPrivacyPermissionAuthorizationStatusRestricted);
                        break;
                }
            }];
        }
            break;
            
        case LTPrivacyPermissionTypeContact:
        {
            if (@available(iOS 9, *))
            {
                CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
                switch (status)
                {
                    case CNAuthorizationStatusAuthorized:
                    {
                        completion(YES, LTPrivacyPermissionAuthorizationStatusAuthorized);
                    }
                        break;
                        
                    case CNAuthorizationStatusDenied:
                    {
                        completion(NO, LTPrivacyPermissionAuthorizationStatusDenied);
                    }
                        break;
                        
                    case CNAuthorizationStatusRestricted:
                    {
                        completion(NO, LTPrivacyPermissionAuthorizationStatusRestricted);
                    }
                        break;
                        
                    case CNAuthorizationStatusNotDetermined:
                    {
                        [[CNContactStore new] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                completion(granted, granted ? LTPrivacyPermissionAuthorizationStatusAuthorized : LTPrivacyPermissionAuthorizationStatusDenied);
                            });
                        }];
                    }
                        break;
                }
            }
            else
            {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
                ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
                switch (status)
                {
                    case kABAuthorizationStatusAuthorized:
                    {
                        completion(YES, LTPrivacyPermissionAuthorizationStatusAuthorized);
                    }
                        break;
                        
                    case kABAuthorizationStatusNotDetermined:
                    {
                        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
                        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                completion(granted, granted ? LTPrivacyPermissionAuthorizationStatusAuthorized : LTPrivacyPermissionAuthorizationStatusDenied);
                            });
                        });
                    }
                        break;
                        
                    case kABAuthorizationStatusRestricted:
                    {
                        completion(NO, LTPrivacyPermissionAuthorizationStatusRestricted);
                    }
                        break;
                        
                    case kABAuthorizationStatusDenied:
                    {
                        completion(NO, LTPrivacyPermissionAuthorizationStatusDenied);
                    }
                        break;
                }
            }
#pragma clang diagnostic pop
        }
            break;
            
        case LTPrivacyPermissionTypeReminder:
        {
            EKEventStore *eventStore = [[EKEventStore alloc] init];
            [eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error) {
                EKAuthorizationStatus status = [EKEventStore  authorizationStatusForEntityType:EKEntityTypeEvent];
                if (granted)
                {
                    completion(YES, LTPrivacyPermissionAuthorizationStatusAuthorized);
                }
                else
                {
                    if (status == EKAuthorizationStatusDenied)
                    {
                        completion(NO, LTPrivacyPermissionAuthorizationStatusDenied);
                    }
                    else if (status == EKAuthorizationStatusNotDetermined)
                    {
                        completion(NO, LTPrivacyPermissionAuthorizationStatusNotDetermined);
                    }
                    else if (status == EKAuthorizationStatusRestricted)
                    {
                        completion(NO, LTPrivacyPermissionAuthorizationStatusRestricted);
                    }
                }
            }];
        }
            break;
            
        case LTPrivacyPermissionTypeNetwork:
        {
            if (@available(iOS 9, *))
            {
                CTCellularData *cellularData = [[CTCellularData alloc] init];
                CTCellularDataRestrictedState status = cellularData.restrictedState;
                
                switch (status)
                {
                    case kCTCellularDataNotRestricted:
                    {
                        //没有限制
                        completion(YES, LTPrivacyPermissionAuthorizationStatusAuthorized);
                    }
                        break;
                        
                    case kCTCellularDataRestricted:
                    {
                        //限制
                        completion(NO, LTPrivacyPermissionAuthorizationStatusDenied);
                    }
                        break;
                        
                    case kCTCellularDataRestrictedStateUnknown:
                    {
                        [cellularData setCellularDataRestrictionDidUpdateNotifier:^(CTCellularDataRestrictedState newState) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                switch (newState)
                                {
                                    case kCTCellularDataNotRestricted:
                                    {
                                        //没有限制
                                        completion(YES, LTPrivacyPermissionAuthorizationStatusAuthorized);
                                    }
                                        break;
                                        
                                    case kCTCellularDataRestricted:
                                    {
                                        //限制
                                        completion(NO, LTPrivacyPermissionAuthorizationStatusDenied);
                                    }
                                        break;
                                    
                                    case kCTCellularDataRestrictedStateUnknown:
                                    {
                                        completion(NO, LTPrivacyPermissionAuthorizationStatusUnkonwn);
                                    }
                                        break;
                                }
                            });
                        }];
                    }
                        break;
                }
            }
            else
            {
                completion(NO, LTPrivacyPermissionAuthorizationStatusServicesDisabled);
            }
        }
            break;
            
    }
}

+ (void)showOpenApplicationSettingsAlertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *settingAction = [UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
    }];
    
    [alertVC addAction:cancelAction];
    [alertVC addAction:settingAction];
    
    [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:alertVC animated:YES completion:^{
        
    }];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (!self.locationCompletion)
    {
        return;
    }
    
    switch (status)
    {
        case kCLAuthorizationStatusNotDetermined:
        {
            // 默认会走一遍,所以这个默认什么都不做
        }
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            self.locationCompletion(YES, LTPrivacyPermissionAuthorizationStatusLocationWhenInUse);
            self.locationCompletion = nil;
        }
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            self.locationCompletion(YES, LTPrivacyPermissionAuthorizationStatusLocationAlways);
            self.locationCompletion = nil;
        }
            break;
        case kCLAuthorizationStatusDenied:
        {
            self.locationCompletion(YES, LTPrivacyPermissionAuthorizationStatusDenied);
            self.locationCompletion = nil;
        }
            break;
        case kCLAuthorizationStatusRestricted:
        {
            self.locationCompletion(YES, LTPrivacyPermissionAuthorizationStatusRestricted);
            self.locationCompletion = nil;
        }
            break;
    }
}

#pragma mark - setter and getter
- (CLLocationManager *)locationManager
{
    if (!_locationManager)
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        _locationManager.distanceFilter = kLTPrivacyPermissionTypeLocationDistanceFilter;
    }
    return _locationManager;
}

@end
