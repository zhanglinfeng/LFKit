//
//  LFSelectLogLevelVC.m
//  BaseAPP
//
//  Created by 张林峰 on 2018/2/2.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import "LFSelectLogLevelVC.h"
#import "LFLogManager.h"

extern DDLogLevel ddLogLevel;

@interface LFSelectLogLevelVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *arrayData;

@end

@implementation LFSelectLogLevelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayData = @[@{@"name":@"DDLogLevelOff",@"value":@(DDLogLevelOff)},
  @{@"name":@"DDLogLevelError",@"value":@(DDLogLevelError)},
  @{@"name":@"DDLogLevelWarning",@"value":@(DDLogLevelWarning)},
  @{@"name":@"DDLogLevelInfo",@"value":@(DDLogLevelInfo)},
  @{@"name":@"DDLogLevelDebug",@"value":@(DDLogLevelDebug)},
  @{@"name":@"DDLogLevelVerbose",@"value":@(DDLogLevelVerbose)},
  @{@"name":@"DDLogLevelAll",@"value":@(DDLogLevelAll)}];
    [self initUI];
}

- (void)initUI {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"mycell"];
    [self.view addSubview:_tableView];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    //    NSLog(@"大视图3%@",self.view);
    if (@available(iOS 11.0, *)) {
        self.tableView.frame = CGRectMake(0, self.view.safeAreaInsets.top, self.view.frame.size.width, self.view.frame.size.height - self.view.safeAreaInsets.top);
    } else {
        self.tableView.frame = self.view.bounds;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    NSDictionary *dic = self.arrayData[indexPath.row];
    cell.textLabel.text = dic[@"name"];
    
    NSInteger level = ((NSNumber *)dic[@"value"]).integerValue;
    if (level == ddLogLevel) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.arrayData[indexPath.row];
    NSInteger level = ((NSNumber *)dic[@"value"]).integerValue;
    [[LFLogManager shareInstance] setLogLevel:level];
    [tableView reloadData];
}

@end
