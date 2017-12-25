//
//  LFStarsView.m
//  LFKit
//
//  Created by 张林峰 on 2017/12/25.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import "LFStarsView.h"

@interface LFStarsView ()

@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;
@property (nonatomic, assign) NSInteger number;

@end

@implementation LFStarsView

- (instancetype)initWithFrame:(CGRect)frame starNumber:(NSInteger)number image:(UIImage *)image highlightImage:(UIImage *)hImage {
    self = [super initWithFrame:frame];
    if (self) {
        _number = number;
        self.backgroundColor = [UIColor whiteColor];
        self.starBackgroundView = [self buidlStarViewWithImage:image];
        self.starForegroundView = [self buidlStarViewWithImage:hImage];
        [self addSubview:self.starBackgroundView];
        [self addSubview:self.starForegroundView];
        self.value = 0;
    }
    return self;
}

- (UIView *)buidlStarViewWithImage:(UIImage *)image {
    CGRect frame = self.bounds;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = self.backgroundColor;
    view.clipsToBounds = YES;
    for (int i = 0; i < _number; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(i * frame.size.width / _number, 0, frame.size.width / _number, frame.size.height);
        [view addSubview:imageView];
    }
    return view;
}

-(void)setValue:(CGFloat)value {
    _value =value;
    if (_value < 0) {
        _value = 0;
    } else if (value > _number) {
        value = _number;
    }
    CGFloat rate=value/_number;
    self.starForegroundView.frame = CGRectMake(0, 0, rate*self.frame.size.width, self.frame.size.height);
}

-(void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    self.backgroundColor = bgColor;
    self.starBackgroundView.backgroundColor = bgColor;
    self.starForegroundView.backgroundColor = bgColor;
}

- (void)updateValue:(NSSet *)touches {
    if (self.selectBlock) {//判断是否可以点击或滑动星星
        UITouch *touch = [touches anyObject];
        CGPoint p = [touch locationInView:self];
        if (p.x < 0) {
            p.x = 0;
        } else if (p.x > self.frame.size.width) {
            p.x = self.frame.size.width;
        }
        self.starForegroundView.frame = CGRectMake(0, 0, p.x, self.frame.size.height);
        self.selectBlock(p.x/self.frame.size.width * _number);
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self updateValue:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self updateValue:touches];
}

@end
