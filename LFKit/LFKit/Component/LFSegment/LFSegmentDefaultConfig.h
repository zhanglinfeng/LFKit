//
//  LFSegmentDefaultConfig.h
//  LFKit
//
//  Created by 张林峰 on 2018/2/3.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LFSegmentIndicateStyle) {
    LFSegmentIndicateStyleAlignText, //指示线对齐文字
    LFSegmentIndicateStyleAlignFull, //指示线对齐整个
};


/**
 （可选）配置LFSegmentView默认样式的单例，只需应用启动时配置一次即可,就不用每次繁琐的设置那些属性
 */
@interface LFSegmentDefaultConfig : NSObject

@property (nonatomic) LFSegmentIndicateStyle indicateStyle;
@property (nonatomic, strong) UIFont * _Nonnull font;//字体，默认16
@property (nonatomic, strong, nullable) UIColor *selectedColor;//选中的字体颜色,默认红色
@property (nonatomic, strong, nullable) UIColor *normalColor;//未选中的字体颜色，默认灰色
@property (nonatomic, strong, nullable) UIColor *indicateColor;//指示线颜色,默认和字体颜色一样
@property (nonatomic, assign) CGFloat indicateHeight;//指示线高，默认2
@property (nonatomic, assign) CGFloat minItemSpace;//最小间距，默认20

+ (instancetype _Nullable )sharedInstance;

@end
