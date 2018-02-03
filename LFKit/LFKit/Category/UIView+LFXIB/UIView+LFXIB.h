//
//  UIView+LFXIB.h
//  APPBaseSDK
//
//  Created by 张林峰 on 16/11/2.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>

//给xib的属性面板加如下属性，代码写的UI也可以使用如下属性
//IB_DESIGNABLE //这个只能自定义控件加
@interface UIView (LFXIB)

@property (assign,nonatomic) IBInspectable NSInteger lfCornerRadius; //圆角
@property (strong,nonatomic) IBInspectable UIColor  *lfBorderColor; //边框色，UIColor类型
@property (assign,nonatomic) IBInspectable NSInteger pxBorderWidth; //边框宽，单位px
@property (assign,nonatomic) IBInspectable CGFloat pxWidth; //宽，单位px
@property (assign,nonatomic) IBInspectable CGFloat pxHeight; //高，单位px

@end
