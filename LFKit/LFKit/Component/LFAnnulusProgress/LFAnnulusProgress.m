//
//  LFAnnulusProgress.m
//  LFKit
//
//  Created by 张林峰 on 2017/12/25.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import "LFAnnulusProgress.h"

#define DEGREES_TO_RADOANS(x) (M_PI * (x) / 180.0) // 将角度转为弧度

@interface LFAnnulusProgress ()

@property (strong, nonatomic) CAShapeLayer *colorLayer; // 渐变色
@property (strong, nonatomic) CAShapeLayer *colorMaskLayer; // 渐变色遮罩

@end

@implementation LFAnnulusProgress

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        //默认设置
        self.startColor = [UIColor yellowColor];
        self.centerColor = [UIColor orangeColor];
        self.endColor = [UIColor redColor];
        self.lineWidth = 5;
        self.isClockWise = YES;
        self.startAngle = DEGREES_TO_RADOANS(-90);
        self.endAngle = DEGREES_TO_RADOANS(270);
        self.backgroundColor = [UIColor whiteColor];
        self.progressValue = 0;
    }
    
    return self;
    
}

- (void)createUI {
    //将自己裁剪成圆环
    self.layer.mask = [self getAnnulusMaskLayer:self.bgLineWidth];
    
    //渐变色layer由左右两边组成
    self.colorLayer = [CAShapeLayer layer];
    self.colorLayer.frame = self.bounds;
    [self.layer addSublayer:self.colorLayer];
    
    CAGradientLayer *leftLayer = [CAGradientLayer layer];
    leftLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds));
    leftLayer.locations = @[@0.0, @0.9, @1];// 分段设置渐变色
    leftLayer.colors = @[(id)self.endColor.CGColor, (id)self.centerColor.CGColor];
    [self.colorLayer addSublayer:leftLayer];
    
    CAGradientLayer *rightLayer = [CAGradientLayer layer];
    rightLayer.frame = CGRectMake(CGRectGetWidth(self.bounds) / 2, 0, CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds));
    rightLayer.locations = @[@0.0, @0.9, @1];
    rightLayer.colors = @[(id)self.startColor.CGColor, (id)self.centerColor.CGColor];
    [self.colorLayer addSublayer:rightLayer];
    
    //渐变色layer的遮罩layer
    CAShapeLayer *layer = [self getAnnulusMaskLayer:self.lineWidth];
    layer.lineWidth = self.lineWidth + 0.5;
    self.colorMaskLayer = layer;
    self.colorLayer.mask = self.colorMaskLayer;
    self.progressValue = 0;
}

- (void)removeUI {
    [self.colorLayer removeFromSuperlayer];
}

/**获取圆环Layer*/
- (CAShapeLayer *)getAnnulusMaskLayer:(CGFloat)lineWidth {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.bounds;
    // 创建一个圆心为父视图中点的圆，半径为父视图宽的0.5 - lineWidth/2
    UIBezierPath *path = nil;
    if (self.isClockWise) {
        path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2) radius:CGRectGetWidth(self.bounds) / 2 - lineWidth/2 startAngle:self.startAngle endAngle:self.endAngle clockwise:YES];
    } else {
        path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2) radius:CGRectGetWidth(self.bounds) / 2 - lineWidth/2 startAngle:self.endAngle endAngle:self.startAngle clockwise:NO];
    }
    layer.lineWidth = lineWidth;
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor; // 填充色为透明（不设置为黑色）
    layer.strokeColor = [UIColor blackColor].CGColor; // 随便设置一个边框颜色
    //    layer.lineCap = kCALineCapRound; // 设置线为圆角
    return layer;
}

- (void)setProgressValue:(CGFloat)progressValue {
    if (progressValue > 1.0) {
        return;
    }
    _progressValue = progressValue;
    self.colorMaskLayer.strokeEnd = progressValue;
    
}

@end
