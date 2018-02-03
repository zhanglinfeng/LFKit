//
//  UIBarButtonItem+LF.m
//  APPBaseSDK
//
//  Created by 张林峰 on 16/11/2.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import "UIBarButtonItem+LF.h"
#import "UIButton+LF.h"

@implementation UIBarButtonItem (LF)

/**导航上的图片按钮*/
+ (UIBarButtonItem *)itemWithImage:(UIImage *)image action:(void (^)(void))action {
    UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [itemBtn setImage:image forState:UIControlStateNormal];
    [itemBtn sizeToFit];
    itemBtn.btnAction = action;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:itemBtn];
    return item;
}

/**导航上的文字按钮*/
+ (UIBarButtonItem *)itemWithTitle:(NSString*)title action:(void (^)(void))action {
    UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [itemBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [itemBtn setTitle:title forState:UIControlStateNormal];
    [itemBtn sizeToFit];
    itemBtn.btnAction = action;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:itemBtn];
    return item;
}

/**导航上的图片+文字按钮*/
+ (UIBarButtonItem *)itemWithmage:(UIImage *)image title:(NSString *)title action:(void (^)(void))action {
    UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [itemBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [itemBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [itemBtn setImage:image forState:UIControlStateNormal];
    [itemBtn setTitle:title forState:UIControlStateNormal];
    [itemBtn sizeToFit];
    itemBtn.btnAction = action;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:itemBtn];
    return item;
}

@end
