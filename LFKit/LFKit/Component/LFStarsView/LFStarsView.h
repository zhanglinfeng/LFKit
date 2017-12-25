//
//  LFStarsView.h
//  LFKit
//
//  Created by 张林峰 on 2017/12/25.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 星级等级视图，支持小数，可设置是否可点击
 */
@interface LFStarsView : UIView

@property (nonatomic, assign) CGFloat value;
@property (nonatomic, strong) UIColor *bgColor;//背景色,默认白色。不要设置透明色，可设置跟父视图一样的颜色替代透明色。
@property (nonatomic, copy) void(^selectBlock)(CGFloat value);//设置了回调则可点击或滑动选择星级，不设置则不可点击、滑动

- (instancetype)initWithFrame:(CGRect)frame starNumber:(NSInteger)number image:(UIImage *)image highlightImage:(UIImage *)hImage;

@end
