//
//  UIView+LF.h
//  APPBaseSDK
//
//  Created by 张林峰 on 16/11/10.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LFTapViewBlock)(UITapGestureRecognizer *gesture);

@interface UIView (LF)

@property (nonatomic, copy) LFTapViewBlock tapViewBlock;//点击事件

@end
