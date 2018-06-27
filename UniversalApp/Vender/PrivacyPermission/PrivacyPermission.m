// PrivacyPermission.m
//
// Copyright (c) 2017 BANYAN
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "PrivacyPermission.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <EventKit/EventKit.h>
#import <Contacts/Contacts.h>
#import <Speech/Speech.h>
#import <HealthKit/HealthKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <UserNotifications/UserNotifications.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

static PrivacyPermission *_instance = nil;
static NSInteger const PrivacyPermissionTypeLocationDistanceFilter = 10; //`Positioning accuracy` -> 定位精度

@implementation PrivacyPermission

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    return _instance;
}

- (void)accessPrivacyPermissionWithType:(PrivacyPermissionType)type completion:(void(^)(BOOL response,PrivacyPermissionAuthorizationStatus status))completion API_AVAILABLE(ios(10.0)){
    switch (type) {
        case PrivacyPermissionTypePhoto: {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusDenied) {
                    completion(NO,PrivacyPermissionAuthorizationStatusDenied);
                } else if (status == PHAuthorizationStatusNotDetermined) {
                    completion(NO,PrivacyPermissionAuthorizationStatusNotDetermined);
                } else if (status == PHAuthorizationStatusRestricted) {
                    completion(NO,PrivacyPermissionAuthorizationStatusRestricted);
                } else if (status == PHAuthorizationStatusAuthorized) {
                    completion(YES,PrivacyPermissionAuthorizationStatusAuthorized);
                }
            }];
        }break;
            
        case PrivacyPermissionTypeCamera: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                if (granted) {
                    completion(YES,PrivacyPermissionAuthorizationStatusAuthorized);
                } else {
                    if (status == AVAuthorizationStatusDenied) {
                        completion(NO,PrivacyPermissionAuthorizationStatusDenied);
                    } else if (status == AVAuthorizationStatusNotDetermined) {
                        completion(NO,PrivacyPermissionAuthorizationStatusNotDetermined);
                    } else if (status == AVAuthorizationStatusRestricted) {
                        completion(NO,PrivacyPermissionAuthorizationStatusRestricted);
                    }
                }
            }];
        }break;
            
        case PrivacyPermissionTypeMedia: {
            [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
                if (status == MPMediaLibraryAuthorizationStatusDenied) {
                    completion(NO,PrivacyPermissionAuthorizationStatusDenied);
                } else if (status == MPMediaLibraryAuthorizationStatusNotDetermined) {
                    completion(NO,PrivacyPermissionAuthorizationStatusNotDetermined);
                } else if (status == MPMediaLibraryAuthorizationStatusRestricted) {
                    completion(NO,PrivacyPermissionAuthorizationStatusRestricted);
                } else if (status == MPMediaLibraryAuthorizationStatusAuthorized) {
                    completion(YES,PrivacyPermissionAuthorizationStatusAuthorized);
                }
            }];
        }break;
            
        case PrivacyPermissionTypeMicrophone: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
                if (granted) {
                    completion(YES,PrivacyPermissionAuthorizationStatusAuthorized);
                } else {
                    if (status == AVAuthorizationStatusDenied) {
                        completion(NO,PrivacyPermissionAuthorizationStatusDenied);
                    } else if (status == AVAuthorizationStatusNotDetermined) {
                        completion(NO,PrivacyPermissionAuthorizationStatusNotDetermined);
                    } else if (status == AVAuthorizationStatusRestricted) {
                        completion(NO,PrivacyPermissionAuthorizationStatusRestricted);
                    }
                }
            }];
        }break;
            
        case PrivacyPermissionTypeLocation: {
            if ([CLLocationManager locationServicesEnabled]) {
                CLLocationManager *locationManager = [[CLLocationManager alloc]init];
                [locationManager requestAlwaysAuthorization];
                [locationManager requestWhenInUseAuthorization];
                locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
                locationManager.distanceFilter = PrivacyPermissionTypeLocationDistanceFilter;
                [locationManager startUpdatingLocation];
            }
            CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
            if (status == kCLAuthorizationStatusAuthorizedAlways) {
                completion(YES,PrivacyPermissionAuthorizationStatusLocationAlways);
            } else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
                completion(YES,PrivacyPermissionAuthorizationStatusLocationWhenInUse);
            } else if (status == kCLAuthorizationStatusDenied) {
                completion(NO,PrivacyPermissionAuthorizationStatusDenied);
            } else if (status == kCLAuthorizationStatusNotDetermined) {
                completion(NO,PrivacyPermissionAuthorizationStatusNotDetermined);
            } else if (status == kCLAuthorizationStatusRestricted) {
                completion(NO,PrivacyPermissionAuthorizationStatusRestricted);
            }
        }break;
            
        case PrivacyPermissionTypeBluetooth: {
            CBCentralManager *centralManager = [[CBCentralManager alloc] init];
            CBManagerState state = [centralManager state];
            if (state == CBManagerStateUnsupported || state == CBManagerStateUnauthorized || state == CBManagerStateUnknown) {
                completion(NO,PrivacyPermissionAuthorizationStatusDenied);
            } else {
                completion(YES,PrivacyPermissionAuthorizationStatusAuthorized);
            }
        }break;
            
        case PrivacyPermissionTypePushNotification: {
            if (@available(iOS 10.0, *)) {
                UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
                UNAuthorizationOptions types=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
                [center requestAuthorizationWithOptions:types completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    if (granted) {
                        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                            //
                        }];
                    } else {
                        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@""} completionHandler:^(BOOL success) { }];
                    }
                }];
            } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
                [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
            }
