//
//  LTThirdViewController.m
//  UniversalApp
//
//  Created by 李桓宇 on 2019/8/6.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import "LTThirdViewController.h"
#import "LTPrivacyPermission.h"
#import "LTDynamicDevice.h"
#import "LTDBManager.h"

@interface LTThirdViewController ()

@end

@implementation LTThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [LTPrivacyPermission.sharedPermission accessPrivacyPermissionWithType:LTPrivacyPermissionTypeContact completion:^(BOOL authorized, LTPrivacyPermissionType type, LTPrivacyPermissionAuthorizationStatus status) {
        [LTDynamicDevice accessContacts:^(NSArray<LTContact *> * _Nonnull contacts) {
            NSArray *tempContacts = contacts;
            [contacts enumerateObjectsUsingBlock:^(LTContact * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSLog(@"%@", tempContacts);
                [LTDBManager insertContact:obj];
                [LTDBManager insertContact:obj];
                NSArray *contacts222 = [LTDBManager allContacts];
                NSLog(@"");
            }];

            NSArray *contacts222 = [LTDBManager allContacts];
            NSLog(@"");
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                NSArray *contacts = [LTDBManager allContacts];
//                NSLog(@"");
//            });
        }];
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
