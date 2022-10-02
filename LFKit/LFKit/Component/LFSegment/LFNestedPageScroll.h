//
//  LFNestedPageScroll.h
//  LFKit
//
//  Created by 张林峰 on 2019/8/23.
//  Copyright © 2019 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFSegmentView.h"

NS_ASSUME_NONNULL_BEGIN

/** 横向滚动的嵌套页面（嵌套的是view，如果要嵌套控制器推荐用LFNestPageController）
 搭配使用组合：
 1.LFNestedPageScroll单独使用
 2.LFSegmentView + LFNestedPageScroll
 3.LFSegmentView + LFNestedPageScroll + LFNestedScrollContainer
 */
@interface LFNestedPageScroll : UIScrollView

@property (nonatomic, strong) LFSegmentView *segmentView;

@property (nonatomic, strong) NSArray <UIView *>*tableViews; //列表数组,可以是tableview、collectionView,甚至是里面含有tableview的UIView等等

@property (nonatomic, readonly) NSUInteger currentIndex; //当前索引

@property (nonatomic, copy) void(^didMoveToIndexBlock)(NSUInteger index);// 滑动到index

@property (nonatomic, copy) void(^didAddTableViewBlock)(NSArray *tables); // 已经加了tableview,或collectionView等UIScrollView类型的视图

//设置选中第几个
- (void)setSelectedAtIndex:(NSUInteger)index animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
