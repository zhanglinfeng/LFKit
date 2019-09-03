//
//  LFSegmentTestVC.m
//  LFKit
//
//  Created by 张林峰 on 2018/1/21.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import "LFSegmentTestVC.h"
#import "LFSegmentView.h"
#import "LFNestedPageScroll.h"
#import "LFTableViewExample.h"

@interface LFSegmentTestVC ()

@property (nonatomic, strong) LFSegmentView *segmentView;
@property (nonatomic, strong) LFNestedPageScroll *nestedPageScroll;

@end

@implementation LFSegmentTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *items = @[@"热门",@"推荐",@"精品系列",@"搞笑",@"娱乐",@"问答",@"财经",@"科技",@"教育",@"动漫"];
    
    self.segmentView = [[LFSegmentView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44) titles:items];
    [self.view addSubview:self.segmentView];
    
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
    [self.view addSubview:self.nestedPageScroll];
    [self.nestedPageScroll setSelectedAtIndex:0 animated:NO];
    NSLog(@"大视图1%@",self.view);
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (@available(iOS 11.0, *)) {
        self.segmentView.frame = CGRectMake(0, self.view.safeAreaInsets.top, self.view.frame.size.width, 44);
        self.nestedPageScroll.frame = CGRectMake(0, self.view.safeAreaInsets.top + self.segmentView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - (self.view.safeAreaInsets.top + self.segmentView.frame.size.height));
    } else {
        self.segmentView.frame = CGRectMake(0, 64, self.view.frame.size.width, 44);
        self.nestedPageScroll.frame = CGRectMake(0, 64 + self.segmentView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - (64 + self.segmentView.frame.size.height));
    }
}


@end
