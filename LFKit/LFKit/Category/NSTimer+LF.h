//
//  NSTimer+LF.h
//  APPBaseSDK
//
//  Created by 张林峰 on 16/10/29.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (LF)

//暂停
- (void)pauseTimer;

//继续
- (void)resumeTimer;

//过一段时间再继续
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end
