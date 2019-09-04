//
//  UIColor+LF.h
//  LFQRCode
//
//  Created by 张林峰 on 2017/5/16.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LF)

/**获取图片某位置的颜色*/
+ (UIColor *)lf_colorFromImage:(UIImage *)image atPoint:(CGPoint)point;

@end
