//
//  LFBubbleViewDefaultConfig.h
//  LFKit
//
//  Created by 张林峰 on 2018/2/3.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 （可选）配置LFBubbleView默认样式的单例，只需应用启动时配置一次即可,就不用每次繁琐的设置那些属性
 */
@interface LFBubbleViewDefaultConfig : NSObject <NSCopying>

@property (nonatomic, strong) UIColor *color;//背景色，默认红色半透明
@property (nonatomic, strong) UIColor *textColor;//字体颜色，默认白色
@property (nonatomic, strong) UIFont *font;//字体，默认12
@property (nonatomic, strong) UIColor *borderColor;//边框色，默认无
@property (nonatomic, assign) CGFloat borderWidth;//默认无
@property (nonatomic, assign) CGFloat cornerRadius;//圆角，默认5
@property (nonatomic, assign) CGFloat triangleH;//三角形高.默认7
@property (nonatomic, assign) CGFloat triangleW;//三角形底边长默认7
@property (nonatomic) UIEdgeInsets edgeInsets;//label四周边距，默认(5,5,5,5)

+ (instancetype)sharedInstance;

@end
