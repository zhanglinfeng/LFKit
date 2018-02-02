//
//  LFExceptionHandler.h
//  BaseAPP
//
//  Created by 张林峰 on 2018/1/23.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 用法：
app启动是调用[LFExceptionHandler installExceptionHandler];
 */

/**异常捕获*/
@interface LFExceptionHandler : NSObject

+ (void)installExceptionHandler;

@end
