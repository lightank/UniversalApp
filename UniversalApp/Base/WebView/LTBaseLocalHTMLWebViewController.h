//
//  LTBaseLocalHTMLWebViewController.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/24.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import <UIKit/UIKit.h>
@import WebKit;

@interface LTBaseLocalHTMLWebViewController : UIViewController

/**
 加载本地html文件,拖资源文件到xcode里的时候,请选择:Copy items if needed , Create folder references,这样导进来的文件是有文件目录的,html文件里引用js:./,如果是:/,是不能正确加载js的,可以用Safari浏览器测试一下,确认能正确加载js/css资源
 
 @param name 文件名,不包含html后缀
 @param folderName html所在文件夹名字
 */
- (void)loadLocalHTML:(NSString *)name folderName:(NSString *)folderName;

@end
