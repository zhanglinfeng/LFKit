//
//  UIViewController+FullScreenScroll.h
//  APPBaseSDK
//
//  Created by 张林峰 on 16/6/25.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kFullScreenScrollNotification @"kELFullScreenScrollNotification"

@interface UIViewController (FullScreenScroll) <UIGestureRecognizerDelegate>

@property (nonatomic) NSNumber *startY;//手势开始位置

/**添加上下滑动手势*/
- (void)addSwipe:(UIView *)inView;

/**添加上下滑动手势触发事件*/
- (void)handleSwipe:(UISwipeGestureRecognizer *)gesture;

@end
