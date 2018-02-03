//
//  UILabel+LF.h
//  BaseAPP
//
//  Created by 张林峰 on 16/1/29.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LF)

#pragma mark - 消息数量椭圆Label
@property (nonatomic, retain) NSString *tipNumber;//消息数量，有值时将显示为红色椭圆label

#pragma mark - 数字相关处理
/**正数加前缀“＋”，颜色红；负数颜色绿；空值当0处理*/
- (void)setColorNumberText:(NSString *)text;

/**正数加前缀“＋”；空值当0处理*/
- (void)setNumberText:(NSString *)text;

/**正数加前缀“＋”，颜色红；负数颜色绿*/
- (void)setColorNumber:(float)number;

/**正数加前缀“＋”*/
- (void)setNumber:(float)number;

@end
