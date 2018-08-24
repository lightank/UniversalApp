//
//  LTFirstViewController.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/25.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "LTFirstViewController.h"

@interface LTFirstViewController () <UIScrollViewDelegate> 

@end

@implementation LTFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"第一个";
    
    for (int i = 0; i < 4; i++) {
        UIImageView *image = [self imageViewWithColor:UIColorHex(0x1E90FF) size:CGSizeMake(kScreenWidth - 20.f, 44) direction:i];
        image.centerX = self.view.centerX;
        image.top = 86 + i * 44.f;
        [self.view addSubview:image];
    }
    

    CGFloat begain = 86 + 4 * 44.f + 10.f;
//    for (int i = 0; i < 4; i++) {
//        UIImageView *image = [self imageViewWithColorArray:@[UIColorHex(0x1E90FF), UIColorHex(0xBA55D3), UIColorHex(0xF47983), UIColorHex(0xF47983), UIColorHex(0xFFD700), UIColorHex(0x40E0D0)] size:CGSizeMake(kScreenWidth - 20.f, 44) direction:i];
//        image.centerX = self.view.centerX;
//        image.top = begain + i * 44.f;
//        [self.view addSubview:image];
//    }
    
    CGFloat begain2 = begain + 0 * 44.f + 10.f;
    for (int i = 0; i < 4; i++) {
        UIImageView *image = [self imageViewWithFromColor:UIColorHex(0x1E90FF) toColor:UIColorHex(0xBA55D3) size:CGSizeMake(kScreenWidth - 20.f, 44) direction:i];
        image.centerX = self.view.centerX;
        image.top = begain2 + i * 44.f;
        [self.view addSubview:image];
    }
    
    UIImage *image = [UIImage lt_imageWithFromColor:UIColorHex(0x1E90FF) toColor:UIColorHex(0xBA55D3) size:CGSizeMake(kScreenWidth - 20.f, 200.f) direction:LTGradientImageDirectionLeft];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[image lt_imageWithGradientAlphaDirection:LTGradientImageDirectionLeft]];
    imageView.centerX = self.view.centerX;
    imageView.top = begain2 + 4 * 44.f + 10.f;
    [self.view addSubview:imageView];
}

- (UIImageView *)imageViewWithFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor size:(CGSize)size direction:(LTGradientImageDirection)direction
{
    UIImage *image = [UIImage lt_imageWithFromColor:fromColor toColor:toColor size:size direction:direction];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView sizeToFit];
    return imageView;
}

- (UIImageView *)imageViewWithColorArray:(NSArray *)colorArray size:(CGSize)size direction:(LTGradientImageDirection)direction
{
    UIImage *image = [UIImage lt_imageWithColorArray:colorArray size:size direction:direction];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView sizeToFit];
    return imageView;
}

- (UIImageView *)imageViewWithColor:(UIColor *)color size:(CGSize)size direction:(LTGradientImageDirection)direction
{
    UIImage *image = [UIImage lt_imageWithColor:color size:size direction:direction];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView sizeToFit];
    return imageView;
}

@end
