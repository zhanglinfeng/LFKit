//
//  LFCycleScrollView.m
//  APPBaseSDK
//
//  Created by 张林峰 on 16/10/29.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import "LFCycleScrollView.h"
#import <YYWebImage/UIImageView+YYWebImage.h>

@interface LFCycleScrollView ()<UIScrollViewDelegate>
{
    NSInteger _totalPages;
    NSMutableArray *_curViews;
}
@property (nonatomic, strong) NSTimer *animationTimer;
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, readonly, strong) UIScrollView *scrollView;
@property (nonatomic, readonly, strong) UIPageControl *pageControl;

@end

@implementation LFCycleScrollView

- (id)initWithFrame:(CGRect)frame
 showPageController:(BOOL)showPageController
       IsAutoScroll:(BOOL)isAutoScroll
           Duration:(NSTimeInterval)duration
         withImages:(NSArray *)arrayImage {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [_scrollView setAutoresizesSubviews:YES];
        
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollsToTop = NO;
        [self addSubview:_scrollView];
        
        self.animationDuration = duration;
        if (arrayImage.count > 0) {
            self.arrayImage = arrayImage;
        }
        if (showPageController) {
            CGRect rect = self.bounds;
            rect.origin.y = rect.size.height - 30;
            rect.size.height = 30;
            _pageControl = [[UIPageControl alloc] initWithFrame:rect];
            _pageControl.userInteractionEnabled = NO;
            
            [_pageControl setCurrentPageIndicatorTintColor:[UIColor orangeColor]];
            [_pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
            [self addSubview:_pageControl];
        }
        _curPage = 0;
        
        if (isAutoScroll) {
            self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:self.animationDuration
                                                                   target:self
                                                                 selector:@selector(animationTimerDidFired:)
                                                                 userInfo:nil
                                                                  repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.animationTimer forMode:NSRunLoopCommonModes];
            
            if ([self.animationTimer isValid]) {
                [self.animationTimer setFireDate:[NSDate distantFuture]];//暂停， distantFuture（不可达到的未来的某个时间点）
                [self.animationTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.animationDuration]];//在某个时间点继续
            }
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withImages:(NSArray *)arrayImage {
    return [self initWithFrame:frame showPageController:YES IsAutoScroll:YES Duration:3 withImages:arrayImage];
}

- (void)dealloc {
    self.delegate = nil;
    self.scrollView.delegate = nil;
    [self stopTimer];
}

- (void)animationTimerDidFired:(NSTimer *)timer {
    
    if (_totalPages < 2) {
        return;
    }
    //    NSLog(@"self.scrollView.contentOffset.x=%f",self.scrollView.contentOffset.x);
    //    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame),
    //    self.scrollView.contentOffset.y);
    //通过打印发现self.scrollView.contentOffset.x并不是一直等于scrollView的宽度，会出现半页的情况，而目的就是为了滚动到第三页，所以采用以下2倍的scrollView宽度
    CGPoint newOffset = CGPointMake(2 * CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newOffset animated:YES];
}

//设置PageController点的颜色(非必选，有默认的)
- (void)setPageIndicator:(UIColor *)color highlightColor:(UIColor*)hColor {
    color = color?color:[UIColor lightGrayColor];
    hColor = hColor?hColor:[UIColor orangeColor];
    [_pageControl setCurrentPageIndicatorTintColor:hColor];
    [_pageControl setPageIndicatorTintColor:color];
}


- (void)setDataSource:(id<LFCycleScrollViewDataSource>)dataSource {
    _dataSource = dataSource;
}

- (void)setArrayImage:(NSArray *)arrayImage {
    _arrayImage = arrayImage;
    [self reloadData];
}

- (void)setPlaceholderImage:(UIImage *)placeholderImage {
    _placeholderImage = placeholderImage;
}

- (void)reloadData {
    if (self.arrayImage.count < 1) { //如果外部没有传入arrayImage数组则通过委托从外面获取
        _totalPages = [_dataSource numberOfPagesWithCycleScrollView:self];
    } else { //如果外部传入arrayImage数组
        _totalPages = self.arrayImage.count;
    }
    

    if ([self.animationTimer isValid]) {
        [self.animationTimer setFireDate:[NSDate distantFuture]];//暂停， distantFuture（不可达到的未来的某个时间点）
    }
    
    if(_totalPages > 1){
        if ([self.animationTimer isValid]) {
            [self.animationTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.animationDuration]];//在某个时间点继续
        }
    }
    
    if (_totalPages == 1) {
        _scrollView.scrollEnabled = NO;
        _pageControl.hidden = YES;
    } else {
        _pageControl.hidden = NO;
        _scrollView.scrollEnabled = YES;
    }
    
    if (_curPage >= _totalPages) {
        _curPage = 0;
    }
    _pageControl.numberOfPages = _totalPages;
    if (_curViews.count > 0) {
        //如果有内容，来新数据时延时加载，防止中断上次还没执行完的滚动动画
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadData];
        });
    } else {
        [self loadData];
    }
}

