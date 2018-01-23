//
//  LFSegmentScrollView.m
//  LFKit
//
//  Created by 张林峰 on 2018/1/21.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import "LFSegmentScrollView.h"

@interface LFSegmentScrollView ()<UIScrollViewDelegate>

@property (nonatomic,weak) UIViewController *parentViewController;

@end

@implementation LFSegmentScrollView

- (instancetype)initWithFrame:(CGRect)frame controller:(UIViewController *)controller{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.parentViewController = controller;
    self.backgroundColor = [UIColor clearColor];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.bounces = NO;
    self.delegate = self;
    return self;
}

-(void)setSegmentView:(LFSegmentView *)segmentView {
    _segmentView = segmentView;
    __weak typeof(self) weakSelf = self;
    _segmentView.selectedBlock = ^(NSInteger index, UIButton * _Nullable button) {
        [weakSelf moveToViewControllerAtIndex:index];
    };
}

#pragma mark - scrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = round(scrollView.contentOffset.x / self.frame.size.width);
    if (index != self.currentIndex) {
        [self setSelectedAtIndex:index];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    [_segmentView adjustLinePosition:offsetX];
}

#pragma mark - index

- (void)setSelectedAtIndex:(NSUInteger)index {
    [_segmentView setSelectedIndex:index];
    [self scrollViewDidScroll:self];
}

- (void)moveToViewControllerAtIndex:(NSUInteger)index {
    [UIView animateWithDuration:_segmentView.duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setContentOffset:CGPointMake(index * self.frame.size.width, 0)];
    } completion:^(BOOL finished) {
        if (self.selectedBlock) {
            self.selectedBlock(index, _segmentView.selectedButton, self.currentViewController);
        }
    }];
    
    UIViewController *targetViewController = self.viewControllers[index];
    if ([self.parentViewController.childViewControllers containsObject:targetViewController] || !targetViewController) {
        return;
    }
    
    targetViewController.view.frame = CGRectOffset(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height), index * self.frame.size.width, 0);
    
    [self addSubview:targetViewController.view];
    [self.parentViewController addChildViewController:targetViewController];
}



#pragma mark - set

- (void)setViewControllers:(NSArray *)viewControllers {
    _viewControllers = viewControllers;
    self.contentSize = CGSizeMake(viewControllers.count * self.frame.size.width, self.frame.size.height);
}

#pragma mark - get

- (NSUInteger)currentIndex {
    return self.segmentView.currentIndex;
}

- (UIViewController *)currentViewController {
    return self.viewControllers[self.currentIndex];
}



@end
