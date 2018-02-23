//
//  LFLogManager.m
//  APPBaseSDK
//
//  Created by 张林峰 on 16/7/2.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import "LFLogManager.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <CocoaLumberjack/DDContextFilterLogFormatter.h>

//异常捕获导入
#include <execinfo.h>
#include <libkern/OSAtomic.h>

#define DefaultLogLevelKey @"DefaultLogLevelKey"//默认等级的key
#define isSetLevelKey @"isSetLevelKey"//是否设置过日志等级的key

//异常捕获的key
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";


#ifdef DEBUG
DDLogLevel ddLogLevel = DDLogLevelInfo;
#else
DDLogLevel ddLogLevel = DDLogLevelError;
#endif


#pragma mark - 日志格式
/**日志格式*/
@interface LFLogFormatter : NSObject <DDLogFormatter>
{
    int loggerCount;
    NSDateFormatter *threadUnsafeDateFormatter;
}

@end

@implementation LFLogFormatter
- (id)init {
    if((self = [super init])) {
        threadUnsafeDateFormatter = [[NSDateFormatter alloc] init];
        [threadUnsafeDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
    }
    return self;
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *logLevel;
    switch (logMessage->_flag) {
        case DDLogFlagError    : logLevel = @"[Error]"; break;
        case DDLogFlagWarning  : logLevel = @"[Warning]"; break;
        case DDLogFlagInfo     : logLevel = @"[Info]"; break;
        case DDLogFlagDebug    : logLevel = @"[Debug]"; break;
        default                : logLevel = @"[Verbose]"; break;
    }
    
    NSString *dateAndTime = [threadUnsafeDateFormatter stringFromDate:(logMessage->_timestamp)];
    NSString *logMsg = logMessage->_message;
    
    return [NSString stringWithFormat:@"%@ %@ => %@\n", logLevel, dateAndTime, logMsg];
}

- (void)didAddToLogger:(id <DDLogger>)logger {
    loggerCount++;
    NSAssert(loggerCount <= 1, @"This logger isn't thread-safe");
}

- (void)willRemoveFromLogger:(id <DDLogger>)logger {
    loggerCount--;
}

@end




#pragma mark - 白名单日志格式

@interface LFWhiteListLogFormatter : DDContextWhitelistFilterLogFormatter
{
    NSDateFormatter *threadUnsafeDateFormatter;
}

@end

@implementation LFWhiteListLogFormatter
- (id)init {
    if((self = [super init])) {
        threadUnsafeDateFormatter = [[NSDateFormatter alloc] init];
        [threadUnsafeDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
    }
    return self;
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    
    NSString *dateAndTime = [threadUnsafeDateFormatter stringFromDate:(logMessage->_timestamp)];
    NSString *logMsg = logMessage->_message;
    
    return [NSString stringWithFormat:@"%@\n%@\n", dateAndTime, logMsg];
}


@end



#pragma mark - 异常捕获
/**异常捕获*/
@interface LFExceptionHandler : NSObject

+ (void)installExceptionHandler;

@end

@implementation LFExceptionHandler

+ (void)installExceptionHandler {

    //1.是由EXC_BAD_ACCESS引起的
    NSSetUncaughtExceptionHandler(UncaughtExceptionHandler);

    //2.向自身发送了SIGABRT信号而崩溃
    //    signal(SIGABRT, SignalHandler);
    //    signal(SIGILL, SignalHandler);
    //    signal(SIGSEGV, SignalHandler);
    //    signal(SIGFPE, SignalHandler);
    //    signal(SIGBUS, SignalHandler);
    //    signal(SIGPIPE, SignalHandler);
}


//1.是由EXC_BAD_ACCESS引起的
void UncaughtExceptionHandler(NSException *exception) {

    int32_t UncaughtExceptionCount = 0;
    int32_t UncaughtExceptionMaximum = 10;
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    // 如果太多不用处理
    if (exceptionCount > UncaughtExceptionMaximum) {
        return;
    }

    [LFExceptionHandler handleException:exception];
}

//2.向自身发送了SIGABRT信号而崩溃
void SignalHandler(int signal) {
    int32_t UncaughtExceptionCount = 0;
    int32_t UncaughtExceptionMaximum = 10;
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    // 如果太多不用处理
    if (exceptionCount > UncaughtExceptionMaximum) {
        return;
    }

    NSString* description = nil;
    switch (signal) {
        case SIGABRT:
            description = [NSString stringWithFormat:@"Signal SIGABRT was raised!\n"];
            break;
        case SIGILL:
            description = [NSString stringWithFormat:@"Signal SIGILL was raised!\n"];
            break;
        case SIGSEGV:
            description = [NSString stringWithFormat:@"Signal SIGSEGV was raised!\n"];
            break;
        case SIGFPE:
            description = [NSString stringWithFormat:@"Signal SIGFPE was raised!\n"];
            break;
        case SIGBUS:
            description = [NSString stringWithFormat:@"Signal SIGBUS was raised!\n"];
            break;
        case SIGPIPE:
            description = [NSString stringWithFormat:@"Signal SIGPIPE was raised!\n"];
            break;
        default:
            description = [NSString stringWithFormat:@"Signal %d was raised!",signal];
    }

    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    NSArray *callStack = [LFExceptionHandler backtrace];
    [userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
    [userInfo setObject:[NSNumber numberWithInt:signal] forKey:UncaughtExceptionHandlerSignalKey];

    [LFExceptionHandler handleException:[NSException exceptionWithName:@"Signal异常"
                                                                reason:description
                                                              userInfo:userInfo]];
}


+ (void)handleException:(NSException *)exception {
    NSString *exceptionInfo = [NSString stringWithFormat:@"\n======异常错误报告======\n名称:%@\n原因:%@\nuserInfo:%@\n堆栈:%@\n======异常错误报告完毕======\n\n",exception.name, exception.reason, exception.userInfo ? : @"no user info", [[exception callStackSymbols] componentsJoinedByString:@"\n"]];

    DDLogError(@"%@", exceptionInfo);
}

//获取调用堆栈
+ (NSArray *)backtrace {

    //指针列表
    void* callstack[128];
    //backtrace用来获取当前线程的调用堆栈，获取的信息存放在这里的callstack中
    //128用来指定当前的buffer中可以保存多少个void*元素
    //返回值是实际获取的指针个数
    int frames = backtrace(callstack, 128);
    //backtrace_symbols将从backtrace函数获取的信息转化为一个字符串数组
    //返回一个指向字符串数组的指针
    //每个字符串包含了一个相对于callstack中对应元素的可打印信息，包括函数名、偏移地址、实际返回地址
    char **strs = backtrace_symbols(callstack, frames);

    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (i = 0; i < frames; i++) {

        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);

    return backtrace;
}

@end






#pragma mark - 日志管理
@interface LFLogManager ()

@property (nonatomic, strong) DDFileLogger *fileLogger;

@end

@implementation LFLogManager


+ (instancetype)shareInstance {
    static LFLogManager *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[[self class] alloc]init];
        [shareInstance configureLog];
        [LFExceptionHandler installExceptionHandler];
    });
    return shareInstance;
}

