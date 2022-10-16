//
//  UITextView+LF.m
//  LFKit
//
//  Created by 张林峰 on 2019/9/2.
//  Copyright © 2019 张林峰. All rights reserved.
//

#import "UITextView+LF.h"
#import <objc/runtime.h>
@interface UITextView ()
@property (nonatomic,strong) UILabel *placeholderLabel;//占位符
@property (nonatomic,strong) UILabel *countLabel;//计算字数


@end


static NSString *placeholderKey = @"placeholderKey";
static NSString *placeholderFontKey = @"placeholderFontKey";
static NSString *placeholderColorKey = @"placeholderColorKey";

static NSString *maxCountKey = @"maxCountKey";
static NSString *countFontKey = @"countFontKey";
static NSString *countColorKey = @"countColorKey";
static NSString *isLimitKey = @"isLimitKey";
static NSString *insetDicKey = @"insetDicKey";

static NSString *placeholderLabelKey = @"placeholderLabelKey";
static NSString *countLabelKey = @"countLabelKey";

static NSString *textDidChangeKey = @"textDidChangeKey";

@implementation UITextView (LF)

#pragma mark - 运行时增加属性

- (void)setPlaceholderLabel:(UILabel *)placeholderLabel {
    objc_setAssociatedObject(self, &placeholderLabelKey, placeholderLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)placeholderLabel {
    UILabel *lb = objc_getAssociatedObject(self, &placeholderLabelKey);
    if (!lb) {
        lb = [[UILabel alloc] init];
        lb.font = self.placeholderFont;
        lb.textColor = self.placeholderColor;
        self.placeholderLabel = lb;
        [self addSubview:lb];
    }
    return lb;
}

- (void)setCountLabel:(UILabel *)countLabel {
    objc_setAssociatedObject(self, &countLabelKey, countLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)countLabel {
    UILabel *lb = objc_getAssociatedObject(self, &countLabelKey);
    if (!lb) {
        lb = [[UILabel alloc] init];
        lb.font = self.countFont;
        lb.textColor = self.countColor;
        self.countLabel = lb;
        [self addSubview:lb];
    }
    return lb;
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.placeholderLabel.text = placeholder;
    self.placeholderLabel.hidden = self.text.length > 0;
    objc_setAssociatedObject(self, &placeholderKey, placeholder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewChanged:) name:UITextViewTextDidChangeNotification object:self];
}

- (NSString *)placeholder {
    return objc_getAssociatedObject(self, &placeholderKey);
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    self.placeholderLabel.font = placeholderFont;
    objc_setAssociatedObject(self, &placeholderFontKey, placeholderFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIFont *)placeholderFont {
    return objc_getAssociatedObject(self, &placeholderFontKey) == nil ? [UIFont systemFontOfSize:13.] : objc_getAssociatedObject(self, &placeholderFontKey);
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    self.placeholderLabel.textColor = placeholderColor;
    objc_setAssociatedObject(self, &placeholderColorKey, placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)placeholderColor {
    return objc_getAssociatedObject(self, &placeholderColorKey) == nil ? [UIColor lightGrayColor] : objc_getAssociatedObject(self, &placeholderColorKey);
}

- (void)setMaxCount:(NSNumber *)maxCount {
    self.countLabel.text = [NSString stringWithFormat:@"%@/%@",@(self.text.length),maxCount];
    objc_setAssociatedObject(self, &maxCountKey, maxCount, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewChanged:) name:UITextViewTextDidChangeNotification object:self];
}

- (NSNumber *)maxCount {
    return objc_getAssociatedObject(self, &maxCountKey);
}

- (void)setCountFont:(UIFont *)countFont {
    self.countLabel.font = countFont;
    objc_setAssociatedObject(self, &countFontKey, countFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIFont *)countFont {
    return objc_getAssociatedObject(self, &countFontKey) == nil ? [UIFont systemFontOfSize:13.] : objc_getAssociatedObject(self, &countFontKey);
}

- (void)setCountColor:(UIColor *)countColor {
    self.countLabel.textColor = countColor;
    objc_setAssociatedObject(self, &countColorKey, countColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)countColor {
    return objc_getAssociatedObject(self, &placeholderColorKey) == nil ? [UIColor lightGrayColor] : objc_getAssociatedObject(self, &placeholderColorKey);
}

- (void)setIsLimit:(NSNumber *)isLimit {
    objc_setAssociatedObject(self, &isLimitKey, isLimit, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)isLimit {
    return objc_getAssociatedObject(self, &isLimitKey);
}

- (void)setInsetDic:(NSDictionary *)insetDic {
    objc_setAssociatedObject(self, &insetDicKey, insetDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)insetDic {
    return objc_getAssociatedObject(self, &insetDicKey) == nil ? @{@"top":@(8),@"left":@(8),@"bottom":@(8),@"right":@(8)} : objc_getAssociatedObject(self, &placeholderColorKey);
}

- (void)setTextDidChangeBlock:(TextDidChange)textDidChangeBlock {
    objc_setAssociatedObject(self, &textDidChangeKey, textDidChangeBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (TextDidChange)textDidChangeBlock {
    return objc_getAssociatedObject(self, &textDidChangeKey);
}

- (void)textViewChanged:(NSNotification *)notification {
    if (self.placeholder) {
        self.placeholderLabel.hidden = self.text.length > 0;
    }
    
    
    BOOL isOut = NO;
    NSInteger maxLength = self.maxCount.integerValue;
    if (self.isLimit.integerValue == 1 && self.maxCount.integerValue > 0) {
        
        if (self.text.length > maxLength) {
            UITextRange *markedRange = [self markedTextRange];
            if (markedRange) {
                return;
            }
            isOut = YES;
            //Emoji占2个字符，如果是超出了半个Emoji，用maxLength位置来截取会出现Emoji截为2半
            //超出最大长度的那个字符序列(Emoji算一个字符序列)的range
            NSRange range = [self.text rangeOfComposedCharacterSequenceAtIndex:maxLength];
            self.text = [self.text substringToIndex:range.location];
        }
    } else {
        isOut = self.text.length > maxLength;
    }
    
    if (self.maxCount) {
        CGFloat bottom = ((NSNumber *)self.insetDic[@"bottom"]).floatValue;
        CGFloat right = ((NSNumber *)self.insetDic[@"right"]).floatValue;
        self.countLabel.text = [NSString stringWithFormat:@"%@/%@",@(self.text.length),self.maxCount];
        [self.countLabel sizeToFit];
        self.countLabel.frame = CGRectMake(self.frame.size.width - self.countLabel.frame.size.width - right, self.frame.size.height - self.countLabel.frame.size.height - bottom, self.countLabel.frame.size.width, self.countLabel.frame.size.height);
    }
    
    if (self.textDidChangeBlock) {
        self.textDidChangeBlock(self.text, isOut);
    }
    
}

- (void)lf_layoutSubviews {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat top = ((NSNumber *)self.insetDic[@"top"]).floatValue;
        CGFloat left = ((NSNumber *)self.insetDic[@"left"]).floatValue;
        CGFloat bottom = ((NSNumber *)self.insetDic[@"bottom"]).floatValue;
        CGFloat right = ((NSNumber *)self.insetDic[@"right"]).floatValue;
        if (self.placeholder) {
            [self.placeholderLabel sizeToFit];
            self.placeholderLabel.frame = CGRectMake(left, top, self.placeholderLabel.frame.size.width, self.placeholderLabel.frame.size.height);
        }
        if (self.maxCount) {
            [self.countLabel sizeToFit];
            self.countLabel.frame = CGRectMake(self.frame.size.width - self.countLabel.frame.size.width - right, self.frame.size.height - self.countLabel.frame.size.height - bottom, self.countLabel.frame.size.width, self.countLabel.frame.size.height);
        }
    });
}

@end
