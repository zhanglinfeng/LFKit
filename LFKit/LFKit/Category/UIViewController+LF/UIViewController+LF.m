//
//  UIViewController+LF.m
//  QingShe
//
//  Created by 张林峰 on 2022/9/24.
//

#import "UIViewController+LF.h"

@implementation UIViewController (LF)

/**获取当前控制器*/
+ (UIViewController*)lf_currentViewController {
    return [self lf_currentViewControllerWithRootViewController:[self lf_getKeyWindow].rootViewController];
}

/**获取KeyWindow*/
+ (UIWindow *)lf_getKeyWindow {
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        return window;
                        break;
                    }
                }
            }
        }
    }
    else {
        return [UIApplication sharedApplication].keyWindow;
    }
    return nil;
}

/**从根控制器上获取当前控制器*/
+ (UIViewController *)lf_currentViewControllerWithRootViewController:(UIViewController *)rootViewController {
    if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self lf_currentViewControllerWithRootViewController:presentedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self lf_currentViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self lf_currentViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else {
        return rootViewController;
    }
}

/**获取view所在的控制器*/
+ (UIViewController *)lf_viewControllerOfView:(UIView *)view {
    // 遍历响应者链。返回第一个找到视图控制器
    UIResponder *responder = view;
    while ((responder = [responder nextResponder])){
        if ([responder isKindOfClass: [UIViewController class]]){
            return (UIViewController *)responder;
        }
    }
    // 如果没有找到则返回nil
    return nil;
}

@end
