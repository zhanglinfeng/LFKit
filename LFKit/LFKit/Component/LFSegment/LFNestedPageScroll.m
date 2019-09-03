//
//  LFNestedPageScroll.m
//  LFKit
//
//  Created by 张林峰 on 2019/8/23.
//  Copyright © 2019 张林峰. All rights reserved.
//

#import "LFNestedPageScroll.h"

@interface LFNestedPageScroll ()<UIScrollViewDelegate>

@end

@implementation LFNestedPageScroll

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.backgroundColor = [UIColor clearColor];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.bounces = NO;
    self.delegate = self;
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentSize = CGSizeMake(_tableViews.count * self.frame.size.width, self.frame.size.height);
    for (UIView *view in _tableViews) {
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, self.frame.size.width, self.frame.size.height);
    }
}

-(void)setSegmentView:(LFSegmentView *)segmentView {
    _segmentView = segmentView;
    __weak typeof(self) weakSelf = self;
    _segmentView.selectedBlock = ^(NSInteger index, UIButton * _Nullable button) {
        [weakSelf setSelectedAtIndex:index animated:YES];
    };
    
}

#pragma mark - scrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = round(scrollView.contentOffset.x / self.frame.size.width);
    if (index != self.currentIndex) {
        _currentIndex = index;
        if (self.didMoveToIndexBlock) {
            self.didMoveToIndexBlock(index);
        }
        if (_segmentView) {
            [_segmentView setSelectedIndex:_currentIndex];
        }
    }
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    if (_segmentView) {
        [_segmentView adjustLinePosition:offsetX containerWidth:self.frame.size.width];
    }
}

#pragma mark - index

- (void)setSelectedAtIndex:(NSUInteger)index animated:(BOOL)animated {
    _currentIndex = index;
    if (animated) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [weakSelf setContentOffset:CGPointMake(index * weakSelf.frame.size.width, 0)];
        } completion:^(BOOL finished) {
            
        }];
        
    } else {
        [self setContentOffset:CGPointMake(index * self.frame.size.width, 0)];
    }
}

#pragma mark - set

- (void)setTableViews:(NSArray<UITableView *> *)tableViews {
    _tableViews = tableViews;
    
    self.contentSize = CGSizeMake(tableViews.count * self.frame.size.width, self.frame.size.height);
    
    NSMutableArray *rTables = [[NSMutableArray alloc] init]; // 真tableview，而不是外面套了一层view的tableview
    for (NSInteger i = 0; i < _tableViews.count; i++) {
        UIView *table = tableViews[i];
        [self addSubview:table];
        CGRect rect = CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        table.frame = rect;
        if ([table isKindOfClass:[UIScrollView class]]) {
            [rTables addObject:table];
        } else {
            for (UIView *view in table.subviews) {
                if ([view isKindOfClass:[UIScrollView class]]) {
                    [rTables addObject:view];
                }
            }
        }
    }
    
    if (self.didAddTableViewBlock) {
        self.didAddTableViewBlock(rTables);
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.didAddTableViewBlock) {
                self.didAddTableViewBlock(rTables);
            }
        });
    }
}


@end
