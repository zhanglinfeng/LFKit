//
//  LFTimeUtil.h
//  APPBaseSDK
//
//  Created by 张林峰 on 16/5/31.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LFTimeUtil : NSObject

/**
 秒数转为时长字符串

 @param second 秒数
 @param format 格式如@"HH:mm:ss" @"mm分ss秒"
 @return 时长字符串
 */
+ (NSString *)getTimeStringFromSecond:(NSInteger)second format:(NSString *)format;

/**时间戳(毫秒)转时间字符串*/
+ (NSString *)getDateTimeStringFromTimestamp:(NSString *)timestamp formatter:(NSString *)formatter;

/**Date转时间字符串*/
+ (NSString *)getDateTimeStringFromDate:(NSDate *)date formatter:(NSString *)formatter;

/**时间字符串转时间戳（毫秒）*/
+ (NSString *)getTimestampFromDateTimeString:(NSString *)string formatter:(NSString *)formatter;

/**时间字符串转NSDate*/
+ (NSDate *)getDateFromDateTimeString:(NSString *)string formatter:(NSString *)formatter;

/**NSDate 转 时间戳（毫秒）*/ 
+ (NSString *)getTimestampStringFromDate:(NSDate *)date;

/**时间戳（毫秒）转n小时、分钟、秒前 或者yyyy-MM-dd HH:mm:ss*/
+ (NSString *)getBeforeTimeFromDate:(NSString*)strDate;

/**  时间戳根据格式返回数据 HH:mm、昨天 HH:mm、MM月dd日 HH:mm、yyyy年MM月dd日)*/
- (NSString *)getVariableFormatDateStringFromTimestamp:(NSString *)timestamp;

@end
