//
//  NSLayoutConstraint+LFXIB.h
//  APPBaseSDK
//
//  Created by 张林峰 on 16/11/2.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>

//给xib的属性面板加如下属性，代码写的UI也可以使用如下属性
//IB_DESIGNABLE //这个只能自定义控件加
@interface NSLayoutConstraint (LFXIB)

@property (assign,nonatomic) IBInspectable CGFloat pxConstant; //约束的值，单位px

@end
