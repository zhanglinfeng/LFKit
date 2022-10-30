//
//  LFErrorView.h
//  LFKit
//
//  Created by 张林峰 on 2017/10/27.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFErrorView : UIView

@property (nonatomic, strong) UIImageView *ivBackground;//背景图
@property (nonatomic, assign) BOOL needBlurEffect;
@property (nonatomic, strong) UIImageView *ivIcon;//默认暂无数据的icon
@property (nonatomic, strong) UILabel *lbText;//默认“暂无数据”
@property (nonatomic, strong) UIButton *button;//点击按钮,默认隐藏,文字为空,设置了文字就会自动显示

//如果show了之后要改下面属性值，需调用一下layoutSubviews
@property (nonatomic, assign) CGFloat itemSpace;//每个子控件间距，默认20
@property (nonatomic, assign) CGFloat labelMargin;//label与父视图边距，默认40
@property (nonatomic, assign) CGFloat iconTop; // 图片距离顶部。 如果这个数字超过图片上下居中时距顶部的距离，则上下居中。
@property (nonatomic, copy) void(^tapBlock)(LFErrorView *errorView);//有按钮文字则是点击按钮的事件，没按钮则是点击整个页面的事件




/**展示空页面(如果有颜色、字体、间距等样式调整，可建一个子类，重写该方法)*/
+ (LFErrorView *)showEmptyInView:(UIView *)supView tapBlock:(void(^)(LFErrorView *errorView))tapBlock;

/**展示错误页面(如果有颜色、字体、间距等样式调整，可建一个子类，重写该方法)*/
+ (LFErrorView *)showErrorInView:(UIView *)supView message:(NSString *)message tapBlock:(void(^)(LFErrorView *errorView))tapBlock;


@end

@interface UIView (ErrorView)

- (LFErrorView *)showEmptyView:(void(^)(LFErrorView *errorView))tapBlock;

- (LFErrorView *)showErrorView:(void(^)(LFErrorView *errorView))tapBlock;

- (void)hideErrorView;

@end
