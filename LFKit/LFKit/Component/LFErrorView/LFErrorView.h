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
@property (nonatomic, strong) UIImageView *ivIcon;
@property (nonatomic, strong) UILabel *lbText;//默认灰色14号字体
@property (nonatomic, strong) UIButton *button;//点击按钮,外面可设置其大小,默认灰色14号字体
@property (nonatomic, assign) CGFloat itemSpace;//每个子控件间距，默认20
@property (nonatomic, assign) CGFloat labelMargin;//label与父视图边距，默认40

@property (nonatomic, copy) void(^tapBlock)(void);//有按钮文字则是点击按钮的事件，没按钮则是点击整个页面的事件,点击了本页面会自动消失


- (instancetype)initWithIcon:(UIImage *)icon text:(NSString *)text btnTitle:(NSString*)btnTitle;

@end
