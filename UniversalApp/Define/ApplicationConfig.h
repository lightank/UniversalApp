//
//  ApplicationConfig.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/10/15.
//  Copyright © 2018 huanyu.li. All rights reserved.
//

#ifndef ApplicationConfig_h
#define ApplicationConfig_h

/*
 DEV(Development):开发环境,专门用于开发的服务器,配置可以比较随意,为了开发调试方便,一般打开全部错误报告。
 SIT(System Integration Testing):系统内部集成测试,开发人员自己测试流程是否走通。如果开发人员足够，通常还会在SIT之前引入代码审查机制（Code Review）来保证软件符合客户需求且流程正确。
 UAT(User Acceptance Testing):用户验收测试,由专门的测试人员验证，验收完成才能上生产环境。
 PROD(Production Environment)：生产环境,是指正式提供对外服务的，一般会关掉错误报告，打开错误日志。可以理解为包含所有的功能的环境，任何项目所使用的环境都以这个为基础，然后根据客户的个性化需求来做调整或者修改。
 */

#ifdef DEBUG
// Debug模式

#else
// Release模式

#endif


#ifdef DEV
// DEV环境
#definede kBaseURL @"https://127.0.0.1/"

#endif

#ifdef SIT
// SIT环境
#definede kBaseURL @"https://127.0.0.2/"

#endif

#ifdef UAT
// UAT环境
#definede kBaseURL @"https://127.0.0.3/"

#endif

#ifdef PROD
// PROD环境
#definede kBaseURL @"https://127.0.0.4/"

#endif


#endif /* ApplicationConfig_h */
