//
//  UIButton+LF.h
//  APPBaseSDK
//
//  Created by 张林峰 on 16/6/4.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LFButtonStyle) {
    LFButtonStyleTitleDown, //图上字下
    LFButtonStyleTitleRight, //图左字右
    LFButtonStyleTitleLeft //图右字左
};

#define kDefaultSubTitle @"ss秒后重试"

typedef void(^LFBtnAction)(UIButton *button);

@interface UIButton (LF)

@property (nonatomic, strong) NSNumber *currentTime;//倒计时的当前时间
@property (nonatomic, strong) NSTimer *resendTimer;//定时器
@property (nonatomic, copy) LFBtnAction btnAction;


/**
 设置文字和图标的排列样式
 @param style 排列顺序
 @param space 图文间距
 */
- (void)setStyle:(LFButtonStyle)style space:(CGFloat)space;

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
