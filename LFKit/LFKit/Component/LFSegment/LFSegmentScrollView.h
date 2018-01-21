//
//  LFSegmentScrollView.h
//  LFKit
//
//  Created by 张林峰 on 2018/1/21.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFSegmentView.h"

@interface LFSegmentScrollView : UIScrollView

@property (nonatomic, strong) NSArray <UIViewController *>*viewControllers;
@property (nonatomic, strong) LFSegmentView *segmentView;
@property (nonatomic, strong, readonly) UIViewController *currentViewController;

@property (nonatomic, readonly) NSUInteger currentIndex;

@property (nonatomic, copy) void(^selectedBlock)(NSUInteger index, UIButton *button, UIViewController *viewController);

- (instancetype)initWithFrame:(CGRect)frame controller:(UIViewController *)controller;

- (void)setSelectedAtIndex:(NSUInteger)index;

@end
