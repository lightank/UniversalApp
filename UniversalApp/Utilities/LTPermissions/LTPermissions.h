//
//  LTPermissions.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/8/24.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, LTPermissionType) {
    LTPermissionTypeLocation,
    LTPermissionTypeCamera,
    LTPermissionTypePhotos,
    LTPermissionTypeContacts,
//    LTPermissionType,
//    LTPermissionType,
//    LTPermissionType,
//    LTPermissionType,
//    LTPermissionType,
//    LTPermissionType,
//    LTPermissionType,
};

typedef NS_ENUM(NSInteger,LBXPermissionType)
{
    LBXPermissionType_Location,
    LBXPermissionType_Camera,
    LBXPermissionType_Photos,
    LBXPermissionType_Contacts,
    LBXPermissionType_Reminders,
    LBXPermissionType_Calendar,
    LBXPermissionType_Microphone,
    LBXPermissionType_Health,
    LBXPermissionType_Network
};

@interface LTPermissions : NSObject

@end
