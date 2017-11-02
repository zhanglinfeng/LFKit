//
//  UIButton+LF.m
//  APPBaseSDK
//
//  Created by 张林峰 on 16/6/4.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import "UIButton+LF.h"
#import <objc/runtime.h>

static void *currentTimeKey = &currentTimeKey;
static void *resendTimerKey = &resendTimerKey;
static void *btnActionKey = &btnActionKey;

@implementation UIButton (LF)

#pragma mark - 获取验证码倒计时

- (NSNumber *)currentTime {
    return objc_getAssociatedObject(self, &currentTimeKey);
}

-(void)setCurrentTime:(NSNumber *)currentTime {
    objc_setAssociatedObject(self, & currentTimeKey, currentTime, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSTimer *)resendTimer {
    return objc_getAssociatedObject(self, &resendTimerKey);
}

-(void)setResendTimer:(NSTimer *)resendTimer {
    objc_setAssociatedObject(self, & resendTimerKey, resendTimer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LFBtnAction)btnAction {
    return objc_getAssociatedObject(self, &btnActionKey);
}

-(void)setBtnAction:(LFBtnAction)btnAction {
    objc_setAssociatedObject(self, & btnActionKey, btnAction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setStyle:(LFButtonStyle)style space:(CGFloat)space {
    if (!space) {
        space = 6;
    }

    [self.titleLabel sizeToFit];
    if (style == LFButtonStyleTitleDown) {
        space = space - self.titleLabel.font.pointSize * 0.2;
        
        [self setImageEdgeInsets:UIEdgeInsetsMake(-(self.titleLabel.frame.size.height+space)/2, self.titleLabel.frame.size.width/2, (self.titleLabel.frame.size.height+space)/2, -self.titleLabel.frame.size.width/2)];
        [self setTitleEdgeInsets:UIEdgeInsetsMake((self.imageView.frame.size.height+space)/2, -self.imageView.frame.size.width/2, -(self.imageView.frame.size.height+space)/2, self.imageView.frame.size.width/2)];
        
    } else if (style == LFButtonStyleTitleRight) {
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, -space/2, 0, space/2)];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, space/2, 0, -space/2)];
        
    } else if (style == LFButtonStyleTitleLeft) {
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.frame.size.width + space/2, 0, -self.titleLabel.frame.size.width - space/2)];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.frame.size.width - space/2, 0, self.imageView.frame.size.width + space/2)];
        
    }
}

- (void)startWithTime:(NSInteger)second title:(NSString *)title subTitle:(NSString *)subTitle mainColor:(UIColor *)mColor grayColor:(UIColor *)gColor{
    
    self.backgroundColor = gColor;
    NSString *time = [NSString stringWithFormat:@"%zi",second];
    NSString *sTitle = [subTitle stringByReplacingOccurrencesOfString:@"ss" withString:time];
    [self setTitle:sTitle forState:UIControlStateNormal];
    
    if (subTitle.length < 1) {
        subTitle = kDefaultSubTitle;
    }
    self.currentTime = @(second);
    NSDictionary *info = @{@"second":@(second),
                           @"title":title,
                           @"subTitle":subTitle,
                           @"mColor":mColor,
                           @"gColor":gColor};
    
    [self.resendTimer invalidate];
    self.resendTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleTimer:) userInfo:info repeats:YES];
}

- (void)handleTimer:(NSTimer *)timer {
    NSDictionary *info = timer.userInfo;
    if (self.currentTime.integerValue <= 0) { // 当i<=0了，停止Timer
        [self.resendTimer invalidate];
        self.backgroundColor = info[@"mColor"];
        [self setTitle:info[@"title"] forState:UIControlStateNormal];
        self.enabled = YES;
    } else {
        self.backgroundColor = info[@"gColor"];
        self.currentTime = @(self.currentTime.integerValue - 1);
        NSString *title = info[@"subTitle"];
        NSString *time = [NSString stringWithFormat:@"%li",(long)self.currentTime.integerValue];
        title = [title stringByReplacingOccurrencesOfString:@"ss" withString:time];
        [self setTitle:title forState:UIControlStateNormal];
        self.enabled = NO;
    }
}

- (void)removeTimer {
    if (self.resendTimer) {
        [self.resendTimer invalidate];
        self.resendTimer = nil;
    }
}


//- (void)addBlockAction:(LFBtnAction)action {
//    self.btnAction = action;
//    [self addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
//}

- (void)onClick {
    if (self.btnAction) {
        self.btnAction(self);
    }
}


@end
