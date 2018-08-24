//
//  LTSandboxTool.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/20.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

/*
 沙盒
	Bundle Container
        MyApp.app:由于应用程序必须经过签名，所以不能在运行时对这个目录中的内容进行修改，否则会导致应用程序无法启动
	Data Container
        Documents:保存应用运行时生成的需要持久化的数据,iTunes会自动备份该目录。苹果建议将在应用程序中浏览到的文件数据保存在该目录下。
        Library:
            Caches: 一般存储的是缓存文件，例如图片视频等，此目录下的文件不会在应用程序退出时删除。
                    *在手机备份的时候，iTunes不会备份该目录。例如音频,视频等文件存放其中
            Preferences:保存应用程序的所有偏好设置iOS的Settings(设置)，我们不应该直接在这里创建文件，而是需要通过NSUserDefault这个类来访问应用程序的偏好设置。
                        *iTunes会自动备份该文件目录下的内容。比如说:是否允许访问图片,是否允许访问地理位置......
        tmp:临时文件目录，在程序重新运行的时候，和开机的时候，会清空tmp文件夹
	iCloud Container
        …
 */

#import "LTSandboxTool.h"
#import "NSString+Hash.h"

@implementation LTSandboxTool
/**  判断文件或文件夹是否存在  */
+ (BOOL)fileExistsAtPath:(NSString *)path;
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

//单个文件的大小
+ (long long)fileSizeAtPath:(NSString*)filePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath])
    {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//遍历文件夹获得文件夹大小，返回多少M
+ (float)folderSizeAtPath:(NSString*)folderPath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath])
    {
        return 0.0;
    }
    NSEnumerator *childFilesEnumerator=[[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName = nil;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject])!=nil)
    {
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize / (1024.0 * 1024.0);
}

+ (BOOL)writeDataItem:(NSData *)itemData withName:(NSString *)savedName toFolder:(NSString *)folderPath
{
    BOOL success = NO;
    [self createFolder:folderPath];
    NSString *filePath = [folderPath stringByAppendingPathComponent:savedName];
    
    success = [[NSFileManager defaultManager] createFileAtPath:filePath contents:itemData attributes:nil];
    return success;
}

+ (BOOL)createFolder:(NSString *)folderPath
{
    if ([self fileExistsAtPath:folderPath]) return YES;

    BOOL success = NO;

    __block NSArray<NSString *> *sandbox = @[@"Documents", @"Library", @"Caches", @"Preferences", @"tmp"];
    __block NSArray<NSString *> *fileNameArray = [folderPath componentsSeparatedByString:@"/"];
    __block NSMutableArray *indexArray = [NSMutableArray array];
    [sandbox enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [indexArray addObject:@([self lastIndexOfString:obj inArray:fileNameArray])];
    }];
    
    [indexArray sortUsingComparator:^NSComparisonResult(NSNumber * _Nonnull num1, NSNumber * _Nonnull num2) {
        int v1 = [num1 intValue];
        int v2 = [num2 intValue];
        
        if (v1 < v2)
        {
            return NSOrderedAscending;
        }
        else if (v1 > v2)
        {
            return NSOrderedDescending;
        }
        else
        {
            return NSOrderedSame;
        }
    }];
    
    NSUInteger start = [indexArray.lastObject integerValue];
    start = ((start + 1) <= (fileNameArray.count - 1)) ? (start + 1) : (fileNameArray.count - 1);
    NSArray *subArray = [fileNameArray subarrayWithRange:NSMakeRange(0, start)];
    NSString *startString = [subArray componentsJoinedByString:@"/"];
    
    for (; start < fileNameArray.count; ++start)
    {
        startString = [self createFolder:fileNameArray[start] inFolderName:startString];
        if ([self fileExistsAtPath:folderPath])
        {
            success = YES;
            break;
        }
    }
    
    return success;
}

+ (NSUInteger)lastIndexOfString:(NSString *)string inArray:(NSArray<NSString *>*)array
{
    __block NSUInteger index = 0;
    [array enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:string])
        {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}

//清除指定文件
+ (BOOL)clearItemAtPath:(NSString *)filePath
{
    NSError *error = nil;
    BOOL success = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    }
    
    return success;
}

//清除指定文件夹缓存
+ (BOOL)clearfolderItemsAtPath:(NSString *)folderPath
{
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:folderPath];
    BOOL success = NO;
    for (NSString *item in files)
    {
        NSError *error = nil;
        NSString *path = [folderPath stringByAppendingPathComponent:item];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
        success = YES;
    }
    return success;
}


