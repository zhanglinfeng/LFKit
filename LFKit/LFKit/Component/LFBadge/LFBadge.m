//
//  LFBadge.m
//  LFKit
//
//  Created by 张林峰 on 2017/11/24.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import "LFBadge.h"

@interface LFBadge ()

@property (nonatomic, strong) UIView *smallRoundView;//拖动角标出现的小圆
@property (nonatomic, strong) CAShapeLayer *shapeLayer;//2圆外切线之间的图形
@property (strong, nonatomic) CAEmitterLayer *explosionLayer;//爆炸层
@property (nonatomic, strong) NSLayoutConstraint *topConstraint;//label的上约束
@property (nonatomic, strong) NSLayoutConstraint *leftConstraint;//label的左约束
@property (nonatomic, strong) NSLayoutConstraint *bottomConstraint;//label的下约束
@property (nonatomic, strong) NSLayoutConstraint *rightConstraint;//label的右约束
@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;//Badge的宽约束
@property (nonatomic, strong) NSLayoutConstraint *badgeCenterX;
@property (nonatomic, strong) NSLayoutConstraint *badgeCenterY;
@property (nonatomic, strong) NSLayoutConstraint *badgeTop;
@property (nonatomic, strong) NSLayoutConstraint *badgeLeft;
@property (nonatomic, strong) NSLayoutConstraint *badgeBottom;
@property (nonatomic, strong) NSLayoutConstraint *badgeRight;
@property (nonatomic, strong) NSArray *arrayConstraint;//Badge的约束数组
@property (nonatomic) BOOL useRightTop;//是否使用了addToTopRight方法
@property (nonatomic) CGPoint beginPoint;

@end

@implementation LFBadge

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initUI];
}

- (void)initUI {
    self.clipsToBounds = NO;
    self.maxCount = 99;
    self.redDotSize = 8;
    self.edgeInsets = UIEdgeInsetsZero;
    self.badgeCorlor = [UIColor redColor];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = self.badgeCorlor;
    self.maxDistance = 100;
    
    _lbText = [[UILabel alloc] init];
    _lbText.textColor = [UIColor whiteColor];
    _lbText.font = [UIFont systemFontOfSize:14];
    _lbText.textAlignment = NSTextAlignmentCenter;
    _lbText.backgroundColor = [UIColor clearColor];
    _lbText.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_lbText];
    
    self.leftConstraint = [NSLayoutConstraint constraintWithItem:_lbText attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.redDotSize/2];
    self.topConstraint = [NSLayoutConstraint constraintWithItem:_lbText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.redDotSize/2];
    self.bottomConstraint = [NSLayoutConstraint constraintWithItem:_lbText attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.redDotSize/2];
    self.rightConstraint = [NSLayoutConstraint constraintWithItem:_lbText attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-self.redDotSize/2];
    [self addConstraints:@[self.leftConstraint, self.topConstraint,self.bottomConstraint,self.rightConstraint]];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    pan.cancelsTouchesInView = NO;
    [self addGestureRecognizer:pan];
    
}



- (void)layoutSubviews {
    [super layoutSubviews];
    float radius = self.frame.size.height < self.frame.size.width ? self.frame.size.height : self.frame.size.width;
    self.layer.cornerRadius = radius / 2.0f;
}

#pragma mark - setter

- (void)setCount:(NSString *)count {
    _count = count;
    if ([self isInt:_count]) {
        self.hidden = _count.integerValue == 0;
        if (_count.integerValue > self.maxCount) {
            _count = [NSString stringWithFormat:@"%zi+",self.maxCount];
        }
    } else {
        self.hidden = _count == nil;
    }
    
    self.lbText.text = _count;
    
    if ([_count isEqualToString:@""]) {
        //小红点
        self.leftConstraint.constant = self.redDotSize/2;
        self.topConstraint.constant = self.redDotSize/2;
        self.bottomConstraint.constant = -self.redDotSize/2;
        self.rightConstraint.constant = -self.redDotSize/2;
    } else {
        //其他字符串
        self.leftConstraint.constant = self.lbText.font.pointSize/3.0f;
        self.topConstraint.constant = self.lbText.font.pointSize/10.0f;
        self.bottomConstraint.constant = -self.lbText.font.pointSize/10.0f;
        self.rightConstraint.constant = -self.lbText.font.pointSize/3.0f;
    }
}

- (void)setType:(LFBadgeType)type {
    _type = type;
    if (self.useRightTop) {
        [self addTopRightConstraint];
    }
}

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets {
    _edgeInsets = edgeInsets;
    if (self.useRightTop) {
        [self addTopRightConstraint];
    }
}

- (void)setBadgeCorlor:(UIColor *)badgeCorlor {
    _badgeCorlor = badgeCorlor;
    self.backgroundColor = _badgeCorlor;
    self.smallRoundView.backgroundColor = _badgeCorlor;
}

#pragma mark - 公有方法

