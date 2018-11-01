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

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.itemSpace = 20;
        self.labelMargin = 40;
        self.backgroundColor = [UIColor whiteColor];
        
        self.ivBackground = [[UIImageView alloc] init];
        self.ivBackground.backgroundColor = [UIColor clearColor];
        self.ivBackground.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.ivBackground];
        
        self.blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        self.blurView.hidden = YES;
        [self addSubview:self.blurView];
        
        self.ivIcon = [[UIImageView alloc] init];
        [self addSubview:self.ivIcon];
        
        self.lbText = [[UILabel alloc] init];
        self.lbText.textColor = [UIColor grayColor];
        self.lbText.backgroundColor = [UIColor clearColor];
        self.lbText.textAlignment = NSTextAlignmentCenter;
        self.lbText.numberOfLines = 0;
        self.lbText.font = [UIFont systemFontOfSize:14];
        self.lbText.text = @"暂无数据";
        [self addSubview:self.lbText];
        
        self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 140, 32)];
        self.button.titleLabel.font = [UIFont systemFontOfSize:14];
        self.button.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.button.layer.borderWidth = 1.0f/[UIScreen mainScreen].scale;
        self.button.layer.cornerRadius = 5;
        
        [self.button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.button addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.button];
        self.button.hidden = YES;
        
        //点击手势
        UITapGestureRecognizer *tapGestureRecognizer =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tapGestureRecognizer];
        tapGestureRecognizer.cancelsTouchesInView = YES;//为yes只响应优先级最高的事件，Button高于手势，textfield高于手势，textview高于手势，手势高于tableview。为no同时都响应，默认为yes
    }
    return self;
}

/**展示空页面(有默认的文字和图片，show之后可以更改文字图片)*/
+ (LFErrorView *)showEmptyInView:(UIView *)supView frame:(CGRect)frame tapBlock:(void(^)(void))tapBlock {
    LFErrorView *errorView = [[LFErrorView alloc] initWithFrame:frame];
    errorView.ivIcon.image = [UIImage imageNamed:@"LFEmptyIcon"];
    errorView.lbText.text = @"暂无数据";
    errorView.tapBlock = tapBlock;
    [supView addSubview:errorView];
    return errorView;
}

/**展示错误页面(有默认的图片，show之后可以更改图片)*/
+ (LFErrorView *)showErrorInView:(UIView *)supView message:(NSString *)message frame:(CGRect)frame tapBlock:(void(^)(void))tapBlock {
    LFErrorView *errorView = [[LFErrorView alloc] initWithFrame:frame];
    errorView.ivIcon.image = [UIImage imageNamed:@"LFErrorIcon"];
    errorView.lbText.text = message;
    errorView.tapBlock = tapBlock;
    [supView addSubview:errorView];
    return errorView;
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
    self.button.hidden = self.button.currentTitle.length < 1;
    
    self.ivIcon.frame = CGRectMake((self.frame.size.width - coverImageW)/2, (self.frame.size.height - itemTotalH)/2, coverImageW, coverImageH);
    
    self.lbText.frame = CGRectMake(self.labelMargin, CGRectGetMaxY(self.ivIcon.frame) + self.itemSpace, self.frame.size.width - self.labelMargin*2, lbH);
    
    CGFloat btY = CGRectGetMaxY(self.lbText.frame) + self.itemSpace;
    if (self.lbText.text.length < 1) {
        btY = CGRectGetMaxY(self.ivIcon.frame) + self.itemSpace;
    }
    
    self.button.frame = CGRectMake((self.frame.size.width - self.button.frame.size.width)/2, btY, self.button.frame.size.width, self.button.frame.size.height);
}

- (void)tapAction:(id)sender {
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        if (self.button.currentTitle.length > 0) {
            return;
        }
    }
    if (self.tapBlock) {
        self.tapBlock();
    }
}

- (void)setNeedBlurEffect:(BOOL)needBlurEffect {
    _needBlurEffect = needBlurEffect;
    self.blurView.hidden = !_needBlurEffect;
}

@end
