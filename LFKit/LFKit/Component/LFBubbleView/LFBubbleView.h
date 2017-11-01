//
//  LFBubbleView.h
//  LFBubbleViewDemo
//
//  Created by 张林峰 on 16/6/29.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>

//默认背景色
#define kLFBubbleViewColor          [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5]
//默认圆角
#define kLFBubbleViewCornerRadius   5
//默认三角形高
#define kLFBubbleViewTriangleH      7
//默认三角形底边长
#define kLFBubbleViewTriangleW      7
//默认字体颜色
#define kELBubbleViewTextColor  [UIColor whiteColor];
//默认字体大小
#define kELBubbleViewFont 12

typedef NS_ENUM(NSInteger, LFTriangleDirection) {
    LFTriangleDirection_Down,
    LFTriangleDirection_Left,
    LFTriangleDirection_Right,
    LFTriangleDirection_Up
};

@interface LFBubbleView : UIView

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) CGFloat cornerRadius;//圆角
@property (nonatomic, assign) CGFloat triangleH;//三角形高
@property (nonatomic, assign) CGFloat triangleW;//三角形底边长
@property (nonatomic, strong) UIView *contentView;//容器，可放自定义视图，默认装文字
@property (nonatomic, strong) UILabel *lbTitle;//提示文字
@property (nonatomic) LFTriangleDirection direction;//三角方向，默认朝下
@property (nonatomic, assign) CGFloat dismissAfterSecond;//hideAfterSecond秒后自动消失，不设置则不自动消失
@property (nonatomic, strong) NSString *showOnceKey;//如果设置了Key，该气泡只显示一次（比如某个新功能只需要提示用户一次）

//优先使用triangleXY。如果triangleXY和triangleXYScale都不设置，则三角在中间
@property (nonatomic, assign) CGFloat triangleXY;//三角中心的x或y（三角朝上下代表x,三角朝左右代表y）
@property (nonatomic, assign) CGFloat triangleXYScale;//三角的中心x或y位置占边长的比例，如0.5代表在中间

/**
 *  显示
 *
 *  @param point 三角顶端位置
 */
- (void)showInPoint:(CGPoint)point;

/**来回平移动画*/
- (void)doTranslationAnimate;

/**弹跳动画*/
- (void)doSpringAnimate;

@end