#pragma mark - 二进制和资源包的自检
/**  app的二进制包路径  */
+ (NSString *)applicationBinaryPath
{
    NSString *excutableName = [[NSBundle mainBundle] infoDictionary][@"CFBundleExecutable"];
    NSString *tmpPath = [[[UIApplication sharedApplication] documentsPath] stringByDeletingLastPathComponent];
    NSString *appPath = [[tmpPath stringByAppendingPathComponent:excutableName]
                         stringByAppendingPathExtension:@"app"];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.f)
    {
        appPath = [[NSBundle mainBundle] bundlePath];
    }
    NSString *binaryPath = [appPath stringByAppendingPathComponent:excutableName];
    return binaryPath;
}
/**  app的二进制包SHA256Hash  */
+ (NSString *)applicationBinarySHA256Hash
{
    return [[self applicationBinaryPath] lt_fileSHA256Hash];
}
/**  app的所有资源校验码路径,可通过修改为.plist文件来访问  */
+ (NSString *)applicationCodeResourcesPath
{
    NSString *excutableName = [[NSBundle mainBundle] infoDictionary][@"CFBundleExecutable"];
    NSString *tmpPath = [[[UIApplication sharedApplication] documentsPath] stringByDeletingLastPathComponent];
    NSString *appPath = [[tmpPath stringByAppendingPathComponent:excutableName]
                         stringByAppendingPathExtension:@"app"];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.f)
    {
        appPath = [[NSBundle mainBundle] bundlePath];
    }
    NSString *sigPath = [[appPath stringByAppendingPathComponent:@"_CodeSignature"]
                         stringByAppendingPathComponent:@"CodeResources"];
    return sigPath;
}
/**  app的所有资源校验码路径SHA256Hash  */
+ (NSString *)applicationCodeResourcesSHA256Hash
{
    return [[self applicationCodeResourcesPath] lt_fileSHA256Hash];
}

#pragma mark - 文件相关操作


#pragma mark - 文件夹相关操作
+ (NSString *)createFolderInCachesDirectoryWithFolderName:(NSString *)folderName
{
    return [LTSandboxTool createFolder:folderName inDirectory:NSCachesDirectory];
}

+ (NSString *)createFolder:(NSString *)folderName inDirectory:(NSSearchPathDirectory)directory
{
    NSString *directoryPath = [LTSandboxTool pathForDirectory:directory];
    NSString *path = [self createFolder:folderName inFolderName:directoryPath];
    return path;
}

+ (NSString *)createFolder:(NSString *)folderName inFolderName:(NSString *)folderPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSString stringWithFormat:@"%@/%@",folderPath, folderName];
    BOOL isDir = NO;;
    BOOL result = NO;
    if  (![fileManager fileExistsAtPath:path isDirectory:&isDir])   //先判断目录是否存在，不存在才创建
    {
        result = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        path = result ? path : nil;
    }
    return path;
}

#pragma mark - 系统路径相关类方法
+ (NSURL *)URLForDirectory:(NSSearchPathDirectory)directory
{
    return [NSFileManager.defaultManager URLsForDirectory:directory inDomains:NSUserDomainMask].lastObject;
}

+ (NSString *)pathForDirectory:(NSSearchPathDirectory)directory
{
    return NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES).firstObject;
}

+ (NSURL *)documentsURL
{
    return [self URLForDirectory:NSDocumentDirectory];
}

+ (NSString *)documentsPath
{
    return [self pathForDirectory:NSDocumentDirectory];
}

+ (NSURL *)libraryURL
{
    return [self URLForDirectory:NSLibraryDirectory];
}

+ (NSString *)libraryPath
{
    return [self pathForDirectory:NSLibraryDirectory];
}

+ (NSURL *)cachesURL
{
    return [self URLForDirectory:NSCachesDirectory];
}

+ (NSString *)cachesPath
{
    return [self pathForDirectory:NSCachesDirectory];
}

+ (BOOL)addSkipBackupAttributeToFile:(NSString *)path
{
    return [[NSURL.alloc initFileURLWithPath:path] setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
}

+ (double)availableDiskSpace
{
    NSDictionary *attributes = [NSFileManager.defaultManager attributesOfFileSystemForPath:self.documentsPath error:nil];
    
    return [attributes[NSFileSystemFreeSize] unsignedLongLongValue] / (double)0x100000;
}

@end
