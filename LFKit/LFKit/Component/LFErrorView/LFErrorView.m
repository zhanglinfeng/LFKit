//
//  LFErrorView.m
//  LFKit
//
//  Created by 张林峰 on 2017/10/27.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import "LFErrorView.h"

@interface LFErrorView ()

@property (nonatomic, strong) UIVisualEffectView *blurView;//黑色毛玻璃背景

@end

@implementation LFErrorView

- (instancetype)initWithIcon:(UIImage *)icon text:(NSString *)text btnTitle:(NSString*)btnTitle {
    self = [super init];
    if (self) {
        
        self.itemSpace = 20;
        self.labelMargin = 40;
        self.backgroundColor = [UIColor lightGrayColor];
        
        self.ivBackground = [[UIImageView alloc] init];
        self.ivBackground.backgroundColor = [UIColor clearColor];
        self.ivBackground.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.ivBackground];
        
        self.blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        [self addSubview:self.blurView];
        
        self.ivIcon = [[UIImageView alloc] initWithImage:icon];
        [self addSubview:self.ivIcon];
        
        self.lbText = [[UILabel alloc] init];
        self.lbText.textColor = [UIColor grayColor];
        self.lbText.backgroundColor = [UIColor clearColor];
        self.lbText.textAlignment = NSTextAlignmentCenter;
        self.lbText.numberOfLines = 0;
        self.lbText.font = [UIFont systemFontOfSize:14];
        self.lbText.text = text;
        [self addSubview:self.lbText];
        
        self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 140, 32)];
        self.button.titleLabel.font = [UIFont systemFontOfSize:14];
        self.button.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.button.layer.borderWidth = 1.0f/[UIScreen mainScreen].scale;
        self.button.layer.cornerRadius = 5;
        [self.button setTitle:btnTitle forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.button addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.button];
        
        if (btnTitle.length < 1) {
            //点击手势
            UITapGestureRecognizer *tapGestureRecognizer =
            [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
            [self addGestureRecognizer:tapGestureRecognizer];
            tapGestureRecognizer.cancelsTouchesInView = NO;//为yes只响应优先级最高的事件，Button高于手势，textfield高于手势，textview高于手势，手势高于tableview。为no同时都响应，默认为yes
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.ivBackground.frame = self.bounds;
    self.blurView.frame = self.bounds;
    
    CGFloat coverImageH = 0;
    CGFloat coverImageW = 0;
    if (self.ivIcon.image) {
        coverImageH = self.ivIcon.image.size.height;
        coverImageW = self.ivIcon.image.size.width;
    }
    
    CGFloat itemTotalH = coverImageH;
    
    CGFloat lbH = [self.lbText.text boundingRectWithSize:CGSizeMake(self.frame.size.width - self.labelMargin*2, 0)
                                                 options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                              attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                                 context:nil].size.height;
    if (self.lbText.text.length > 0) {
        itemTotalH = coverImageH + self.itemSpace + lbH;
    }
    
    if (self.button.currentTitle.length > 0) {
        itemTotalH = itemTotalH + self.labelMargin + self.button.frame.size.height;
    }
    
    self.ivIcon.frame = CGRectMake((self.frame.size.width - coverImageW)/2, (self.frame.size.height - itemTotalH)/2, coverImageW, coverImageH);
    
    self.lbText.frame = CGRectMake(self.labelMargin, CGRectGetMaxY(self.ivIcon.frame) + self.itemSpace, self.frame.size.width - self.labelMargin*2, lbH);
    
    CGFloat btY = CGRectGetMaxY(self.lbText.frame) + self.itemSpace;
    if (self.lbText.text.length < 1) {
        btY = CGRectGetMaxY(self.ivIcon.frame) + self.itemSpace;
    }
    
    self.button.frame = CGRectMake((self.frame.size.width - self.button.frame.size.width)/2, btY, self.button.frame.size.width, self.button.frame.size.height);
}

- (void)tapAction {
    if (self.button.currentTitle.length > 0 && self.tapBlock) {
        self.tapBlock();
        [self removeFromSuperview];
    }
}

- (void)setNeedBlurEffect:(BOOL)needBlurEffect {
    _needBlurEffect = needBlurEffect;
    self.blurView.hidden = !_needBlurEffect;
}

@end
