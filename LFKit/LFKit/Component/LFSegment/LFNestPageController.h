//
//  LFNestPageController.h
//  LFKit
//
//  Created by 张林峰 on 2022/9/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**横向滚动的嵌套页面(嵌套的是控制器)*/
@interface LFNestPageController : UIPageViewController

@property (nonatomic,strong) NSNumber *debounce;

@property (nonatomic, weak) UIViewController *vc; // 父控制器(要配置侧滑必传)
@property (nonatomic, assign) BOOL canSwipeBack; // 是否允许侧滑返回
@property (nonatomic, assign, readonly) NSInteger selectedIndex;
@property (nonatomic, retain, readonly) NSArray <UIViewController *> *allViewControllers;
@property (nonatomic, strong, readonly) UIViewController *selectedViewController;
@property (nonatomic, assign) CGFloat pageOffset; // 偏移量。
@property (nonatomic, assign) BOOL scrollEnabled; // 是否支持左右滑动，默认yes

@property (nonatomic,copy) void (^selectChanged) (NSInteger originIndex, NSInteger index);

@property (nonatomic,copy) void (^scrollViewDidScroll) (UIScrollView *scrollView, CGFloat pageOffset);

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;

//获取UIPageController的scrollView
- (UIScrollView *)fetchPageCtrlScrollView;
- (UIScrollView *)fetchSubCtrlScrollView:(NSInteger)index;

- (instancetype)initWithList:(NSArray <UIViewController*>*)list index:(NSInteger)index;
- (void)updateList:(NSArray <UIViewController*>*)list index:(NSInteger)index;

@end

@interface UIScrollView (LFNestObserve)
@property (nonatomic, strong) NSNumber *lf_isObserver;
@end

NS_ASSUME_NONNULL_END
