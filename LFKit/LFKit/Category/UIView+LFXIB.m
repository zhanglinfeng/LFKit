//
//  UIView+LFXIB.m
//  APPBaseSDK
//
//  Created by 张林峰 on 16/11/2.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import "UIView+LFXIB.h"

@implementation UIView (LFXIB)

- (void)setLfCornerRadius:(NSInteger)lfCornerRadius{
    self.layer.cornerRadius = lfCornerRadius;
    self.layer.masksToBounds = lfCornerRadius > 0;
}

- (NSInteger)lfCornerRadius{
    return self.layer.cornerRadius;
}

- (void)setLfBorderColor:(UIColor *)lfBorderColor{
    self.layer.borderColor = lfBorderColor.CGColor;
}

- (UIColor *)lfBorderColor{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setPxBorderWidth:(NSInteger)pxBorderWidth{
    self.layer.borderWidth = pxBorderWidth / [UIScreen mainScreen].scale;
}

- (NSInteger)pxBorderWidth{
    return self.layer.borderWidth * [UIScreen mainScreen].scale;
}



- (void)setPxWidth:(CGFloat)pxWidth {
    CGRect rect = self.frame;
    rect.size.width = pxWidth / [UIScreen mainScreen].scale;
    self.frame = rect;
}

- (CGFloat)pxWidth {
    return self.frame.size.width * [UIScreen mainScreen].scale;
}

- (void)setPxHeight:(CGFloat)pxHeight {
    CGRect rect = self.frame;
    rect.size.height = pxHeight / [UIScreen mainScreen].scale;
    self.frame = rect;
}

- (CGFloat)pxHeight {
    return self.frame.size.height * [UIScreen mainScreen].scale;
}

@end
