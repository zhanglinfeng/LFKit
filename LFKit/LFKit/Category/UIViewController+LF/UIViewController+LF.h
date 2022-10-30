//
//  UIViewController+LF.h
//  QingShe
//
//  Created by 张林峰 on 2022/9/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (LF)

/**获取KeyWindow*/
+ (UIWindow *)lf_getKeyWindow;

/**获取当前控制器*/
+ (UIViewController *)lf_currentViewController;

/**从根控制器上获取当前控制器*/
+ (UIViewController *)lf_currentViewControllerWithRootViewController:(UIViewController *)rootViewController;

/**获取view所在的控制器*/
+ (UIViewController *)lf_viewControllerOfView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
