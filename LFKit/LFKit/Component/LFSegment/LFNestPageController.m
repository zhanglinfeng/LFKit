//
//  LFNestPageController.m
//  LFKit
//
//  Created by 张林峰 on 2022/9/29.
//

#import "LFNestPageController.h"
#import <objc/runtime.h>

@interface LFNestPageController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (nonatomic,strong) NSArray *list;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, retain) NSArray <UIViewController *> *allViewControllers;
@property (nonatomic, strong) UIViewController *selectedViewController;

@property (nonatomic,strong) UIPanGestureRecognizer *popGesture; // 返回手势
@property (nonatomic, weak) UINavigationController *nav; // 导航

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL isTapSwitch; // 是否点击切换的

@end

@implementation LFNestPageController

- (instancetype)initWithList:(NSArray <UIViewController*>*)list index:(NSInteger)index{
    //问题：在iOS10上 UIPageViewControllerOptionInterPageSpacingKey不能设置为0 否则push UIPageViewController时 会出现pageCtrl.scrollView.bounds.origin.y = - 64   导致子视图布局向下偏移
    CGFloat space = 0.001;
    if (@available(iOS 11.0, *)) space = 0;
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey: @(space)}];
    if (self) {
        self.list = list;
        self.selectedIndex = index;
        self.scrollEnabled = YES;
        self.canSwipeBack = YES;
    }
    return self;
}
- (void)dealloc{
//    UINavigationController *nav = self.pageComponent.weexInstance.viewController.navigationController;
    [self.nav.interactivePopGestureRecognizer.view removeGestureRecognizer:_popGesture];
    if ([self.parentViewController.childViewControllers containsObject:self]) {
        [self removeFromParentViewController];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.selectedIndex = NSNotFound;
    self.delegate = self;
    self.dataSource = self;
    
    [self updateList:self.list index:self.selectedIndex];
    
    self.scrollView = [self fetchPageCtrlScrollView];
    self.scrollView.delegate = self;
    [self configGesture];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.scrollView.scrollEnabled = self.scrollEnabled;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.scrollView.scrollEnabled = self.scrollEnabled;

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.scrollView.scrollEnabled = self.scrollEnabled;

}


#pragma mark update

- (void)updateList:(NSArray <UIViewController*>*)list index:(NSInteger)index{
    if (![list isKindOfClass:[NSArray class]] || list.count == 0) return;
    
    if ((index > list.count - 1) || index < 0) {
        index = 0;
    }
    
    
    self.allViewControllers = list;
    self.selectedIndex = index;
    self.selectedViewController = self.allViewControllers[self.selectedIndex];
    __weak typeof(self)weakSelf = self;
    [self setViewControllers:@[self.allViewControllers[self.selectedIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
        if (finished) {
            // 配置点击状态栏回顶部
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf setScrollToTopWithIndex:weakSelf.selectedIndex];
            });
        }
    }];
}


#pragma mark - scroll

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated{
    NSInteger originIndex = self.selectedIndex;
    UIPageViewControllerNavigationDirection direction = (index > self.selectedIndex ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse);
    if (index > -1 && index < self.allViewControllers.count) {
        if (index == self.selectedIndex) {
            return;
        }
        self.selectedIndex = index;
    } else {
        // 超出数组就当0
        self.selectedIndex = 0;
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    
    
    self.selectedViewController = self.allViewControllers[self.selectedIndex];
    self.isTapSwitch = YES;
    [self setViewControllers:@[self.allViewControllers[self.selectedIndex]] direction:direction animated:animated completion:^(BOOL finished) {
        
    }];
    
    // 防止点击切换过程中执行scrollViewDidScroll里面的事件，切换完还要重置为NO
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isTapSwitch = NO;
    });

    if (self.selectChanged) {
        self.selectChanged(originIndex, self.selectedIndex);
    }
    
    
    // 配置点击状态栏回顶部
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setScrollToTopWithIndex:self.selectedIndex];
    });
}

#pragma mark - 配置点击状态栏回顶部

- (void)setScrollToTopWithIndex:(NSInteger)index {
  
    for (NSInteger i = 0; i < self.allViewControllers.count; i++) {
        UIScrollView *sc = [self fetchSubCtrlScrollView:i];
        sc.scrollsToTop = (i == index) ? YES : NO;
    }
}

#pragma mark- fetch

//获取UIPageController的scrollView
- (UIScrollView *)fetchPageCtrlScrollView{
    __block UIScrollView *scrollView = nil;
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIScrollView class]]) {
            scrollView = (UIScrollView *)obj;
            *stop = YES;
        }
    }];
    return scrollView;
}
- (UIScrollView *)fetchSubCtrlScrollView:(NSInteger)index{
    UIView *view = nil;
    UIViewController *ctrl = self.allViewControllers[index];
    if (@available(iOS 9.0, *)) {
        view = ctrl.viewIfLoaded;
    }else{
        view = ctrl.view;
    }
    return [self fetchScrollView:view];
}
- (UIScrollView *)fetchScrollView:(UIView *)startView{
    if (!startView) return nil;
    if ([startView isKindOfClass:[UIScrollView class]]) return (UIScrollView *)startView;
    if (startView.subviews.count == 0) return nil;
    
    UIScrollView *res = nil;
    
    for (UIView *temp in startView.subviews) {
        res = [self fetchScrollView:temp];
        if (res) {
            break;
        }
    }
    return res;
}

