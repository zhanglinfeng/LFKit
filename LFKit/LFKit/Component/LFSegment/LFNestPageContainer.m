//
//  LFNestPageContainer.m
//  LFKit
//
//  Created by 张林峰 on 2022/9/29.
//

#import "LFNestPageContainer.h"
#import "LFNestPageController.h"
#import "LFSegmentView.h"

@interface LFNestPageContainer ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *headerView; //头部视图
@property (nonatomic, strong) UIScrollView *segmentView; //分段式图
@property(nonatomic,assign) CGFloat lastDy; //上次的偏移
@property(nonatomic,assign) BOOL nextReturn; // 用于防止监听里的改动被监听
@property(nonatomic,assign) BOOL isScrollTable; // 是否滑动列表
@property (nonatomic, strong) LFNestPageController *pageCtrl;//分页控制器
@property(nonatomic,assign) CGFloat headerHeight; // 记下这个高度。因为约束写的header，外部设置了header的frame，高度会变无效
@property(nonatomic,assign) CGFloat segmentHeight; //

@end

@implementation LFNestPageContainer

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.clipsToBounds = YES;
        self.showsVerticalScrollIndicator = NO;
        
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        self.pageScrollEnabled = YES;
        self.scrollsToTop = NO;
    }
    return self;
}

- (void)dealloc {
//    NSLog(@"滑动嵌套大视图释放");
    [self removePageCtrlObserve];
}

- (void)layoutSubviews {
    [super layoutSubviews];
        self.headerView.frame = CGRectMake(0, 0, self.frame.size.width, self.headerHeight);
        self.segmentView.frame = CGRectMake(0, self.headerHeight, self.frame.size.width, self.segmentHeight);
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf updatePageCtrlFrame];
    });
    
    self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height + self.headerView.frame.size.height - self.topOffset);
    
}

#pragma mark - UI

- (void)updateSubViewLayout{
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma makr - Public

- (void)setTopOffset:(CGFloat)topOffset {
    _topOffset = topOffset;
    self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height + self.headerView.frame.size.height - topOffset);
}

// 滚动到tab
-(void)scrollToTab:(BOOL)animated {
    [self setContentOffset:CGPointMake(0, self.headerView.bounds.size.height - self.topOffset) animated:animated];
}

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated {
    [self.pageCtrl scrollToIndex:index animated:animated];
}

//设置头部
- (void)setupHeader:(UIView *)headerView {
    self.headerView = headerView;
    self.headerHeight = self.headerView.frame.size.height;
    [self addSubview:self.headerView];
    [self updateSubViewLayout];
}

//设置segment
- (void)setupSegment:(UIView *)segmentView {
    self.segmentView = segmentView;
    self.segmentHeight = self.segmentView.frame.size.height;
    [self addSubview:self.segmentView];
    [self updateSubViewLayout];
}

/** 设置嵌套的控制器*/
- (void)setupControllers:(NSArray <UIViewController*>*)list currentIndex:(NSInteger)index {
    if (list.count < 1) {
        return;
    }
    if (!self.pageCtrl) {
        self.pageCtrl = [[LFNestPageController alloc] initWithList:list index:index];
        if (![self.vc.childViewControllers containsObject:self.pageCtrl]) {
            [self.vc addChildViewController:self.pageCtrl];
        }
        self.pageCtrl.vc = self.vc;
        self.pageCtrl.canSwipeBack = self.canSwipeBack;
        __weak __typeof__(self) weakSelf = self;
        self.pageCtrl.selectChanged = ^(NSInteger originIndex, NSInteger index) {
            [weakSelf removePageCtrlObserve:originIndex];
            if (weakSelf.changeIndexBlock) {
                weakSelf.changeIndexBlock(index);
            }
            if (weakSelf.segmentView) {
                if ([weakSelf.segmentView isKindOfClass:[LFSegmentView class]]) {
                    [((LFSegmentView *)weakSelf.segmentView) setSelectedIndex:index];
                }
                
            }
        };
        self.pageCtrl.scrollViewDidScroll = ^(UIScrollView *scrollView) {
//                CGFloat offsetX = scrollView.contentOffset.x;
//                offsetX = offsetX - weakSelf.pageCtrl.startOffset;
            CGFloat offsetX = weakSelf.pageCtrl.pageOffset;
            if (weakSelf.segmentView) {
                if ([weakSelf.segmentView isKindOfClass:[LFSegmentView class]]) {
                    [((LFSegmentView *)weakSelf.segmentView) adjustLinePosition:offsetX containerWidth:weakSelf.frame.size.width];
                }
                
            }
        };
        [self setupPageCtrl:self.pageCtrl];
    }else{
        [self setupPageCtrl:self.pageCtrl];
        [self removePageCtrlObserve];
        [self.pageCtrl updateList:list index:index];
    }
    
    self.pageCtrl.scrollEnabled = self.pageScrollEnabled;
}

