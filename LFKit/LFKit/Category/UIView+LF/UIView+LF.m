//
//  UIView+LF.m
//  APPBaseSDK
//
//  Created by 张林峰 on 16/11/10.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import "UIView+LF.h"
#import <objc/runtime.h>

static void *tapViewBlockKey = &tapViewBlockKey;

@implementation UIView (LF)

#pragma mark - 给view添加点击事件

- (LFTapViewBlock)tapViewBlock {
    return objc_getAssociatedObject(self, &tapViewBlockKey);
}

-(void)setTapViewBlock:(LFTapViewBlock)tapViewBlock {
    objc_setAssociatedObject(self, & tapViewBlockKey, tapViewBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addTapBlock];
}

/**添加点击事件*/
- (void)addTapBlock{
    self.userInteractionEnabled = YES; // label默认是NO，所以要设置为yes
    UITapGestureRecognizer *tapGestureRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.cancelsTouchesInView = YES; //为yes只响应优先级最高的事件，Button高于手势，textfield高于手势，textview高于手势，手势高于tableview。为no同时都响应，默认为yes
}

/**点击事件回调*/
- (void)tapped:(UITapGestureRecognizer *)gesture {
    if (self.tapViewBlock) {
        self.tapViewBlock(gesture);
    }
}

@end
