//
//  NSDate+LF.m
//  LFKit
//
//  Created by 张林峰 on 2017/10/27.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import "NSDate+LF.h"

@implementation NSDate (LF)

- (NSInteger)lf_year {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self] year];
}

- (NSInteger)lf_month {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self] month];
}

- (NSInteger)lf_day {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] day];
}

- (BOOL)lf_isToday {
    if (fabs(self.timeIntervalSinceNow) >= 60 * 60 * 24) return NO;
    return [NSDate new].lf_day == self.lf_day;
}

- (BOOL)lf_isYesterday {
    NSDate *added = [self lf_dateByAddingDays:1];
    return [added lf_isToday];
}

- (BOOL)lf_isSameYearAsDate:(NSDate *)aDate {
    if (self.lf_year != aDate.lf_year) {
        return NO;
    }
    return YES;
}

- (NSDate *)lf_dateByAddingDays:(NSInteger)days {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 86400 * days;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)lf_dateByAddingMonths:(NSInteger)months {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:months];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)lf_dateByAddingYears:(NSInteger)years {
    NSCalendar *calendar =  [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:years];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

/** 获取年龄*/
- (NSInteger)lf_getAge;
{
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateDay   = [components1 day];
    NSInteger brithDateMonth = [components1 month];
      
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateDay   = [components2 day];
    NSInteger currentDateMonth = [components2 month];
      
    // 计算年龄
    NSInteger iAge = currentDateYear - brithDateYear - 1;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }
      
    return iAge;
}

/**从fromDate到toDate的天数*/
+ (NSInteger)lf_daysFrom:(NSDate *)fromDate to:(NSDate *)toDate {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
         NSDateComponents *comp = [calendar components:NSCalendarUnitDay
                                                  fromDate:fromDate
                                                    toDate:toDate
                                                   options:NSCalendarWrapComponents];
         return comp.day;
}

@end