//设置pageCtrl
- (void)setupPageCtrl:(LFNestPageController *)pageCtrl{
    if (!pageCtrl) return;
    if (!pageCtrl.view.superview) {
        [self addSubview:pageCtrl.view];
    }
    self.pageCtrl = pageCtrl;
    [self updateSubViewLayout];
}
- (void)updatePageCtrlFrame{
    if (!self.pageCtrl) return;
    /** EFWCSegmentCustomComponent组件未创建  或者  EFWCSegmentCustomComponent组件 v-if="false"
     改情况下：self.segmentView.superview == nil，要调整其它视图的frame
     */
    CGSize segmentViewSize = self.segmentView.superview ? self.segmentView.frame.size : CGSizeZero;
    CGFloat y = self.headerView.frame.size.height + segmentViewSize.height;
    CGRect rect = CGRectMake(0, y, self.frame.size.width, self.frame.size.height - segmentViewSize.height - self.topOffset);
    self.pageCtrl.view.frame = rect;
}
- (void)addPageCtrlObserve:(NSInteger)index{
    //处理监听事件
    UIScrollView *scroll = [self.pageCtrl fetchSubCtrlScrollView:index];
    if (!scroll) return;
    if (scroll.lf_isObserver.boolValue) return;
    [scroll addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    scroll.lf_isObserver = @(YES);
}
- (void)removePageCtrlObserve{
    for (NSUInteger i = 0; i < self.pageCtrl.allViewControllers.count; i++) {
        [self removePageCtrlObserve:i];
    }
}
- (void)removePageCtrlObserve:(NSInteger)index{
    @try {
        UIScrollView *scroll = [self.pageCtrl fetchSubCtrlScrollView:index];
        if (!scroll) return;
        if (!scroll.lf_isObserver.boolValue) return;
        [scroll removeObserver:self forKeyPath:@"contentOffset"];
        scroll.lf_isObserver = @(NO);
    }
    @catch (NSException *exception) {
    }
}
//检查手势是否在pageCtrl上
- (BOOL)fetchOtherGesInPageCtrl:(UIGestureRecognizer *)ges{
    UIView *view = ges.view;
    UIView *targetView = self.pageCtrl.view;
    if (!view || !targetView) return NO;
    UIScrollView *scroll = [self.pageCtrl fetchPageCtrlScrollView];
    
    //检查手势是否是pageCtrl自身的scroll手势
    if ([scroll.panGestureRecognizer isEqual:ges]) {
        return NO;
    }
    //检查手势是否是pageCtrl subCtrl的scroll手势
    UIScrollView *subScroll = [self.pageCtrl fetchSubCtrlScrollView:self.pageCtrl.selectedIndex];
    return [subScroll.panGestureRecognizer isEqual:ges];
}


#pragma mark - UIGestureRecognizerDelegate

//当容器里有列表时，让容器也能响应手势
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    NSLog(@"\n === gestureRecognizer====\n%@",gestureRecognizer.view.class);
//    NSLog(@"\n === otherGestureRecognizer====\n%@",otherGestureRecognizer.view.class);
    if (self.pageCtrl) {
        // 防止既横向又纵向滑动
        if ([self fetchOtherGesInPageCtrl:otherGestureRecognizer]) {
            self.isScrollTable = YES;
            return YES;
        }
        self.isScrollTable = NO;
        return NO;
    }
   
    self.isScrollTable = NO;
    return NO;
}

#pragma mark - UIScrollViewDelegate

//滑动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // bounces = yes 时需要下面这几行代码
    BOOL show = false;
    CGFloat _stayHeight = self.headerView.bounds.size.height - self.topOffset;
    CGFloat dh = scrollView.contentOffset.y;
