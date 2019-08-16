//
//  LTDynamicDevice.h
//  UniversalApp
//
//  Created by 李桓宇 on 2019/4/26.
//  Copyright © 2019 huanyu.li. All rights reserved.
//  动态获取的设备数据

#import <Foundation/Foundation.h>
#import "LTContact.h"

/**
 陀螺仪数据回调block

 @param isGyroAvailable 陀螺仪是否可用
 @param isGyroActive 陀螺仪在可用情况下,是否开启
 @param x 陀螺仪开启情况下的x值
 @param y 陀螺仪开启情况下的y值
 @param z 陀螺仪开启情况下的z值
 */
typedef void(^LTDeviceGyroDataBlock)(BOOL isGyroAvailable, BOOL isGyroActive, double x, double y, double z);

typedef void(^LTDeviceBluetoothBlock)(BOOL isOpenBluetooth);

typedef void(^LTDeviceContactBlock)(NSArray <LTContact *> * _Nonnull contacts);
typedef void(^LTDeviceSortedContactBlock)(NSDictionary <NSString *, NSArray<LTContact *> *> * _Nonnull contactDictionary, NSArray<NSString *> * _Nonnull nameKeys);

NS_ASSUME_NONNULL_BEGIN

@interface LTDynamicDevice : NSObject

#pragma mark - 蓝牙
+ (void)isOpenBluetooth:(LTDeviceBluetoothBlock)completeBlock;

#pragma mark - 陀螺仪
/**
 获取陀螺仪数据

 @param completeBlock 完成回调
 @param gyroUpdateInterval 陀螺仪更新时间间隔
 @param stop 是否当获取数据成功后停止获取,如果为NO,则需要在block回调第一行里手动调用+ (void)stopGyroUpdates,不然可能收到多次回调
 */
+ (void)gyroData:(LTDeviceGyroDataBlock)completeBlock
  updateInterval:(NSTimeInterval)gyroUpdateInterval
 stopWhenSuccess:(BOOL)stop;

/**  停止获取陀螺仪  */
+ (void)stopGyroUpdates;

#pragma mark - 通讯录
+ (void)accessContacts:(LTDeviceContactBlock)completeBlock;
+ (void)accessSortedContacts:(LTDeviceSortedContactBlock)completeBlock;

+ (void)showContactPicker:(LTDeviceContactBlock)block;

@end

NS_ASSUME_NONNULL_END
