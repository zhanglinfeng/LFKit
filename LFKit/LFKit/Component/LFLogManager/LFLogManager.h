//
//  LFLogManager.h
//  APPBaseSDK
//
//  Created by 张林峰 on 16/7/2.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 用法：
 1.app启动是调用[LFLogManager install];
 2.PrefixHeader文件中加一句extern DDLogLevel ddLogLevel;（如果没有PrefixHeader则在所有要打印的类加这句）
 */

/**日志管理（自己打印的日志+崩溃日志+设置打印级别）*/
@interface LFLogManager : NSObject

//存放自定义文件FileLogger的字典，key是path
@property (nonatomic, strong, readonly) NSMutableDictionary *dicFileLogger;

//注意：以下属性需在install之前设置
//单个文件最大size，默认1024*1024
@property (readwrite, assign) unsigned long long maximumFileSize;

//本次日志距上次创文件超过rollingFrequency秒后新建文件，默认60 * 60 * 24，24小时
@property (readwrite, assign) NSTimeInterval rollingFrequency;

//最大文件数，默认7
@property (readwrite, assign, atomic) NSUInteger maximumNumberOfLogFiles;


+ (instancetype)shareInstance;

/**一般安装（所有DDLog的日志）*/
- (void)install;

/**自定义安装（自定义等级、文件路径日志）（可与上面的默认安装二者选其一，或者二者都要也行）*/
- (void)installWithLevels:(NSArray<NSNumber*>*)levels path:(NSString *)path;

/**获取某路径日志文件，数组中元素DDLogFileInfo*/
- (NSArray *)getLogFilesWithPath:(NSString *)path;

/**获取所有日志文件，数组中元素DDLogFileInfo*/
- (NSArray *)getAllLogFiles;

/**设置打印级别*/
- (void)setLogLevel:(NSInteger)level;


@end
