//
//  NSLayoutConstraint+LFXIB.m
//  APPBaseSDK
//
//  Created by 张林峰 on 16/11/2.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import "NSLayoutConstraint+LFXIB.h"

@implementation NSLayoutConstraint (LFXIB)

- (void)setPxConstant:(CGFloat)pxConstant {
    self.constant = pxConstant / [UIScreen mainScreen].scale;
}

- (CGFloat)pxConstant {
    return self.constant * [UIScreen mainScreen].scale;
}

@end
