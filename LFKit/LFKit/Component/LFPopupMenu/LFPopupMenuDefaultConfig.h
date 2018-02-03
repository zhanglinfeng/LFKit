//
//  LFPopupMenuDefaultConfig.h
//  LFKit
//
//  Created by 张林峰 on 2018/2/3.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 （可选）配置LFPopupMenu默认样式的单例，只需应用启动时配置一次即可,就不用每次繁琐的设置那些属性
 */

@interface LFPopupMenuDefaultConfig : NSObject <NSCopying>

@property (nonatomic, assign) CGFloat rowHeight;//行高,默认60
@property (nonatomic, assign) CGFloat arrowH;//箭头形高,默认9
@property (nonatomic, assign) CGFloat arrowW;//箭头形宽,默认9
@property (nonatomic, assign) CGFloat minWidth;//弹窗最小宽度，默认0
@property (nonatomic, assign) CGFloat popupMargin;//窗口距屏幕边缘最小距离，默认5
@property (nonatomic, assign) CGFloat leftEdgeMargin;//左边距窗口的距离，默认16
@property (nonatomic, assign) CGFloat rightEdgeMargin;//右边距窗口的距离，默认16
@property (nonatomic, assign) CGFloat textMargin;//文字距图标的距离，默认8
@property (nonatomic, assign) CGFloat lineMargin;//分割线左边距，默认0
@property (nonatomic, assign) CGFloat cornerRadius;//弹窗圆角,默认6
@property (nonatomic, assign) CGFloat arrowCornerRadius;//箭头的圆角，默认0
@property (nonatomic, strong) UIColor *lineColor;//分割线颜色、边框色，默认系统灰色
@property (nonatomic, strong) UIFont *textFont;//默认15
@property (nonatomic, strong) UIColor *textColor;//默认黑色
@property (nonatomic, strong) UIColor *fillColor;//带箭头框的填充色，默认白色
@property (nonatomic, assign) BOOL needBorder;//是否要边框

+ (instancetype)sharedInstance;

@end
