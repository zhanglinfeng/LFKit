//
//  LFLogManager.h
//  APPBaseSDK
//
//  Created by 张林峰 on 16/7/2.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CocoaLumberjack.h"

/**
 用法：
 1.app启动是调用[LFLogManager install];
 2.PrefixHeader文件中加一句extern DDLogLevel ddLogLevel;（如果没有PrefixHeader则在所有要打印的类加这句）
 */

/**日志管理（自己打印的日志+崩溃日志+设置打印级别）*/
@interface LFLogManager : NSObject

@property (nonatomic, strong) DDFileLogger *fileLogger;

+ (instancetype)shareInstance;

+ (void)install;

/**设置打印级别*/
- (void)setLogLevel:(DDLogLevel)level;


@end
