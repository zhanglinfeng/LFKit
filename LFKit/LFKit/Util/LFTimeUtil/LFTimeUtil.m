//
//  LFTimeUtil.m
//  APPBaseSDK
//
//  Created by 张林峰 on 16/5/31.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import "LFTimeUtil.h"

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
    
    format = [format stringByReplacingOccurrencesOfString:@"dd" withString:[NSString stringWithFormat:@"%02li",(long)day]];
    format = [format stringByReplacingOccurrencesOfString:@"HH" withString:[NSString stringWithFormat:@"%02li",(long)hours]];
    format = [format stringByReplacingOccurrencesOfString:@"mm" withString:[NSString stringWithFormat:@"%02li",(long)minutes]];
    format = [format stringByReplacingOccurrencesOfString:@"ss" withString:[NSString stringWithFormat:@"%02li",(long)seconds]];
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

/**获取当前时间戳 （以毫秒为单位）*/
+(NSString *)getNowTimeTimestamp {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这个对于时间的处理有时很重要
//    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    return timeSp;
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
            strBefore = [NSString stringWithFormat:@"%li小时前",(long)nHour];
        }
        else if (nMin > 0) {
            strBefore = [NSString stringWithFormat:@"%li分钟前",(long)nMin];
        }
        else if (nSec > 0) {
            strBefore = [NSString stringWithFormat:@"%li秒前",(long)nSec];
        }
        else
            strBefore = @"0秒前";
    }
    return strBefore;
}

/**  时间戳根据格式返回数据 HH:mm、昨天 HH:mm、MM月dd日 HH:mm、yyyy年MM月dd日)*/
+ (NSString *)getVariableFormatDateStringFromTimestamp:(NSString *)timestamp {
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
    
    if ([self isToday:date]) {
        return [formatterToday stringFromDate:date];
    } else if ([self isYesterday:date]) {
        return [formatterYesterday stringFromDate:date];
    } else if ([self isSameYear:[NSDate date] date2:date]) {
        return [formatterSameYear stringFromDate:date];
    } else {
        return [formatterFullDate stringFromDate:date];
    }
}

/**时间字符串转xx小时前、昨天HH:mm、前天HH:mm、MM月dd日、yyyy年MM月dd日*/
+ (NSString *)getShowTimeFromTimeStr:(NSString*)str {
    static NSDateFormatter *dateFormatter1;
    static NSDateFormatter *dateFormatter2;
    static NSDateFormatter *dateFormatter3;
    static NSDateFormatter *dateFormatter4;
    static NSDateFormatter *dateFormatter5;
    
    //NSDateFormatter是很耗性能的，这里只创建一次，特别列表里有转换时开销太大
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"昨天HH:mm"];
        dateFormatter3 = [[NSDateFormatter alloc] init];
        [dateFormatter3 setDateFormat:@"前天HH:mm"];
        dateFormatter4 = [[NSDateFormatter alloc] init];
        [dateFormatter4 setDateFormat:@"MM月dd日"];
        dateFormatter5 = [[NSDateFormatter alloc] init];
        [dateFormatter5 setDateFormat:@"yyyy-MM-dd"];
    });
    NSDate *date = [dateFormatter1 dateFromString:str];
    
    NSString * strBefore = @"";
    if (date && (id)date != [NSNull null]) {
        NSInteger interval = -(NSInteger)[date timeIntervalSinceNow];
        NSInteger nDay = interval / (60 * 60 * 24);
        NSInteger nHour = interval / (60 * 60);
        NSInteger nMin = interval / 60;
        NSInteger nSec = interval;
        
        if (nDay > 0) {
            if ([self isYesterday:date]) {
                strBefore = [dateFormatter2 stringFromDate:date];
            } else if ([self isQiantian:date]) {
                strBefore = [dateFormatter3 stringFromDate:date];
            } else if ([self isSameYear:[NSDate date] date2:date]) {
                strBefore = [dateFormatter4 stringFromDate:date];
            } else {
                strBefore = [dateFormatter5 stringFromDate:date];
            }
        }
        else if (nHour > 0) {
            strBefore = [NSString stringWithFormat:@"%li小时前",(long)nHour];
        }
        else if (nMin > 0) {
            strBefore = [NSString stringWithFormat:@"%li分钟前",(long)nMin];
        }
        else if (nSec > 10) {
            strBefore = [NSString stringWithFormat:@"%li秒前",(long)nSec];
        }
        else
            strBefore = @"刚刚";
    }
    return strBefore;
}

+ (BOOL)isQiantian:(NSDate*)date {
    NSTimeInterval aTimeInterval = [date timeIntervalSinceReferenceDate] + 86400 * 2;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isToday:newDate];
}

+ (BOOL)isToday:(NSDate*)date {
    if (fabs(date.timeIntervalSinceNow) >= 60 * 60 * 24) return NO;
    NSInteger day = [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:date] day];
    NSInteger nowDay = [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:[NSDate new]] day];
    return nowDay == day;
}

+ (BOOL)isYesterday:(NSDate*)date {
    NSTimeInterval aTimeInterval = [date timeIntervalSinceReferenceDate] + 86400 * 1;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isToday:newDate];
}

+ (BOOL)isSameYear:(NSDate *)date1 date2:(NSDate*)date2 {
    NSInteger year1 = [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:date1] year];
    NSInteger year2 = [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:date2] year];
    if (year1 != year2) {
        return NO;
    }
    return YES;
}

@end
