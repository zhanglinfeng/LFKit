//
//  LFBaseCardView.h
//  LFKit
//
//  Created by 张林峰 on 2018/1/22.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LFBaseCardAnimate) {
    LFBaseCardAnimateNormal,//中间
    LFBaseCardAnimateFromBottom,//从底部滑出并贴着底部
    LFBaseCardAnimateFromBottomToCenter,//从底部到中间(待实现)
    LFBaseCardAnimateFromTop,//从顶部滑出并贴着顶部(待实现)
    LFBaseCardAnimateFromTopToCenter//从顶部到中间(待实现)
};

@interface LFBaseCardView : UIView

@property (nonatomic, assign) CGFloat windowY;//窗口的y位置，不设置则上下居中(如果有键盘，会自动去掉键盘大小后，再上下居中)
@property (nonatomic, assign) CGFloat windowW;//窗口的宽度（不设置则需要由控制器子视图的约束来确定窗口大小）
@property (nonatomic, assign) CGFloat windowH;//窗口的高度(不设置则需要由控制器子视图的约束来确定窗口大小）
@property (nonatomic, assign) BOOL isFullWidth;//是否宽度全屏（针对横屏也要宽度全屏）
@property (nonatomic, assign) BOOL isFullHeight;//是否高度全屏
@property (nonatomic, assign) BOOL hideMask;//半透明背景遮罩层，
@property (nonatomic, assign) BOOL needTapGesture;//是否需要点击空白处消失,默认yes点空白自动消失
@property (nonatomic, copy) void(^tapBlankBlock)(void); //点击空白回调
@property (nonatomic, copy) void(^dismissCompletion)(void); //弹窗消失完成回调

- (void)showIn:(UIView *)superview animate:(LFBaseCardAnimate)animate;

- (void)dismiss;

@end
