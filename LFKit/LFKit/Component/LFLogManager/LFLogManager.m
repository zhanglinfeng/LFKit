//
//  LFLogManager.m
//  APPBaseSDK
//
//  Created by 张林峰 on 16/7/2.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import "LFLogManager.h"
#import "LFLogFormatter.h"
//#import "LFExceptionHandler.h"

#define DefaultLogLevelKey @"DefaultLogLevelKey"//默认等级的key
#define isSetLevelKey @"isSetLevelKey"//是否设置过日志等级的key

#ifdef DEBUG
DDLogLevel ddLogLevel = DDLogLevelInfo;
#else
DDLogLevel ddLogLevel = DDLogLevelError;
#endif

@implementation LFLogManager

+ (instancetype)shareInstance {
    static id shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[[self class] alloc]init];
    });
    return shareInstance;
}

+ (void)install {
    BOOL isSetLevel = [[NSUserDefaults standardUserDefaults] boolForKey:isSetLevelKey];
    if (isSetLevel) {
        ddLogLevel = [[NSUserDefaults standardUserDefaults] integerForKey:DefaultLogLevelKey];
    }
    
    [[LFLogManager shareInstance] configureLog];
//    [LFExceptionHandler installExceptionHandler];
}

- (void)configureLog
{
#ifdef DEBUG
    //发送日志语句到苹果的日志系统，以便它们显示在Console.app上
//    [DDLog addLogger:[DDASLLogger sharedInstance] withLevel:DDLogLevelDebug];
    //发送日志语句到Xcode控制台
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
#endif
    
    // 允许颜色
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    //自定义log格式
    [DDTTYLogger sharedInstance].logFormatter = [[LFLogFormatter alloc] init];
    //log文件
    [DDLog addLogger:self.fileLogger withLevel:DDLogLevelAll];
}

- (void)setLogLevel:(DDLogLevel)level {
    ddLogLevel = level;
    [[NSUserDefaults standardUserDefaults] setInteger:ddLogLevel forKey:DefaultLogLevelKey];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isSetLevelKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (DDFileLogger *)fileLogger
{
    if (!_fileLogger) {
        DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
        fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
        fileLogger.maximumFileSize = 1024*1024;
        _fileLogger = fileLogger;
    }
    
    return _fileLogger;
}


@end