- (void)loadData {
    
    _pageControl.currentPage = _curPage;
    
    //    NSLog(@"当前第%li页",_curPage);
    //从scrollView上移除所有的subview
    NSArray *subViews = [_scrollView subviews];
    if ([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    if (_totalPages < 1) {
        return;
    } else if (_totalPages < 2) {
        [_scrollView setContentSize:CGSizeMake(_scrollView.bounds.size.width, _scrollView.bounds.size.height)];
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    } else {
        [_scrollView setContentSize:CGSizeMake(_scrollView.bounds.size.width * 3, _scrollView.bounds.size.height)];
        [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width, 0) animated:NO];
    }
    
    [self getDisplayImagesWithCurpage:(int) _curPage];
    //    NSAssert(_curViews.count > 0, @"滚动图片数组为空");
    if (_curViews.count > 0) {
        for (int i = 0; i < 3; i++) {
            
            UIView *v = [_curViews objectAtIndex:i];
            if (!self.removeTapEvent) {
                v.userInteractionEnabled = YES;
                UITapGestureRecognizer *singleTap =
                [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
                singleTap.numberOfTapsRequired = 1;
                [v addGestureRecognizer:singleTap];
                
                UITapGestureRecognizer *doubleRecognizer =
                [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
                doubleRecognizer.numberOfTapsRequired = 2;
                [v addGestureRecognizer:doubleRecognizer];
                
                [singleTap requireGestureRecognizerToFail:doubleRecognizer];
            }
            
            v.frame = CGRectOffset(v.bounds, v.bounds.size.width * i, 0);
            [_scrollView addSubview:v];
        }
    }
    
    [self customAutoMask];
}

- (UIView *)pageAtIndex:(NSInteger)index {
    //    UIScrollView *itemScrollView =
    //    [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    //    [itemScrollView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    //    [itemScrollView setBackgroundColor:[UIColor clearColor]];
    //    [itemScrollView setDelegate:self];
    //    [itemScrollView setBounces:NO];
    //    [itemScrollView setMultipleTouchEnabled:YES];
    //    [itemScrollView setMinimumZoomScale:1.0];
    //    [itemScrollView setMaximumZoomScale:8.0];
    //    itemScrollView.scrollsToTop = NO;
    
    UIImageView *imageView =
    [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    imageView.contentMode = self.contentMode;
    if (index < self.arrayImage.count) {
        NSString *urlStr = self.arrayImage[index];
        [imageView yy_setImageWithURL:[NSURL URLWithString:urlStr] placeholder:self.placeholderImage];
        [imageView setBackgroundColor:[UIColor clearColor]];
        [imageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        
    }
    return imageView;
}

- (void)getDisplayImagesWithCurpage:(int)page {
    
    int pre = [self validPageValue:_curPage - 1];
    int last = [self validPageValue:_curPage + 1];
    
    if (!_curViews) {
        _curViews = [[NSMutableArray alloc] init];
    }
    
    [_curViews removeAllObjects];
    
    if (self.arrayImage.count > 0) { //如果从外部传arrayImage数组，则通过该数组生成要显示的view，用于显示滚动图片
        [_curViews addObject:[self pageAtIndex:pre]];
        [_curViews addObject:[self pageAtIndex:page]];
        [_curViews addObject:[self pageAtIndex:last]];
    } else if (_dataSource) { //如果外部没有传arrayImage数组，则通过委托从外部生成要显示的view数据源，用于需要自定义要滚动显示的内容
        [_curViews addObject:[_dataSource cycleScrollView:self pageAtIndex:pre]];
        [_curViews addObject:[_dataSource cycleScrollView:self pageAtIndex:page]];
        [_curViews addObject:[_dataSource cycleScrollView:self pageAtIndex:last]];
    }
    
    // 当前ScrollView滚动到第几页
    if ([_delegate respondsToSelector:@selector(cycleScrollView:currentScrollPage:)]) {
        [_delegate cycleScrollView:self currentScrollPage:page];
    }
}

- (int)validPageValue:(NSInteger)value {
    if (_totalPages < 1) {
        return 0;
    }
    if (value < 0) value = _totalPages - 1;
    if (value > _totalPages - 1) value = 0;
    
    return (int) value;
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    if ([_delegate respondsToSelector:@selector(cycleScrollView:didClickPageAtIndex:)]) {
        [_delegate cycleScrollView:self didClickPageAtIndex:_curPage];
    }
}

//暂时没该功能
- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index {
    if (index == _curPage) {
        [_curViews replaceObjectAtIndex:1 withObject:view];
        for (int i = 0; i < 3; i++) {
            UIView *v = [_curViews objectAtIndex:i];
            v.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap =
            [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [v addGestureRecognizer:singleTap];
            
            UITapGestureRecognizer *doubleRecognizer =
            [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
            doubleRecognizer.numberOfTapsRequired = 2;
            [v addGestureRecognizer:doubleRecognizer];
            
            [singleTap requireGestureRecognizerToFail:doubleRecognizer];
            
            v.frame = CGRectOffset(v.bounds, v.bounds.size.width * i, 0);
            [_scrollView addSubview:v];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    if (_totalPages < 1) {
        return;
    }
    if (self == nil) {
        NSLog(@"自己呗释放了");
    } else {
        int x = aScrollView.contentOffset.x;
        
        //往下翻一张
        if (x >= (2 * self.frame.size.width)) {
            _curPage = [self validPageValue:_curPage + 1];
            [self loadData];
        }
        
        //往上翻
        if (x <= 0) {
            _curPage = [self validPageValue:_curPage - 1];
            [self loadData];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.animationTimer isValid]) {
        [self.animationTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.animationDuration]];//在某个时间点继续
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    //    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];
    if ([_delegate respondsToSelector:@selector(cycleScrollView:didScrollAtIndex:)]) {
        [_delegate cycleScrollView:self didScrollAtIndex:_curPage];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.animationTimer isValid]) {
        [self.animationTimer setFireDate:[NSDate distantFuture]];//暂停， distantFuture（不可达到的未来的某个时间点）
    }
    if ([_delegate respondsToSelector:@selector(cycleScrollView:beginScrollAtIndex:)]) {
        [_delegate cycleScrollView:self beginScrollAtIndex:_curPage];
    }
}

- (void)customAutoMask {
    if (_curViews.count) {
        UIView *perView = [_curViews objectAtIndex:0];
        [perView setAutoresizingMask:UIViewAutoresizingNone];
        [perView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin |
         UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth |
         UIViewAutoresizingFlexibleHeight];
        
        UIView *curView = [_curViews objectAtIndex:1];
        [curView setAutoresizingMask:UIViewAutoresizingNone];
        [curView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleBottomMargin |
         UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        
        UIView *nexView = [_curViews objectAtIndex:2];
        [nexView setAutoresizingMask:UIViewAutoresizingNone];
        [nexView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin |
         UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth |
         UIViewAutoresizingFlexibleHeight];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.scrollView setFrame:self.bounds];
    
    CGRect rectPage = self.bounds;
    rectPage.origin.y = rectPage.size.height - 30;
    rectPage.size.height = 30;
    _pageControl.frame = rectPage;
    
    [[self.scrollView subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *subView = obj;
        CGRect frame = self.scrollView.bounds;
        frame.origin = CGPointZero;
        CGRect rect = CGRectOffset(frame, self.scrollView.frame.size.width * idx, 0);
        [subView setFrame:rect];
    }];
    _scrollView.contentOffset = CGPointMake(self.scrollView.bounds.size.width, 0);
    [_scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width, 0)];
}

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if ([_delegate respondsToSelector:@selector(cycleScrollView:doubleClickAtIndex:)]) {
        [self.delegate cycleScrollView:self doubleClickAtIndex:_curPage];
    }
}

- (UIView *)getCurrentShowView {
    if (_curViews.count == 3) {
        return [_curViews objectAtIndex:1];
    } else {
        return nil;
    }
}

//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self.animationTimer invalidate];
        self.animationTimer = nil;
    }
}

- (void)stopTimer {
    if (self.animationTimer) {
        [self.animationTimer invalidate];
        self.animationTimer = nil;
    }
}

- (void)startTimer {
    if (_totalPages > 1) {
        [self stopTimer];
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:self.animationDuration
                                                               target:self
                                                             selector:@selector(animationTimerDidFired:)
                                                             userInfo:nil
                                                              repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.animationTimer forMode:NSRunLoopCommonModes];
        if ([self.animationTimer isValid]) {
            [self.animationTimer setFireDate:[NSDate distantFuture]];//暂停， distantFuture（不可达到的未来的某个时间点）
            [self.animationTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.animationDuration]];//在某个时间点继续
        }
    }
}

@end
