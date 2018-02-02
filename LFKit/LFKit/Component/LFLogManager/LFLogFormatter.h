//
//  LFLogFormatter.h
//  APPBaseSDK
//
//  Created by 张林峰 on 16/7/2.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDLog.h"

/**日志格式*/
@interface LFLogFormatter : NSObject <DDLogFormatter> {
    int loggerCount;
    NSDateFormatter *threadUnsafeDateFormatter;
}

@end
