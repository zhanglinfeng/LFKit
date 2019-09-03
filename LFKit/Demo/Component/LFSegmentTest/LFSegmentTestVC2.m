//
//  LFSegmentTestVC2.m
//  LFKit
//
//  Created by 张林峰 on 2019/9/2.
//  Copyright © 2019 张林峰. All rights reserved.
//

#import "LFSegmentTestVC2.h"
#import "LFSegmentView.h"
#import "LFNestedPageScroll.h"
#import "LFTableViewExample.h"
#import "LFNestedScrollContainer.h"

@interface LFSegmentTestVC2 ()

@property (nonatomic, strong) LFNestedScrollContainer *container;
@property (nonatomic, strong) LFSegmentView *segmentView;
@property (nonatomic, strong) LFNestedPageScroll *nestedPageScroll;

@end

@implementation LFSegmentTestVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    header.backgroundColor = [UIColor redColor];
    
    NSArray *items = @[@"热门",@"推荐",@"精品系列",@"搞笑",@"娱乐",@"问答",@"财经",@"科技",@"教育",@"动漫"];
    
    self.segmentView = [[LFSegmentView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 44) titles:items];
    
    NSMutableArray *tables = [[NSMutableArray alloc] init];
    for (NSString *s in items) {
        NSMutableArray *arrayData = [NSMutableArray new];
        for (NSInteger i = 0; i < 50; i ++) {
            NSString *title = [NSString stringWithFormat:@"%@_%@",s,@(i)];
            [arrayData addObject:title];
        }
        
        LFTableViewExample *tableView = [[LFTableViewExample alloc] init];
        tableView.arrayData = arrayData;
        [tables addObject:tableView];
    }
    
    self.nestedPageScroll = [[LFNestedPageScroll alloc] initWithFrame:CGRectMake(0, 64+44, self.view.frame.size.width, self.view.frame.size.height - 44 - 64)];
    self.nestedPageScroll.tableViews = tables;
    self.nestedPageScroll.segmentView = self.segmentView;
    [self.nestedPageScroll setSelectedAtIndex:0 animated:NO];

    self.container = [[LFNestedScrollContainer alloc] init];
    [self.container setupHeader:header];
    [self.container setupSegment:self.segmentView];
    [self.container setupPageScroll:self.nestedPageScroll];
    
    [self.view addSubview:self.container];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (@available(iOS 11.0, *)) {
        self.container.frame = CGRectMake(0, self.view.safeAreaInsets.top, self.view.frame.size.width, self.view.frame.size.height - self.view.safeAreaInsets.top);
        
    } else {
        self.container.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    }
}


@end
