//
//  ToolListController.m
//  LFKit
//
//  Created by 张林峰 on 2018/2/23.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import "ToolListController.h"
#import "LFLogManager.h"
#import "LFLogListController.h"

@interface ToolListController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *arrayData;

@end

@implementation ToolListController

- (void)viewDidLoad {
    [super viewDidLoad];
    for (NSInteger i = 0; i < 300; i++) {
        DDLogError(@"1");
        DDLogWarn(@"2");
        DDLogInfo(@"3");
        DDLogDebug(@"4");
        DDLogVerbose(@"5");
        LFLog1(@"aaa1");
        LFLog2(@"aaa2");
        XXLog1(@"xxx1");
        XXLog2(@"xxx2");
    }
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"myCell"];
    [self loadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

#pragma mark - 数据

- (void)loadData {
    _arrayData = [[NSArray alloc] init];
    _arrayData = @[
                   @{@"title":@"日志",@"action":^{
                       LFLogListController *vc = [[LFLogListController alloc] init];
                       [self.navigationController pushViewController:vc animated:YES];
                   }}
                   ];
    [_tableView reloadData];
}

#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    NSDictionary *dic = _arrayData[indexPath.row];
    cell.textLabel.text = dic[@"title"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = _arrayData[indexPath.row];
    void(^actionBlock)(void) = dic[@"action"];
    if (actionBlock) {
        actionBlock();
    }
}

@end
