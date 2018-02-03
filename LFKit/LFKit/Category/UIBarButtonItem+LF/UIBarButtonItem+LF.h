//
//  UIBarButtonItem+LF.h
//  APPBaseSDK
//
//  Created by 张林峰 on 16/11/2.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (LF)

/**导航上的图片按钮*/
+ (UIBarButtonItem *)itemWithImage:(UIImage *)image action:(void(^)(void))action;

/**导航上的文字按钮*/
+ (UIBarButtonItem *)itemWithTitle:(NSString*)title action:(void(^)(void))action;

/**导航上的图片+文字按钮*/
+ (UIBarButtonItem *)itemWithmage:(UIImage *)image title:(NSString *)title action:(void(^)(void))action;

@end
