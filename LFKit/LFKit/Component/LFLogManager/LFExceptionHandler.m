//
//  LFExceptionHandler.m
//  BaseAPP
//
//  Created by 张林峰 on 2018/1/23.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import "LFExceptionHandler.h"
#include <execinfo.h>
#include <libkern/OSAtomic.h>
#import "DDLog.h"

extern DDLogLevel ddLogLevel;

NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";

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
