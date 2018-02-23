//
//  LFLogManager.h
//  APPBaseSDK
//
//  Created by 张林峰 on 16/7/2.
//  Copyright © 2016年 张林峰. All rights reserved.
//


// 过期提醒
#define LFLogManagerDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

#import <Foundation/Foundation.h>

/**
 用法：
 1.PrefixHeader文件中加一句extern DDLogLevel ddLogLevel;（如果没有PrefixHeader则在大家都引用的头文件加这句）
 2.app启动是调用[[LFLogManager shareInstance] install];
 
 
 如果要自定义打印级别和日志路径：
 1.PrefixHeader文件中
 #import <CocoaLumberjack/DDLog.h>
 extern DDLogLevel ddLogLevel;
 #define XXLOG_LEVEL1 (1 << 5)
 #define XXLOG_LEVEL2 (1 << 6)
 #define XXLog1(frmt, ...) LOG_MAYBE(YES, ddLogLevel, (1 << 0), XXLOG_LEVEL1, __PRETTY_FUNCTION__,frmt, ## __VA_ARGS__)
 #define XXLog2(frmt, ...) LOG_MAYBE(YES, ddLogLevel, (1 << 1), XXLOG_LEVEL2, __PRETTY_FUNCTION__,frmt, ## __VA_ARGS__)
 
 2.app启动是调用
 //自定义log1
 [[LFLogManager shareInstance] installWithLevels:@[@(LFLOG_LEVEL1),@(LFLOG_LEVEL2)] path:filePath];
 
 //自定义log2（
 [[LFLogManager shareInstance] installWithLevels:@[@(XXLOG_LEVEL1),@(XXLOG_LEVEL2)] path:filePath2];
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

+ (void)install LFLogManagerDeprecated("类方法install已弃用，请使用实例方法install");

/**一般安装（所有DDLog的日志）*/
- (void)install;

/**自定义安装（自定义等级、文件路径日志）（可与上面的默认安装二者选其一，或者二者都要也行）*/
- (void)installWithLevels:(NSArray<NSNumber*>*)levels path:(NSString *)path;

/**获取某路径日志文件，数组中元素DDLogFileInfo*/
- (NSArray *)getLogFilesWithPath:(NSString *)path;

/**获取所有日志文件，数组中元素DDLogFileInfo*/
- (NSArray *)getAllLogFiles;

/**获取日志文件，数组中元素DDLogFileInfo*/
- (NSArray *)getLogFiles LFLogManagerDeprecated("已弃用，请使用getAllLogFiles方法");

/**设置打印级别*/
- (void)setLogLevel:(NSInteger)level;


@end
