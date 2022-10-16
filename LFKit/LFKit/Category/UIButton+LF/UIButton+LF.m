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

static void *shapeLayerKey = &shapeLayerKey;

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

- (CAShapeLayer *)shapeLayer {
    return objc_getAssociatedObject(self, &shapeLayerKey);
}

- (void)setShapeLayer:(CALayer *)shapeLayer {
    objc_setAssociatedObject(self, &shapeLayerKey, shapeLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setArrangeStyle:(LFButtonArrangeStyle)style space:(CGFloat)space {
    CGFloat imageWith = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
    }
    
    if (style == LFButtonStyleImageTop) {
        self.imageEdgeInsets = UIEdgeInsetsMake(-(labelHeight + space)/2, labelWidth/2, (labelHeight + space)/2, -labelWidth/2);
        self.titleEdgeInsets = UIEdgeInsetsMake((imageHeight+space)/2, -imageWith/2, -(imageHeight + space)/2, imageWith/2);
        
    } else if (style == LFButtonStyleImageLeft) {
        self.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2, 0, space/2);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, space/2, 0, -space/2);
    } else if (style == LFButtonStyleImageRight) {
        self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + space/2, 0, -labelWidth - space/2);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWith - space/2, 0, imageWith + space/2);
        
    } else if (style == LFButtonStyleImageBottom) {
        self.imageEdgeInsets = UIEdgeInsetsMake((labelHeight + space)/2, labelWidth/2, -(labelHeight + space)/2, -labelWidth/2);
        self.titleEdgeInsets = UIEdgeInsetsMake(-(imageHeight+space)/2, -imageWith/2, (imageHeight + space)/2, imageWith/2);
    }
}

- (void)startWithTime:(NSInteger)second title:(NSString *)title subTitle:(NSString *)subTitle {
    self.enabled = NO;
    NSString *time = [NSString stringWithFormat:@"%li",(long)second];
    NSString *sTitle = [subTitle stringByReplacingOccurrencesOfString:@"ss" withString:time];
    [self setTitle:sTitle forState:UIControlStateNormal];
    
    if (subTitle.length < 1) {
        subTitle = kDefaultSubTitle;
    }
    self.currentTime = @(second);
    NSDictionary *info = @{@"second":@(second),
                           @"title":title,
                           @"subTitle":subTitle
                           };
    
    [self.resendTimer invalidate];
    self.resendTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleTimer:) userInfo:info repeats:YES];
    [self handleTimer:self.resendTimer];
}

- (void)handleTimer:(NSTimer *)timer {
    NSDictionary *info = timer.userInfo;
    if (self.currentTime.integerValue <= 0) { // 当i<=0了，停止Timer
        [self.resendTimer invalidate];
        [self setTitle:info[@"title"] forState:UIControlStateNormal];
        self.enabled = YES;
    } else {
        NSString *title = info[@"subTitle"];
        NSString *time = [NSString stringWithFormat:@"%li",(long)self.currentTime.integerValue];
        title = [title stringByReplacingOccurrencesOfString:@"ss" withString:time];
        [self setTitle:title forState:UIControlStateNormal];
        
        self.currentTime = @(self.currentTime.integerValue - 1);
    }
}

- (void)removeTimer {
    if (self.resendTimer) {
        [self.resendTimer invalidate];
        self.resendTimer = nil;
    }
}

- (void)resetButton {
    if (self.resendTimer && self.currentTime.integerValue > 0) {
        self.currentTime = [NSNumber numberWithInteger:0];
        [self handleTimer:self.resendTimer];
    }
}

- (void)onClick {
    if (self.btnAction) {
        self.btnAction();
    }
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    self.shapeLayer.frame = CGRectOffset(self.shapeLayer.bounds, CGRectGetMidX(self.bounds) - CGRectGetMidX(self.shapeLayer.bounds), CGRectGetMidY(self.bounds) - CGRectGetMidY(self.shapeLayer.bounds));
    
}

/** 开始加载动画 */
- (void)lf_showLoading {
    self.enabled = NO;
    [self.shapeLayer removeAllAnimations];
    
    if (!self.shapeLayer) {
        CGRect rect = CGRectMake(0, 0, 20, 20);
        CGFloat radius = 10;
        
        self.shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.frame = rect;
        self.shapeLayer.lineWidth = 2.0f;
        self.shapeLayer.lineCap = kCALineCapRound;
        self.shapeLayer.lineJoin = kCALineCapRound;
        self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
        self.shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath;
        
        self.shapeLayer.strokeEnd = 0;
        [self.layer addSublayer:self.shapeLayer];
    }

    self.shapeLayer.strokeColor = [self titleColorForState:UIControlStateNormal].CGColor;
    
    self.shapeLayer.hidden = NO;
    
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = 1.0f; //
    drawAnimation.fromValue = @(0);
    drawAnimation.toValue   = @(0.8);
    drawAnimation.removedOnCompletion = NO;
    drawAnimation.repeatCount = MAXFLOAT;
//    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.shapeLayer addAnimation:drawAnimation forKey:@"strokeAnimation"];

    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.duration            = 1.0f; //
    rotationAnimation.fromValue = @(0);
    rotationAnimation.toValue   = @(2*M_PI);
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.repeatCount = MAXFLOAT;
//    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.shapeLayer addAnimation:rotationAnimation forKey:@"transformAnimation"];
}

/** 停止加载动画 */
- (void)lf_stopLoading {
    self.enabled = YES;
    [self.shapeLayer removeAllAnimations];
    self.shapeLayer.hidden = YES;
}



@end