- (void)addToView:(UIView*)superview {
    [superview addSubview:self.smallRoundView];
    [superview addSubview:self];
    [self addTopRightConstraint];
}

- (void)addToTabBarItem:(UITabBarItem *)tabBarItem {
    UIView *bottomView = [tabBarItem valueForKeyPath:@"_view"];
    UIView *contentView = bottomView;
    if (bottomView) {
        __block UIView *targetView = bottomView;
        [bottomView.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([subview isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
                targetView = subview;
                *stop = YES;
            }
        }];
        contentView = targetView;
    }
    
    if (contentView) {
        [self addToView:contentView];
    }
}

- (void)addToBarButtonItem:(UIBarButtonItem *)barButtonItem {
    UIView *contentView = [barButtonItem valueForKeyPath:@"_view"];//use KVC to hack actual view
    if (contentView) {
        [self addToView:contentView];
    }
}

/**清除角标约束（如果不想加到父视图右上角可调该方法，自行设置其他约束或者frame）*/
- (void)clearBadgeConstraint {
    [self.superview removeConstraints:self.arrayConstraint];
    [self.superview removeConstraint:self.widthConstraint];
    self.useRightTop = NO;
}

#pragma mark - 私有方法

- (void)addTopRightConstraint {
    self.useRightTop = YES;
    self.widthConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    if (![self.constraints containsObject:self.widthConstraint]) {
        [self addConstraint:self.widthConstraint];
    }
    
    [self.superview removeConstraints:self.arrayConstraint];
    
    if (_type == LFBadgeType_Center) {
        self.badgeCenterX = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:-self.edgeInsets.right];
        self.badgeCenterY = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.edgeInsets.top];
        self.arrayConstraint = @[self.badgeCenterX,self.badgeCenterY];
        [self.superview addConstraints:self.arrayConstraint];
    } else if (_type == LFBadgeType_RightTop) {
        self.badgeRight = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:-self.edgeInsets.right];
        self.badgeTop = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.edgeInsets.top];
        self.arrayConstraint = @[self.badgeRight,self.badgeTop];
        [self.superview addConstraints:self.arrayConstraint];
    } else {
        self.badgeLeft = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:-self.edgeInsets.right];
        self.badgeBottom = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.edgeInsets.top];
        self.arrayConstraint = @[self.badgeLeft,self.badgeBottom];
        [self.superview addConstraints:self.arrayConstraint];
    }
}

//判断是不是纯数字
- (BOOL)isInt:(NSString *)number {
    NSScanner* scan = [NSScanner scannerWithString:number];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark - 拖动相关
- (void)pan:(UIPanGestureRecognizer *)pan {
    if (!self.clearBlock) {
        return;
    }
    
    CGPoint panPoint = [pan locationInView:self.superview];
    CGFloat offsetX = panPoint.x - self.beginPoint.x;
    CGFloat offsetY = panPoint.y - self.beginPoint.y;
    
    CGFloat dist = 0;
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.beginPoint = panPoint;
        self.smallRoundView.hidden = NO;
        self.smallRoundView.center = self.center;
        if (!self.smallRoundView.superview) {
            [self.superview insertSubview:self.smallRoundView belowSubview:self];
        }
        
        if (self.useRightTop) {
            
        } else {
            
        }
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        self.center = CGPointMake(self.smallRoundView.center.x + offsetX, self.smallRoundView.center.y + offsetY);//1.防止约束布局延时 2.外部使用者不是约束布局需要这样写
        dist = sqrtf(powf((self.center.x - self.smallRoundView.center.x), 2) + powf((self.center.y - self.smallRoundView.center.y), 2));
        if (dist < _maxDistance) {
            if (self.smallRoundView.hidden == NO && dist > 0) {
                //画2圆切线
                self.shapeLayer.path = [self pathWithBigCirCleView:self smallCirCleView:_smallRoundView].CGPath;
            }
        } else {
            [self.shapeLayer removeFromSuperlayer];
            self.shapeLayer = nil;
            self.smallRoundView.hidden = YES;
        }
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        dist = sqrtf(powf((self.center.x - self.smallRoundView.center.x), 2) + powf((self.center.y - self.smallRoundView.center.y), 2));
        if (dist > _maxDistance) {
            //播放销毁动画
            if (self.needDisappearEffects) {
                [self startAnimate];
            }
            self.hidden = YES;
            self.smallRoundView.hidden = YES;
            self.clearBlock();
        }
        [self.shapeLayer removeFromSuperlayer];
        self.shapeLayer = nil;
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.center = self.smallRoundView.center;
        } completion:^(BOOL finished) {
            
        }];
    }
}

