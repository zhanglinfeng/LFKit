//
//  UIImage+LF.h
//  APPBaseSDK
//
//  Created by 张林峰 on 16/5/29.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TriangleDirection) {
    TriangleDirection_Down,
    TriangleDirection_Left,
    TriangleDirection_Right,
    TriangleDirection_Up
};

@interface UIImage (LF)

/**生成纯色图片*/
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**生成渐变色图片*/
+ (UIImage *)imageWithRect:(CGSize)size StartColor:(UIColor *)startColor endColor:(UIColor *)endColor StartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

/**生成三角图片direction为角的方向*/
+ (UIImage *)imageWithRect:(CGSize)size color:(UIColor *)color direction:(TriangleDirection)direction;

/**生成截屏图片*/
+ (UIImage *)captureWithView:(UIView *)view;


#pragma mark - 毛玻璃效果
-(UIImage*)applyLightEffect;
-(UIImage*)applyExtraLightEffect;
-(UIImage*)applyDarkEffect;
-(UIImage*)applyTintEffectWithColor:(UIColor*)tintColor;
-(UIImage*)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor*)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage*)maskImage;

@end