#pragma clang diagnostic pop
        }break;
            
        case PrivacyPermissionTypeSpeech: {
            [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
                if (status == SFSpeechRecognizerAuthorizationStatusDenied) {
                    completion(NO,PrivacyPermissionAuthorizationStatusDenied);
                } else if (status == SFSpeechRecognizerAuthorizationStatusNotDetermined) {
                    completion(NO,PrivacyPermissionAuthorizationStatusNotDetermined);
                } else if (status == SFSpeechRecognizerAuthorizationStatusRestricted) {
                    completion(NO,PrivacyPermissionAuthorizationStatusRestricted);
                } else if (status == SFSpeechRecognizerAuthorizationStatusAuthorized) {
                    completion(YES,PrivacyPermissionAuthorizationStatusAuthorized);
                }
            }];
        }break;
            
        case PrivacyPermissionTypeEvent: {
            EKEventStore *store = [[EKEventStore alloc] init];
            [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
                EKAuthorizationStatus status = [EKEventStore  authorizationStatusForEntityType:EKEntityTypeEvent];
                if (granted) {
                    completion(YES,PrivacyPermissionAuthorizationStatusAuthorized);
                } else {
                    if (status == EKAuthorizationStatusDenied) {
                        completion(NO,PrivacyPermissionAuthorizationStatusDenied);
                    } else if (status == EKAuthorizationStatusNotDetermined) {
                        completion(NO,PrivacyPermissionAuthorizationStatusNotDetermined);
                    } else if (status == EKAuthorizationStatusRestricted) {
                        completion(NO,PrivacyPermissionAuthorizationStatusRestricted);
                    }
                }
            }];
        }break;
            
        case PrivacyPermissionTypeContact: {
            CNContactStore *contactStore = [[CNContactStore alloc] init];
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
                if (granted) {
                    completion(YES,PrivacyPermissionAuthorizationStatusAuthorized);
                } else {
                    if (status == CNAuthorizationStatusDenied) {
                        completion(NO,PrivacyPermissionAuthorizationStatusDenied);
                    }else if (status == CNAuthorizationStatusRestricted){
                        completion(NO,PrivacyPermissionAuthorizationStatusNotDetermined);
                    }else if (status == CNAuthorizationStatusNotDetermined){
                        completion(NO,PrivacyPermissionAuthorizationStatusRestricted);
                    }
                }
            }];
        }break;
            
        case PrivacyPermissionTypeReminder: {
            EKEventStore *eventStore = [[EKEventStore alloc] init];
            [eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error) {
                EKAuthorizationStatus status = [EKEventStore  authorizationStatusForEntityType:EKEntityTypeEvent];
                if (granted) {
                    completion(YES,PrivacyPermissionAuthorizationStatusAuthorized);
                } else {
                    if (status == EKAuthorizationStatusDenied) {
                        completion(NO,PrivacyPermissionAuthorizationStatusDenied);
                    }else if (status == EKAuthorizationStatusNotDetermined){
                        completion(NO,PrivacyPermissionAuthorizationStatusNotDetermined);
                    }else if (status == EKAuthorizationStatusRestricted){
                        completion(NO,PrivacyPermissionAuthorizationStatusRestricted);
                    }
                }
            }];
        }break;
            
        default:
            break;
    }
}

@end
