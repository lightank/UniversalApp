//
//  UITableViewCell+LTAdd.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/8/28.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (LTAdd)

+ (NSString *)lt_reuseIdentifier;

@end

/*
 指定构造器
 - (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
 
 以下几种类型
 typedef NS_ENUM(NSInteger, UITableViewCellStyle) {
 UITableViewCellStyleDefault,    // Simple cell with text label and optional image view (behavior of UITableViewCell in iPhoneOS 2.x)
 UITableViewCellStyleValue1,        // Left aligned label on left and right aligned label on right with blue text (Used in Settings)
 UITableViewCellStyleValue2,        // Right aligned label on left with blue text and left aligned label on right (Used in Phone/Contacts)
 UITableViewCellStyleSubtitle    // Left aligned label on top and left aligned label on bottom with gray text (Used in iPod).
 };             // available in iPhone OS 3.0

 
 UITableViewCellStyleDefault:
 左边:一张图，一个左对齐的标题
 |--------------------------------------------------|
 |                                                  |
 | |------------| |----------------------|          |
 | | imageView  | |左对齐的textLabel      |          |
 | |____________| |_____________________|           |
 |                                                  |
 |--------------------------------------------------|

 
 UITableViewCellStyleValue1:
 左边:一张图,一个左对齐的主标题，右边一个右对齐的副主题
 |-----------------------------------------------------------------------|
 |                                                                       |
 | |------------| |----------------------|  |-------------------------|  |
 | |  imageView | |左对齐的textLabel      |  |    右对齐的detailTextLabel|  |
 | |____________| |_____________________|  |__________________________|  |
 |                                                                       |
 |-----------------------------------------------------------------------|
 
 
 UITableViewCellStyleValue2:
 一个主标题,一个副标题
 |---------------------------------------------------------------|
 |                                                               |
 | |--------------------------| |--------------------------|     |
 | |          右对齐的textLabel| |左对齐的detailTextLabel     |     |
 | |_________________________| |___________________________|     |
 |                                                               |
 |---------------------------------------------------------------|
 
 
 UITableViewCellStyleSubtitle:
 一张图，一个主标题，一个副标题（副标题在主标题下面）
 |---------------------------------------------------------------|
 |                                                               |
 | |------------| |----------------------|                       |
 | |            | |左对齐的textLabel      |                        |
 | |            | |_____________________|                        |
 | | imageView  | |------------------------|                     |
 | |            | |左对齐的detailTextLabel  |                      |
 | |____________| |_______________________|                      |
 |                                                               |
 |---------------------------------------------------------------|
 
 */