//画2圆的外切线
- (UIBezierPath *)pathWithBigCirCleView:(UIView *)bigCirCleView  smallCirCleView:(UIView *)smallCirCleView
{
    CGPoint bigCenter = bigCirCleView.center;
    CGFloat x2 = bigCenter.x;
    CGFloat y2 = bigCenter.y;
    CGFloat r2 = MIN(bigCirCleView.bounds.size.height, bigCirCleView.bounds.size.width)/2;
    
    CGPoint smallCenter = smallCirCleView.center;
    CGFloat x1 = smallCenter.x;
    CGFloat y1 = smallCenter.y;
    CGFloat r1 = smallCirCleView.bounds.size.width / 2;
    
    // 获取圆心距离
    CGFloat dist = sqrtf(powf((self.center.x - self.smallRoundView.center.x), 2) + powf((self.center.y - self.smallRoundView.center.y), 2));
    CGFloat sinθ = (x2 - x1) / dist;
    CGFloat cosθ = (y2 - y1) / dist;
    
    // 坐标系基于父控件
    CGPoint pointA = CGPointMake(x1 - r1 * cosθ , y1 + r1 * sinθ);
    CGPoint pointB = CGPointMake(x1 + r1 * cosθ , y1 - r1 * sinθ);
    CGPoint pointC = CGPointMake(x2 + r2 * cosθ , y2 - r2 * sinθ);
    CGPoint pointD = CGPointMake(x2 - r2 * cosθ , y2 + r2 * sinθ);
    CGPoint pointO = CGPointMake(pointA.x + dist / 2 * sinθ , pointA.y + dist / 2 * cosθ);
    CGPoint pointP = CGPointMake(pointB.x + dist / 2 * sinθ , pointB.y + dist / 2 * cosθ);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    // A
    [path moveToPoint:pointA];
    // AB
    [path addLineToPoint:pointB];
    // 绘制BC曲线
    [path addQuadCurveToPoint:pointC controlPoint:pointP];
    // CD
    [path addLineToPoint:pointD];
    // 绘制DA曲线
    [path addQuadCurveToPoint:pointA controlPoint:pointO];
    
    return path;
}

//销毁动画
- (void)startAnimate {
    self.explosionLayer.beginTime = CACurrentMediaTime();
    [self.explosionLayer setValue:@500 forKeyPath:@"emitterCells.explosion.birthRate"];
    [self performSelector:@selector(stop) withObject:nil afterDelay:0.1];
}

//停止动画
- (void)stop {
    [_explosionLayer setValue:@0 forKeyPath:@"emitterCells.explosion.birthRate"];
}

- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.fillColor = self.backgroundColor.CGColor;
        [self.superview.layer insertSublayer:_shapeLayer below:self.layer];
    }
    return _shapeLayer;
}

//爆炸Layer
- (CAEmitterLayer *)explosionLayer {
    if (!_explosionLayer) {
        CAEmitterCell *explosionCell = [CAEmitterCell emitterCell];
        explosionCell.name = @"explosion";
        explosionCell.alphaRange = 0.20;
        explosionCell.alphaSpeed = -1.0;
        explosionCell.lifetime = 0.2;//粒子存活的时间,以秒为单位
        explosionCell.lifetimeRange = 0.1;// 可以为这个粒子存活的时间再指定一个范围。0.1s到0.3s
        explosionCell.birthRate = 0;//每秒生成多少个粒子
        explosionCell.velocity = 40.00;//粒子平均初始速度。正数表示竖直向上，负数竖直向下。
        explosionCell.velocityRange = 10.00;//可以再指定一个范围。
        explosionCell.scale = 0.05;
        explosionCell.scaleRange = 0.02;
        explosionCell.contents = (id)[self getExplosionImage].CGImage;//用图片效果更佳
        
        _explosionLayer = [CAEmitterLayer layer];
        _explosionLayer.name = @"emitterLayer";
        _explosionLayer.emitterShape = kCAEmitterLayerCircle;
        _explosionLayer.emitterMode = kCAEmitterLayerOutline;//发射源的发射模式，以一个圆的方式向外扩散开
        _explosionLayer.emitterSize = CGSizeMake(25, 0);
        _explosionLayer.emitterCells = @[explosionCell];
        _explosionLayer.renderMode = kCAEmitterLayerOldestFirst;
        _explosionLayer.masksToBounds = NO;
        _explosionLayer.seed = 1366128504;
        [self.superview.layer addSublayer:_explosionLayer];
        
    }
    _explosionLayer.emitterPosition = self.center;//发射源位置
    return _explosionLayer;
}

- (UIView *)smallRoundView {
    if (!_smallRoundView) {
        _smallRoundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _smallRoundView.backgroundColor = _badgeCorlor;
        _smallRoundView.layer.cornerRadius = 5;
        _smallRoundView.hidden = YES;
    }
    return _smallRoundView;
}

//获取需要爆炸的背景图
- (UIImage *)getExplosionImage {
    UIGraphicsBeginImageContext(CGSizeMake(60, 60));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[self.badgeCorlor colorWithAlphaComponent:0.5] CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 60, 60));
    UIImage *myImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return myImage;
}

@end
