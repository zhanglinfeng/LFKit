//
//  LFNestedScrollContainer.h
//  LFKit
//
//  Created by 张林峰 on 2019/8/23.
//  Copyright © 2019 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LFNestedPageScroll.h"

NS_ASSUME_NONNULL_BEGIN

/** 最外层的嵌套滑动容器（嵌套的是view，如果要嵌套控制器，推荐用LFNestPageContainer） */
@interface LFNestedScrollContainer : UIScrollView

@property (nonatomic, copy) void(^scrollViewDidScrollBlock)(UIScrollView *scrollView);

/**以下2个视图都要设置正确的Frame再setup*/
- (void)setupHeader:(UIView *)headerView;
- (void)setupSegment:(UIView *)segmentView;

- (void)setupPageScroll:(LFNestedPageScroll *)pageScroll;

@end

NS_ASSUME_NONNULL_END
