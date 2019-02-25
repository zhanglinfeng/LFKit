//
//  LFBaseCardView.m
//  LFKit
//
//  Created by 张林峰 on 2018/1/22.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import "LFBaseCardView.h"

@interface LFBaseCardView ()<UITextFieldDelegate>

@property (nonatomic, assign) LFBaseCardAnimate animate;
@property (nonatomic, strong) UIView *bgView;//黑色半透明背景
@property (nonatomic, strong) NSLayoutConstraint *topConstraint;
@property (nonatomic, strong) NSLayoutConstraint *bottomConstraint;

@end

@implementation LFBaseCardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.windowY = -1;
        [self findTextField:self];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.windowY = -1;
    [self findTextField:self];
}

- (void)tapAction:(UITapGestureRecognizer *)gesture {
    if (self.tapBlankBlock) {
        self.tapBlankBlock();
    }
    [self dismiss];
}

- (void)showIn:(UIView *)superview animate:(LFBaseCardAnimate)animate {
    if (superview == nil) {
        superview = [UIApplication sharedApplication].keyWindow;
    }
    _animate = animate;
    self.alpha = 1;
    if (!self.hideMask) {
        _bgView = [[UIView alloc] initWithFrame:superview.bounds];
        _bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _bgView.translatesAutoresizingMaskIntoConstraints = NO;
        if (self.needTapGesture) {
            //点击手势
            UITapGestureRecognizer *tapGestureRecognizer =
            [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            tapGestureRecognizer.cancelsTouchesInView = NO;//为yes只响应优先级最高的事件，Button高于手势，textfield高于手势，textview高于手势，手势高于tableview。为no同时都响应，默认为yes
            [_bgView addGestureRecognizer:tapGestureRecognizer];
            
        }
        [superview addSubview:_bgView];
        [superview addConstraints:@[
                                    [NSLayoutConstraint constraintWithItem:_bgView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeLeft multiplier:1 constant:0],
                                    [NSLayoutConstraint constraintWithItem:_bgView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeRight multiplier:1 constant:0],
                                    [NSLayoutConstraint constraintWithItem:_bgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeTop multiplier:1 constant:0],
                                    [NSLayoutConstraint constraintWithItem:_bgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0]
                                    ]];
    }
    
    
    
    [superview addSubview:self];
    
    if (_animate == LFBaseCardAnimateNormal) {
        [self normalAnimate];
    } else if (_animate == LFBaseCardAnimateFromBottom){
        [self fromBottomAnimate];
    }
}

- (void)normalAnimate {
    
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    if (self.windowY == -1) {//默认上下居中
        CGFloat offsetY =  0;
        self.cotCenter = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterY multiplier:1 constant:offsetY];
        [self.superview addConstraint:self.cotCenter];
    } else {//写死Y的情况
       [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1 constant:self.windowY]];
    }
    
    
    //外面写死高宽的情况
    if (self.windowH > 0) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.windowH]];
    }
    if (self.windowW) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.windowW]];
    }
    
    if (self.maxHeight) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.maxHeight]];
    }
    
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8f, 0.8f);
    [UIView animateWithDuration:0.2 // 动画时长
                          delay:0.0 // 动画延迟
         usingSpringWithDamping:0.5 // 类似弹簧振动效果 0~1
          initialSpringVelocity:5.0 // 初始速度
                        options:UIViewAnimationOptionCurveEaseInOut // 动画过渡效果
                     animations:^{
                         self.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)fromBottomAnimate {
    self.topConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    self.bottomConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    if (self.isFullWidth) {
        [self.superview addConstraints:@[
                                    [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeft multiplier:1 constant:0],
                                    [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeRight multiplier:1 constant:0],
                                    self.topConstraint
                                    ]];
        if (self.windowH > 0) {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.windowH]];
        }
    } else{
        [self.superview addConstraints:@[
                                         [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
                                         self.topConstraint
                                         ]];
        
        //外面写死高宽的情况
        if (self.windowH > 0) {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.windowH]];
        }
        if (self.windowW) {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.windowW]];
        }
    }
    __weak typeof(self) weakSelf = self;
    [self.superview layoutIfNeeded];
    [UIView animateWithDuration:0.2 animations:^{
        [weakSelf.superview removeConstraint:weakSelf.topConstraint];
        [weakSelf.superview addConstraint:weakSelf.bottomConstraint];
        [weakSelf.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss {
    if (_animate == LFBaseCardAnimateNormal) {
        [self dismissNormal];
    } else if (_animate == LFBaseCardAnimateFromBottom) {
        [self dismissFromBottom];
    }
}

- (void)dismissNormal {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.alpha = 0;
        weakSelf.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf.bgView removeFromSuperview];
        [weakSelf removeFromSuperview];
        if (weakSelf.dismissCompletion) {
            weakSelf.dismissCompletion();
        }
    }];
}

- (void)dismissFromBottom {
    [self.superview layoutIfNeeded];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.bgView.alpha = 0;
        [weakSelf.superview removeConstraint:weakSelf.bottomConstraint];
        [weakSelf.superview addConstraint:weakSelf.topConstraint];
        [weakSelf.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        [weakSelf.bgView removeFromSuperview];
        [weakSelf removeFromSuperview];
        if (weakSelf.dismissCompletion) {
            weakSelf.dismissCompletion();
        }
    }];
}

#pragma mark - TextField相关

- (BOOL)hasTextFieldInView:(UIView *)view {
    for (UIView *v in view.subviews) {
        if ([v isKindOfClass:[UITextField class]]) {
            return YES;
        } else {
            if ([self hasTextFieldInView:v]) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)findTextField:(UIView *)view {
    for (UIView *v in view.subviews) {
        if ([v isKindOfClass:[UITextField class]]) {
            ((UITextField *)v).delegate = self;
        } else {
            [self findTextField:v];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.superview layoutIfNeeded];
    [UIView animateWithDuration:0.2 animations:^{
        self.cotCenter.constant = 0;
        [self.superview layoutIfNeeded];
    } completion:nil];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.superview layoutIfNeeded];
    [UIView animateWithDuration:0.2 animations:^{
        self.cotCenter.constant = -128;
        [self.superview layoutIfNeeded];
    } completion:nil];
}

@end
