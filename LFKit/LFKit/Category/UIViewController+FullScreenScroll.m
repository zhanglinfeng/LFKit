//
//  UIViewController+FullScreenScroll.m
//  APPBaseSDK
//
//  Created by 张林峰 on 16/6/25.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import "UIViewController+FullScreenScroll.h"
#import "UITabBarController+HideTabBar.h"
#import <objc/runtime.h>

static void *startYKey = &startYKey;


@implementation UIViewController (FullScreenScroll)

- (NSNumber *)startY {
    return objc_getAssociatedObject(self, &startYKey);
}

-(void)setStartY:(NSNumber *)startY {
    objc_setAssociatedObject(self, & startYKey, startY, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)addSwipe:(UIView *)inView {
    //上下滑动手势
    UIPanGestureRecognizer *swipeGestureRecognizer=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
    //    [swipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
    [inView addGestureRecognizer:swipeGestureRecognizer];
    swipeGestureRecognizer.cancelsTouchesInView = NO;//为yes只响应优先级最高的事件，Button高于手势，textfield高于手势，textview高于手势，手势高于tableview。为no同时都响应，默认为yes
    swipeGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}
- (void)handleSwipe:(UISwipeGestureRecognizer *)gesture {
    CGPoint touchPoint = [gesture locationInView:self.view];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.startY = @(touchPoint.y);
    }
    if((touchPoint.y - self.startY.floatValue) > 30) {
        [self.tabBarController setTabBarHidden:NO animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:kFullScreenScrollNotification object:@(NO)];
    } else if ((touchPoint.y - self.startY.floatValue) < -30) {
        [self.tabBarController setTabBarHidden:YES animated:YES];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:kFullScreenScrollNotification object:@(YES)];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
        return YES;
    }
    return NO;
    
}

@end
