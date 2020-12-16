//
//  LTURLRounter.m
//  UniversalApp
//
//  Created by huanyu.li on 2020/12/16.
//  Copyright © 2020 huanyu.li. All rights reserved.
//

#import "LTURLRounter.h"
#import "NSURL+LTRounter.h"

@interface LTURLRounter ()

@property (nonatomic, strong) LTURLHandlerItem *rootHandler;

@end

@implementation LTURLRounter

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LTURLRounter *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (nullable LTURLHandlerItem *)bestHandlerForURL:(NSURL *)url {
    // 这个可以取后端下发的白名单url，如果没有直接返回nil
    NSMutableArray *path = [NSMutableArray array];
    NSString *scheme = [NSString stringWithFormat:@"%@://", url.scheme];
    [path addObject:scheme];
    NSString *host = url.host;
    [path addObject:host];
    [path addObjectsFromArray:[url lt_pathComponents]];
    if (path.count == 0) {
        return nil;
    }
    
    NSMutableArray<LTURLHandlerItem *> *handlers = [NSMutableArray array];
    LTURLHandlerItem *handler = self.rootHandler;
    
    for (NSString *pathComponent in path) {
        LTURLHandlerItem *targetHandler = handler.handlerItemsDictionary[pathComponent];
        if (targetHandler && [targetHandler isKindOfClass:[LTURLHandlerItem class]]) {
            [handlers addObject:targetHandler];
            handler = targetHandler;
            if (handler.handlerItemsDictionary.count == 0) {
                break;
            }
        } else {
            break;
        }
    }

    LTURLHandlerItem *bestHandler = handlers.lastObject;
    return bestHandler;
}

#pragma mark - Getter

- (LTURLHandlerItem *)rootHandler {
    if (!_rootHandler) {
        LTURLHandlerItem *item = [[LTURLHandlerItem alloc] init];
        item.name = @"root";
        _rootHandler = item;
    }
    return _rootHandler;
}

@end
