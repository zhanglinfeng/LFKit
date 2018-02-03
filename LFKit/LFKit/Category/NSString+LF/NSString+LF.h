//
//  NSString+LF.h
//  APPBaseSDK
//
//  Created by 张林峰 on 16/6/4.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (LF)

#pragma mark - size相关

/**根据文字数获取高度*/
- (CGFloat)getHeightWithFont:(UIFont*)font width:(CGFloat)width;

/**根据文字数获取宽度度*/
- (CGFloat)getWidthWithFont:(UIFont*)font;

#pragma mark - 字符串处理

/**截取字符串之间的字符串(如截取出#话题#)*/
- (NSMutableArray *)stringBetweenString:(NSString *)string;

/**获取拼音*/
- (NSString *)getPinyin;

/**获取拼音首字母*/
- (NSString *)getInitial;

/**字符串提取数字*/
- (NSString *)getNumberString;

/**字符串关键字部分变高亮色*/
- (NSMutableAttributedString *)getAttributeStringWithKeywords:(NSString *)keywords keyColor:(UIColor *)color;

/**URL编码*/
- (NSString *)URLEncoded;

/**URL解码*/
-(NSString *)URLDecoded;

/**获取MD5*/
- (NSString *)getMD5;

#pragma mark - 校验相关

/**身份证号*/
- (BOOL)isIdentityCard;

/**邮箱*/
- (BOOL)isEmail;

/**手机号码验证*/
- (BOOL)isMobile;

/**判断是不是纯数字*/
- (BOOL)isInt;

/**判断是否为浮点形*/
- (BOOL)isFloat;

/**判断是否为数字*/
- (BOOL)isNumber;

/**判断是否含中文*/
- (BOOL)containsChinese;


@end