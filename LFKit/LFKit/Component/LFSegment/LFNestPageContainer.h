//
//  LFNestPageContainer.h
//  LFKit
//
//  Created by 张林峰 on 2022/9/29.
//

#import <UIKit/UIKit.h>
#import "LFSegmentView.h"

NS_ASSUME_NONNULL_BEGIN

/**最外层的嵌套滑动容器（嵌套的是控制器）*/
@interface LFNestPageContainer : UIScrollView

// 大容器滑动回调
@property (nonatomic, copy) void(^scrollViewDidScrollBlock)(UIScrollView *scrollView);

// pageController横向滑动的回调
@property (nonatomic, copy) void(^pageControllerDidScrollBlock)(CGFloat pageOffset);

@property (nonatomic, weak) UIViewController *vc; // 父控制器
@property (nonatomic, assign) BOOL canSwipeBack; // 是否允许侧滑返回
@property (nonatomic, assign) CGFloat topOffset; // 悬浮距上距离
@property (nonatomic, assign) BOOL needRefreshSubList; // 有头部时候是否需要子列表刷新功能
@property (nonatomic, assign) BOOL pageScrollEnabled; // 列表容器是否支持滑动，默认yes

/** 放在本容器之外的LFSegmentView，传给本容器可以自动处理联动 */
@property (nonatomic, strong) LFSegmentView *absoluteSegmentView;
@property (nonatomic, copy) void(^ _Nullable changeIndexBlock)(NSInteger index);

/** 设置嵌套的控制器*/
- (void)setupControllers:(NSArray <UIViewController*>*)list currentIndex:(NSInteger)index;

/**以下2个视图都要设置正确的高度再setup*/
- (void)setupHeader:(UIView *)headerView;
/** 吸顶segment，如果是LFSegmentView类型，自动处理联动，如果是自定义的segmentView，则使用者去处理联动 */
- (void)setupSegment:(UIView *)segmentView;

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;

// 滚动到tab
-(void)scrollToTab:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