- (void)configureLog {
    _dicFileLogger = [[NSMutableDictionary alloc] init];
    self.maximumFileSize = 1024 * 1024;
    self.rollingFrequency = 60 * 60 * 24;
    self.maximumNumberOfLogFiles = 7;
    
    BOOL isSetLevel = [[NSUserDefaults standardUserDefaults] boolForKey:isSetLevelKey];
    if (isSetLevel) {
        ddLogLevel = [[NSUserDefaults standardUserDefaults] integerForKey:DefaultLogLevelKey];
    }
    
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
    
}

/**默认安装*/
- (void)install {
    self.fileLogger = [[DDFileLogger alloc] init];
    self.fileLogger.rollingFrequency = self.rollingFrequency; // 24 hour rolling
    self.fileLogger.logFileManager.maximumNumberOfLogFiles = self.maximumNumberOfLogFiles;
    self.fileLogger.maximumFileSize = self.maximumFileSize;
    
    //log文件
    [DDLog addLogger:self.fileLogger withLevel:DDLogLevelAll];

}

/**自定义等级安装，分文件保存日志*/
- (void)installWithLevels:(NSArray<NSNumber*>*)levels path:(NSString *)path {
    if ([self.dicFileLogger.allKeys containsObject:path] || levels.count < 1 || path.length < 1) {
        return;
    }
    
    DDLogFileManagerDefault *fileManager = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:path];
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:fileManager];
    fileLogger.rollingFrequency = self.rollingFrequency; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = self.maximumNumberOfLogFiles;
    fileLogger.maximumFileSize = self.maximumFileSize;
    
    LFWhiteListLogFormatter *formatter = [[LFWhiteListLogFormatter alloc] init];
    for (NSNumber *number in levels) {
        [formatter addToWhitelist:number.integerValue];
    }
    [fileLogger setLogFormatter:formatter];
    //log文件
    [DDLog addLogger:fileLogger withLevel:DDLogLevelAll];
    
    [_dicFileLogger setObject:fileLogger forKey:path];
}




/**获取日志文件，数组中元素DDLogFileInfo*/
- (NSArray *)getLogFilesWithPath:(NSString *)path {
    DDFileLogger *fileLogger = [self.dicFileLogger objectForKey:path];
    return fileLogger.logFileManager.sortedLogFileInfos;
}

/**获取所有日志文件，数组中元素DDLogFileInfo*/
- (NSArray *)getAllLogFiles {
    if (!self.fileLogger) {
        return nil;
    }
    return self.fileLogger.logFileManager.sortedLogFileInfos;
}


- (void)setLogLevel:(NSInteger)level {
    ddLogLevel = level;
    [[NSUserDefaults standardUserDefaults] setInteger:ddLogLevel forKey:DefaultLogLevelKey];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isSetLevelKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end

