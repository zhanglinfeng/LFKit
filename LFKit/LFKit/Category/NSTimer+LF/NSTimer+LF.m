//
//  NSTimer+LF.m
//  APPBaseSDK
//
//  Created by 张林峰 on 16/10/29.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import "NSTimer+LF.h"

@implementation NSTimer (LF)

-(void)pauseTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate distantFuture]];//暂停， distantFuture（不可达到的未来的某个时间点）
    
}


-(void)resumeTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate date]];//继续
}

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
