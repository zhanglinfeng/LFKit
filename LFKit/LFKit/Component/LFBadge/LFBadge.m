//
//  LFBadge.m
//  LFKit
//
//  Created by 张林峰 on 2017/11/24.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import "LFBadge.h"

@interface LFBadge ()

@property (nonatomic, strong) NSLayoutConstraint *topConstraint;//label的上约束
@property (nonatomic, strong) NSLayoutConstraint *leftConstraint;//label的左约束
@property (nonatomic, strong) NSLayoutConstraint *bottomConstraint;//label的下约束
@property (nonatomic, strong) NSLayoutConstraint *rightConstraint;//label的右约束
@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;//Badge的宽约束
@property (nonatomic, strong) NSArray *arrayConstraint;//Badge的约束数组
@property (nonatomic) BOOL useRightTop;//是否使用了addToTopRight方法

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
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = [UIColor redColor];
    self.clipsToBounds = YES;
    self.maxCount = 99;
    self.redDotSize = 8;
    self.edgeInsets = UIEdgeInsetsZero;
    
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
        self.hidden = (_count.integerValue == 0 || count == nil);
        if (_count.integerValue > self.maxCount) {
            _count = [NSString stringWithFormat:@"%zi+",self.maxCount];
        }
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
        self.leftConstraint.constant = 5;
        self.topConstraint.constant = 1;
        self.bottomConstraint.constant = -1;
        self.rightConstraint.constant = -5;
    }
}

- (void)setType:(LFBadgeType)type {
    _type = type;
    if (self.useRightTop) {
        [self addToTopRight];
    }
}

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets {
    _edgeInsets = edgeInsets;
    if (self.useRightTop) {
        [self addToTopRight];
    }
}

#pragma mark - 公有方法

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
        [contentView addSubview:self];
    }
}

- (void)addToBarButtonItem:(UIBarButtonItem *)barButtonItem {
    UIView *contentView = [barButtonItem valueForKeyPath:@"_view"];//use KVC to hack actual view
    if (contentView) {
        [contentView addSubview:self];
    }
}

- (void)addToTopRight {
    self.useRightTop = YES;
    self.widthConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    if (![self.superview.constraints containsObject:self.widthConstraint]) {
        [self.superview addConstraint:self.widthConstraint];
    }
    
    [self.superview removeConstraints:self.arrayConstraint];
    
    if (_type == LFBadgeType_Center) {
        NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:-self.edgeInsets.right];
        NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.edgeInsets.top];
        self.arrayConstraint = @[centerXConstraint,centerYConstraint];
        [self.superview addConstraints:self.arrayConstraint];
    } else if (_type == LFBadgeType_RightTop) {
        
        NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:-self.edgeInsets.right];
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.edgeInsets.top];
        self.arrayConstraint = @[rightConstraint,topConstraint];
        [self.superview addConstraints:self.arrayConstraint];
    } else {
        NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:-self.edgeInsets.right];
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.edgeInsets.top];
        self.arrayConstraint = @[leftConstraint,bottomConstraint];
        [self.superview addConstraints:self.arrayConstraint];
    }
}

#pragma mark - 私有方法

//判断是不是纯数字
- (BOOL)isInt:(NSString *)number {
    NSScanner* scan = [NSScanner scannerWithString:number];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

@end

