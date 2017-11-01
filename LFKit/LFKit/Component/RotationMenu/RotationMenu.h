//
//  RotationMenu.h
//  BaseAPP
//
//  Created by 张林峰 on 15/12/23.
//  Copyright © 2015年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef void(^ButtonBlock)(UIButton *);

@interface RotationMenu : UIView

@property (nonatomic, copy) ButtonBlock btnBlock;

/**
 *  初始化旋转菜单，一个中心按钮，周围若干个个按钮
 *
 *  @param menuRadius           整个菜单的半径
 *  @param centerRadius         中心按钮半径
 *  @param subRadius            周围按钮半径
 *  @param centerImageName      中心按钮图片名字
 *  @param centerBackgroundName 中心按钮背景图名字
 *  @param arraySubImgs         周围按钮图片名字的数组
 *  @param x                    菜单中心的横坐标
 *  @param y                    菜单中心纵坐标
 *  @param parentView           菜单的父视图
 *
 *  @return 菜单
 */
- (id)initWithMenuRadius:(CGFloat)menuRadius
            centerRadius:(NSInteger)centerRadius
               subRadius:(CGFloat)subRadius
             centerImage:(NSString *)centerImageName
        centerBackground:(NSString *)centerBackgroundName
           subImagesName:(NSArray *)arraySubImgs
             MenuCenterX:(CGFloat)x
             MenuCenterY:(CGFloat)y
            toParentView:(UIView *)parentView;

@end
