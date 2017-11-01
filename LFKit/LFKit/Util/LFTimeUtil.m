//
//  LFTimeUtil.m
//  APPBaseSDK
//
//  Created by 张林峰 on 16/5/31.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import "LFTimeUtil.h"
#import "NSDate+LF.h"

@implementation LFTimeUtil

+ (NSString *)getTimeStringFromSecond:(NSInteger)second format:(NSString *)format {
    NSInteger seconds = second % 60;
    NSInteger minutes = (second / 60) % 60;
    NSInteger hours = ((second / 60) / 60) % 24;
    NSInteger day = ((second / 60) / 60) / 24;
    if (![format containsString:@"dd"]) {
        hours = day * 24 + hours;
    }
    if (![format containsString:@"HH"]) {
        minutes = hours * 60 + minutes;
    }
    
    if (![format containsString:@"mm"]) {
        seconds = minutes * 60 + seconds;
    }
    
    format = [format stringByReplacingOccurrencesOfString:@"dd" withString:[NSString stringWithFormat:@"%02zi",day]];
    format = [format stringByReplacingOccurrencesOfString:@"HH" withString:[NSString stringWithFormat:@"%02zi",hours]];
    format = [format stringByReplacingOccurrencesOfString:@"mm" withString:[NSString stringWithFormat:@"%02zi",minutes]];
    format = [format stringByReplacingOccurrencesOfString:@"ss" withString:[NSString stringWithFormat:@"%02zi",seconds]];
    return format;
}


/**时间戳(毫秒)转时间字符串*/
+ (NSString *)getDateTimeStringFromTimestamp:(NSString *)timestamp formatter:(NSString *)formatter {
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:formatter];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestamp longLongValue] / 1000];
    NSString *str = [dateformatter stringFromDate:date];
    return str;
}

/**Date转时间字符串*/
+ (NSString *)getDateTimeStringFromDate:(NSDate *)date formatter:(NSString *)formatter{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    NSString *currentDate = [dateFormatter stringFromDate:date];
    return currentDate;
}

/**时间字符串转时间戳（毫秒）*/
+ (NSString *)getTimestampFromDateTimeString:(NSString *)string formatter:(NSString *)formatter{
    NSDate *date = [self getDateFromDateTimeString:string formatter:formatter];
    long long timeInterval = [date timeIntervalSince1970] * 1000;
    return [NSString stringWithFormat:@"%lli",timeInterval];
}

/**NSDate 转 时间戳（毫秒）*/
+ (NSString *)getTimestampStringFromDate:(NSDate *)date {
    long long timeInterval = [date timeIntervalSince1970] * 1000;
    return [NSString stringWithFormat:@"%lli",timeInterval];
}

/**时间字符串转NSDate*/
+ (NSDate *)getDateFromDateTimeString:(NSString *)string formatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    NSDate *date = [dateFormatter dateFromString:string];
    return date;
}

+ (NSString *)getBeforeTimeFromDate:(NSString*)strDate {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:strDate.longLongValue/1000];
    NSString * strBefore = @"";
    if (date && (id)date != [NSNull null]) {
        NSInteger interval = -(NSInteger)[date timeIntervalSinceNow];
        NSInteger nDay = interval / (60 * 60 * 24);
        NSInteger nHour = interval / (60 * 60);
        NSInteger nMin = interval / 60;
        NSInteger nSec = interval;
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        
        if (nDay > 0) {
            strBefore = [df stringFromDate:date];
        }
        else if (nHour > 0) {
            strBefore = [NSString stringWithFormat:@"%zd小时前",nHour];
        }
        else if (nMin > 0) {
            strBefore = [NSString stringWithFormat:@"%zd分钟前",nMin];
        }
        else if (nSec > 0) {
            strBefore = [NSString stringWithFormat:@"%zd秒前",nSec];
        }
        else
            strBefore = @"0秒前";
    }
    return strBefore;
}

/**  时间戳根据格式返回数据 HH:mm、昨天 HH:mm、MM月dd日 HH:mm、yyyy年MM月dd日)*/
- (NSString *)getVariableFormatDateStringFromTimestamp:(NSString *)timestamp {
    if (timestamp.length < 1 || !timestamp) return @"";
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestamp longLongValue] / 1000];
    
    static NSDateFormatter *formatterToday;
    static NSDateFormatter *formatterYesterday;
    static NSDateFormatter *formatterSameYear;
    static NSDateFormatter *formatterFullDate;
    
    //NSDateFormatter是很耗性能的，这里只创建一次，特别列表里有转换时开销太大
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatterToday = [[NSDateFormatter alloc] init];
        [formatterToday setDateFormat:@"HH:mm"];
        [formatterToday setLocale:[NSLocale currentLocale]];
        
        formatterYesterday = [[NSDateFormatter alloc] init];
        [formatterYesterday setDateFormat:@"昨天 HH:mm"];
        [formatterYesterday setLocale:[NSLocale currentLocale]];
        
        formatterSameYear = [[NSDateFormatter alloc] init];
        [formatterSameYear setDateFormat:@"M月dd日 HH:mm"];
        [formatterSameYear setLocale:[NSLocale currentLocale]];
        
        formatterFullDate = [[NSDateFormatter alloc] init];
        [formatterFullDate setDateFormat:@"yyyy年M月dd日"];
        [formatterFullDate setLocale:[NSLocale currentLocale]];
    });
    
    if ([date lf_isToday]) {
        return [formatterToday stringFromDate:date];
    } else if ([date lf_isYesterday]) {
        return [formatterYesterday stringFromDate:date];
    } else if ([date lf_isSameYearAsDate:[NSDate date]]) {
        return [formatterSameYear stringFromDate:date];
    } else {
        return [formatterFullDate stringFromDate:date];
    }
}

@end
