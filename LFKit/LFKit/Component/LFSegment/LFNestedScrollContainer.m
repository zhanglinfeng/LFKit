//
//  LFNestedScrollContainer.m
//  LFKit
//
//  Created by 张林峰 on 2019/8/23.
//  Copyright © 2019 张林峰. All rights reserved.
//

#import "LFNestedScrollContainer.h"

@interface LFNestedScrollContainer ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *headerView; //头部视图
@property (nonatomic, strong) UIView *segmentView; //分段式图
@property (nonatomic, strong) LFNestedPageScroll *pageScroll; //列表容器
@property (nonatomic, assign) CGFloat lastDy; //上次的偏移
@property (nonatomic, assign) BOOL nextReturn; // 用于防止监听里的改动被监听
@property (nonatomic, assign) BOOL scrollTag; // yes 表示大容器可以滑
@property (nonatomic, strong) NSArray *tables; // 列表数组

@end

@implementation LFNestedScrollContainer

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.bounces = NO;
        self.clipsToBounds = YES;
        self.showsVerticalScrollIndicator = NO;
        
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return self;
}

- (void)dealloc {
    for (UITableView *table in _tables) {
        [table removeObserver:self forKeyPath:@"contentOffset"];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat tableContainerY = self.segmentView.frame.origin.y + self.segmentView.frame.size.height;
    self.pageScroll.frame = CGRectMake(0, tableContainerY, self.frame.size.width, self.frame.size.height - self.segmentView.frame.size.height);
    self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height + self.headerView.frame.size.height);
    self.clipsToBounds = YES;
}

#pragma mark - UI

//设置头部
- (void)setupHeader:(UIView *)headerView {
    self.headerView = headerView;
    [self addSubview:self.headerView];
}

//设置segment
- (void)setupSegment:(UIView *)segmentView {
    self.segmentView = segmentView;
    [self addSubview:self.segmentView];
}

//设置列表容器
- (void)setupPageScroll:(LFNestedPageScroll *)pageScroll {
    self.pageScroll = pageScroll;
    [self addSubview:self.pageScroll];
    
    __weak typeof(self) weakSelf = self;
    self.pageScroll.didAddTableViewBlock = ^(NSArray *tables) {
        weakSelf.tables = tables;
        for (UITableView *table in tables) {
            [table addObserver:weakSelf forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        }
        
    };
}

#pragma mark - UIGestureRecognizerDelegate

//当容器里有列表时，让容器也能响应手势
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if ([self.tables containsObject:otherGestureRecognizer.view]) {
                NSLog(@"响应%@",otherGestureRecognizer.view);
        return true;
    }
        NSLog(@"不响应%@",otherGestureRecognizer.view);
    return false;
}

#pragma mark - UIScrollViewDelegate

//滑动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self]) {
        if (self.scrollViewDidScrollBlock) {
            self.scrollViewDidScrollBlock(scrollView);
        }
    }
    
    // bounces = yes 时需要下面这几行代码
    BOOL show = false;
    CGFloat _stayHeight = self.headerView.bounds.size.height;
    CGFloat dh = scrollView.contentOffset.y;
    if (dh >= _stayHeight) {
        scrollView.contentOffset = CGPointMake(0, _stayHeight);
        _lastDy = scrollView.contentOffset.y;
        show = true;
    }
    
    UIScrollView *currenSubScrollView = self.tables[self.pageScroll.currentIndex];
    
    /* 当列表和头部都滑到中间，防止2者同时下滑（场景重现：先第一个列表上滑，切到第2个列表，将头部下拉出一半，再切至第一个列表,向下滑）
     */
    if (currenSubScrollView.contentOffset.y > 0 && (self.contentOffset.y < _stayHeight) && !self.scrollTag) {
        scrollView.contentOffset = CGPointMake(0, _lastDy);
        show = true;
    }
    _lastDy = scrollView.contentOffset.y;
    currenSubScrollView.showsVerticalScrollIndicator = show;
}

#pragma makr - 监听tableView偏移
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]){
        if (_nextReturn) {_nextReturn = false;return;}
        CGFloat new = [change[@"new"] CGPointValue].y;
        CGFloat old = [change[@"old"] CGPointValue].y;
        if (new == old) {return;}
        CGFloat dh = new - old;
        if (dh < 0) {
            //向下
            if (self.contentOffset.y > 0) {
                if(((UIScrollView *)object).contentOffset.y < 0){
                    _nextReturn = YES;
                    ((UIScrollView *)object).contentOffset = CGPointMake(0, 0);
                }
            }
            self.scrollTag = NO;
            
        }else{
            //向上
            CGFloat _stayHeight = self.headerView.bounds.size.height;
            if (self.contentOffset.y < _stayHeight) {
                
                self.scrollTag = YES;
                
                if(((UIScrollView *)object).contentOffset.y >= 0) { //排除掉下拉刷新时候
                    _nextReturn = YES;
                    ((UIScrollView *)object).contentOffset = CGPointMake(0, old);
                }
            }else{
                self.scrollTag = NO;
            }
        }
        
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end

