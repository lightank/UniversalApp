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
@import Speech;
@import HealthKit;
@import MediaPlayer;
@import UserNotifications;
@import CoreBluetooth;
@import CoreLocation;

static LTPrivacyPermission *_instance = nil;

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

@end
