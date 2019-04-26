//
//  LTDynamicDevice.m
//  UniversalApp
//
//  Created by 李桓宇 on 2019/4/26.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import "LTDynamicDevice.h"
@import CoreMotion;
@import CoreBluetooth;


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

+ (void)cleanContactCache
{
    
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
