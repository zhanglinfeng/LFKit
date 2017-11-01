//
//  UITabBarController+HideTabBar.h
//  APPBaseSDK
//
//  Created by 张林峰 on 16/6/25.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TABBAR_HEIGHT (49)

@interface UITabBarController (HideTabBar)

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;

@end
