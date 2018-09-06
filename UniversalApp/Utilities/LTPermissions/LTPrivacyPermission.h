//
//  LTPrivacyPermission.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/8/24.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

@import Foundation;
@import UIKit;

typedef NS_ENUM(NSUInteger, LTPrivacyPermissionType) {
    LTPrivacyPermissionTypePhoto = 0,
    LTPrivacyPermissionTypeCamera,
    LTPrivacyPermissionTypeMedia,
    LTPrivacyPermissionTypeMicrophone,
    LTPrivacyPermissionTypeLocation,
    LTPrivacyPermissionTypeBluetooth,
    LTPrivacyPermissionTypePushNotification,
    LTPrivacyPermissionTypeSpeech,
    LTPrivacyPermissionTypeEvent,
    LTPrivacyPermissionTypeContact,
    LTPrivacyPermissionTypeReminder,
};

typedef NS_ENUM(NSInteger, LTPrivacyPermissionAuthorizationStatus)
{
    LTPrivacyPermissionAuthorizationStatusAuthorized = 0,
    LTPrivacyPermissionAuthorizationStatusDenied,
    LTPrivacyPermissionAuthorizationStatusNotDetermined,
    LTPrivacyPermissionAuthorizationStatusRestricted,
    LTPrivacyPermissionAuthorizationStatusLocationAlways,
    LTPrivacyPermissionAuthorizationStatusLocationWhenInUse,
    LTPrivacyPermissionAuthorizationStatusUnkonwn,
};

@interface LTPrivacyPermission : NSObject

/* Methods for creating LTPrivacyPermission instances. */
@property (class, readonly, strong) LTPrivacyPermission *sharedPermission;

@end

/*
 
 <key>NSBluetoothPeripheralUsageDescription</key>
 <string>蓝牙/Bluetooth</string>
 <key>NSCalendarsUsageDescription</key>
 <string>日历/Calendars</string>
 <key>NSCameraUsageDescription</key>
 <string>相机/Camera</string>
 <key>NSContactsUsageDescription</key>
 <string>通讯录/Contacts</string>
 <key>NSFaceIDUsageDescription</key>
 <string>FaceID</string>
 <key>NSHealthShareUsageDescription</key>
 <string>健康数据分享/HealthShare</string>
 <key>NSHealthUpdateUsageDescription</key>
 <string>健康数据更新/HealthUpdate</string>
 <key>NSHomeKitUsageDescription</key>
 <string>HomeKit</string>
 <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
 <string>始终/使用期间使用位置信息/LocationAlwaysAndWhenInUse</string>
 <key>NSLocationWhenInUseUsageDescription</key>
 <string>使用期间访问位置</string>
 <key>NSLocationAlwaysUsageDescription</key>
 <string>始终使用位置信息/LocationAlways</string>
 <key>NSLocationUsageDescription</key>
 <string>位置信息/Location</string>
 <key>NSAppleMusicUsageDescription</key>
 <string>媒体资料库/Music</string>
 <key>NSMicrophoneUsageDescription</key>
 <string>麦克风/Microphone</string>
 <key>NSMotionUsageDescription</key>
 <string>运动与健身/Motion</string>
 <key>kTCCServiceMediaLibrary</key>
 <string>MediaLibrary</string>
 <key>NFCReaderUsageDescription</key>
 <string>NFCReader</string>
 <key>NSPhotoLibraryAddUsageDescription</key>
 <string>向相册添加/PhotoLibraryAdd</string>
 <key>NSPhotoLibraryUsageDescription</key>
 <string>相册/PhotoLibrary</string>
 <key>NSRemindersUsageDescription</key>
 <string>提醒事项/Reminders</string>
 <key>NSSiriUsageDescription</key>
 <string>Siri</string>
 <key>NSSpeechRecognitionUsageDescription</key>
 <string>语音识别/Speech Recognition</string>
 <key>NSVideoSubscriberAccountUsageDescription</key>
 <string>视频订阅账号/VideoSubscriberAccount</string>
 
 */