#pragma mark - set

- (void)setScrollEnabled:(BOOL)scrollEnabled {
    _scrollEnabled = scrollEnabled;
    self.scrollView.scrollEnabled = scrollEnabled;
}

#pragma mark - scrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    CGFloat offsetX = scrollView.contentOffset.x;
//    NSLog(@"scrollViewDidScroll 偏移=%f",offsetX);
    
//    NSInteger index = round(scrollView.contentOffset.x / self.view.frame.size.width);
    


}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isTapSwitch) {
        return;
    }
    
    // 必须滑动之后再设置弹性，因为设置早了会导致没法滑动
    self.scrollView.bounces = NO;

    CGPoint p = [self.selectedViewController.view.superview convertPoint:self.selectedViewController.view.frame.origin toView:self.view];
    
    self.pageOffset = self.selectedIndex * self.view.frame.size.width - p.x;
    if (self.scrollViewDidScroll) {
        self.scrollViewDidScroll(scrollView, self.pageOffset);
    }
}

#pragma mark UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
}

//此代理只有 用手指滑动时才调用
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{

    //滚动取消 or 结束 重新配置
    //获取当前显示的ctrl
    NSArray *ctrls = pageViewController.viewControllers;
    if (ctrls.count == 0) return;
    UIViewController *currentCtrl = ctrls[0];
    NSUInteger index = [self.allViewControllers indexOfObject:currentCtrl];
    if (index == NSNotFound) return;
    NSInteger originIndex = self.selectedIndex;
    self.selectedIndex = index;
    self.selectedViewController = self.allViewControllers[index];
    
    if (self.selectChanged) {
        self.selectChanged(originIndex, index);
    }

    // 配置点击状态栏回顶部
    [self setScrollToTopWithIndex:self.selectedIndex];
    
    // 滑动到新页面
    if (originIndex != index) {
        if (self.debounce) {
            self.scrollView.userInteractionEnabled = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.debounce.floatValue * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.scrollView.userInteractionEnabled = YES;
            });
        }
    }
}

#pragma mark UIPageViewControllerDataSource

//此代理只有 用手指滑动时才调用
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self.allViewControllers indexOfObject:viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    return [self.allViewControllers objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {

    NSUInteger index = [self.allViewControllers indexOfObject:viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.allViewControllers count]) {
        return nil;
    }
    return [self.allViewControllers objectAtIndex:index];
    
    
}

#pragma mark -- UIGestureRecognizerDelegate


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer{
    self.scrollView.scrollEnabled = self.scrollEnabled;
    return true;
}
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    
    if (gestureRecognizer == self.popGesture) {
        BOOL res = (self.selectedIndex == 0 && translation.x > 0) || (self.selectedIndex == self.allViewControllers.count-1 && translation.x < 0);
//        NSLog(@"是否滚动子scroll=%@",@(res));
        self.scrollView.scrollEnabled = !res;
        
        if (!self.scrollEnabled) {
            self.scrollView.scrollEnabled = NO;
        }
        return res;
    }
    
    return YES;
}

// 配置手势依赖
- (void)configGesture {
    // 不允许侧滑  return
    if (!self.canSwipeBack) {
        return;
    }
    // 配置侧滑
//    __block UIScrollView *scrollView = nil;
//    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj isKindOfClass:[UIScrollView class]])
//        {
//            scrollView = (UIScrollView *)obj;
//        }
//
//    }];
    
    if(self.scrollView) {
//        self.scrollView = scrollView;
        self.scrollView.delegate = self;
        self.nav = self.vc.navigationController;
        if (self.nav) {
            self.popGesture = [[UIPanGestureRecognizer alloc] init];
            self.popGesture.maximumNumberOfTouches = 1;
            self.popGesture.delegate = self;
            [self.scrollView addGestureRecognizer:self.popGesture];
//            [self.nav.interactivePopGestureRecognizer.view addGestureRecognizer:self.popGesture];
            // Forward the gesture events to the private handler of the onboard gesture recognizer.
//            NSArray *internalTargets = [self.nav.interactivePopGestureRecognizer valueForKey:@"targets"];
//            id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
//            SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
//
//            [self.popGesture addTarget:internalTarget action:internalAction];
            [self.popGesture addTarget:self action:@selector(nextTabbarPage:)];

            [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.popGesture];
            
        }
        
    }
}

-(void)nextTabbarPage:(UIPanGestureRecognizer *)panGes {
    CGPoint translationP = [panGes translationInView:self.view];
    CGPoint velocityP = [panGes velocityInView:self.view];
    switch (panGes.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (ABS(translationP.x) <= ABS(translationP.y)) {
                NSLog(@"垂直方向");
            } else if (translationP.x <= 0 && velocityP.x < 0) {
                NSLog(@"向左");
            } else {
                NSLog(@"向右");
            }
        }
            break;
            
        default:
            break;
    }
}

@end

@implementation UIScrollView (LFNestObserve)

- (NSNumber *)lf_isObserver{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setLf_isObserver:(NSNumber *)lf_isObserver{
    objc_setAssociatedObject(self, @selector(lf_isObserver), lf_isObserver, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
