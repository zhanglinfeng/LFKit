//
//  UIButton+LF.h
//  APPBaseSDK
//
//  Created by 张林峰 on 16/6/4.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>

// 定义一个排列样式枚举（包含了四种类型的button）
typedef NS_ENUM(NSUInteger, LFButtonArrangeStyle) {
    LFButtonStyleImageTop, // image在上，label在下
    LFButtonStyleImageLeft, // image在左，label在右
    LFButtonStyleImageRight, // image在右，label在左
    LFButtonStyleImageBottom // image在下，label在上
};

#define kDefaultSubTitle @"ss秒后重试"

typedef void(^LFBtnAction)(UIButton *button);

@interface UIButton (LF)

@property (nonatomic, strong) NSNumber *currentTime;//倒计时的当前时间
@property (nonatomic, strong) NSTimer *resendTimer;//定时器
@property (nonatomic, copy) LFBtnAction btnAction;


/** 设置图文排列样式及间距 **/
- (void)el_setArrangeStyle:(LFButtonArrangeStyle)style space:(CGFloat)space;

/*
 *    倒计时按钮
 *    @param timeLine  倒计时总时间
 *    @param title     还没倒计时的title
 *    @param subTitle  倒计时的子名字 格式为xxssxx，xx为你要显示的文字，不传则默认为：ss秒
 *    @param mColor    还没倒计时的颜色
 *    @param color     倒计时的颜色
 */

- (void)startWithTime:(NSInteger)second title:(NSString *)title subTitle:(NSString *)subTitle mainColor:(UIColor *)mColor grayColor:(UIColor *)gColor;

- (void)removeTimer;





@end
