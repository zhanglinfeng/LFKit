//
//  NSDate+LF.h
//  LFKit
//
//  Created by 张林峰 on 2017/10/27.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LF)

- (NSInteger)lf_year;
- (NSInteger)lf_month;
- (NSInteger)lf_day;
- (BOOL)lf_isToday;
- (BOOL)lf_isYesterday;
- (BOOL)lf_isSameYearAsDate:(NSDate *) aDate;
- (NSDate *)lf_dateByAddingDays:(NSInteger)days;
- (NSDate *)lf_dateByAddingMonths:(NSInteger)months;
- (NSDate *)lf_dateByAddingYears:(NSInteger)years;

/** 获取年龄*/
- (NSInteger)lf_getAge;

@end