//    NSLog(@"stayHeight=%@,dh=%@",@(_stayHeight), @(dh));
    if (roundf(dh) > roundf(_stayHeight)) {
        
//        scrollView.contentOffset = CGPointMake(0, _stayHeight);
        
        CGRect scrollBounds = scrollView.bounds;
        scrollBounds.origin = CGPointMake(0, _stayHeight);
        scrollView.bounds = scrollBounds;
        show = true;
    }
    
    
    UIScrollView *currenSubScrollView = [self.pageCtrl fetchSubCtrlScrollView:self.pageCtrl.selectedIndex];

    
    /* 当列表和头部都滑到中间，防止2者同时下滑（场景重现：先第一个列表上滑，切到第2个列表，将头部下拉出一半，再切至第一个列表,向下滑）
     */
//    if (currenSubScrollView.contentOffset.y > 0 && (self.contentOffset.y < _stayHeight) && _lastDy > scrollView.contentOffset.y) {
//        scrollView.contentOffset = CGPointMake(0, _lastDy);
//        show = true;
//    }
    
    if (currenSubScrollView.contentOffset.y > 0 && _lastDy > scrollView.contentOffset.y) {
//        NSLog(@"_lastDy1=%@",@(_lastDy));
        
//        scrollView.contentOffset = CGPointMake(0, _lastDy);
        
        CGRect scrollBounds = scrollView.bounds;
        scrollBounds.origin = CGPointMake(0, _lastDy);
        scrollView.bounds = scrollBounds;

        show = true;
    }
    // 下面列表下拉刷新时
    if (currenSubScrollView.contentOffset.y < -1 && _lastDy > scrollView.contentOffset.y && self.isScrollTable) {
//        scrollView.contentOffset = CGPointMake(0, _lastDy);
        
        CGRect scrollBounds = scrollView.bounds;
        scrollBounds.origin = CGPointMake(0, _lastDy);
        scrollView.bounds = scrollBounds;
        show = true;
    }
    
    _lastDy = scrollView.contentOffset.y;
    currenSubScrollView.showsVerticalScrollIndicator = show;
    
    if ([scrollView isEqual:self]) {
        if (self.scrollViewDidScrollBlock) {
            self.scrollViewDidScrollBlock(scrollView);
        }
    }
    
    [self addPageCtrlObserve:self.pageCtrl.selectedIndex];
}

#pragma makr - 监听tableView偏移
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]){
        self.isScrollTable = YES;
        if (_nextReturn) {_nextReturn = false;return;}
        CGFloat new = [change[@"new"] CGPointValue].y;
        CGFloat old = [change[@"old"] CGPointValue].y;
        
        [self handleSubScrollEvent:((UIScrollView *)object) newOffset:new oldOffset:old];
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

//处理滑动
- (void)handleSubScrollEvent:(UIScrollView *)scroll newOffset:(CGFloat)newOffset oldOffset:(CGFloat)oldOffset{
    CGFloat new = newOffset;
    CGFloat old = oldOffset;
    
    if (new == old) {return;}
    CGFloat dh = new - old;
    if (dh < 0) {
        //向下
        if (self.contentOffset.y > 0) {
            if(scroll.contentOffset.y < 0){
                _nextReturn = YES;
                scroll.contentOffset = CGPointMake(0, 0);
            }
        } else {
            if(scroll.contentOffset.y < 0 && !self.needRefreshSubList && self.headerView.bounds.size.height > 1){
                _nextReturn = YES;
                scroll.contentOffset = CGPointMake(0, 0);
            } else {
                self.contentOffset = CGPointMake(0, 0);
            }
            
        }
    }else{
        //向上
        CGFloat _stayHeight = self.headerView.bounds.size.height - self.topOffset;
        if (roundf(self.contentOffset.y) < roundf(_stayHeight)) {
            
            if(scroll.contentOffset.y >= 0) { //排除掉下拉刷新时候松开后的那个向上
                _nextReturn = YES;
                old = old > 0 ? old : 0;
                scroll.contentOffset = CGPointMake(0, old);
            } else {
                self.contentOffset = CGPointMake(0, 0);
            }
        }
    }
    
}

@end
