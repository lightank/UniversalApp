//
//  LTBlockExample.m
//  UniversalApp
//
//  Created by 李桓宇 on 2018/12/14.
//  Copyright © 2018 huanyu.li. All rights reserved.
//

#import "LTBlockExample.h"

@interface LTBlockExample ()

@end

@implementation LTBlockExample

/*
 How Do I Declare A Block in Objective-C? @see http://goshdarnblocksyntax.com
 
 As a local variable:
 returnType (^blockName)(parameterTypes) = ^returnType(parameters) {...};
 
 As a property:
 @property (nonatomic, copy, nullability) returnType (^blockName)(parameterTypes);
 
 As a method parameter:
 - (void)someMethodThatTakesABlock:(returnType (^nullability)(parameterTypes))blockName;
 
 As an argument to a method call:
 [someObject someMethodThatTakesABlock:^returnType (parameters) {...}];
 
 As a typedef:
 typedef returnType (^TypeName)(parameterTypes);
 TypeName blockName = ^returnType(parameters) {...};
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
}

@end
