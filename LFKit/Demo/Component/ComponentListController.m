//
//  ComponentListController.m
//  LFKit
//
//  Created by 张林峰 on 2017/11/3.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import "ComponentListController.h"
#import "LFCameraViewController.h"
#import "LFBadgeViewController.h"
#import "LFStarsViewVC.h"
#import "LFPopupMenuTestVC.h"
#import "LFSegmentTestVC.h"
#import "LFBubbleViewTestVC.h"
#import "LFPhotoBrowserTest.h"
#import "LFAlertViewTestVC.h"

@interface ComponentListController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *arrayData;

@end

@implementation ComponentListController

- (void)viewDidLoad {
    [super viewDidLoad];
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
                  @{@"title":@"相机",@"action":^{
                        LFCameraViewController *vc = [[LFCameraViewController alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                  }},
                   @{@"title":@"角标",@"action":^{
                       LFBadgeViewController *vc = [[LFBadgeViewController alloc] init];
                       [self.navigationController pushViewController:vc animated:YES];
                   }},
                   @{@"title":@"星级",@"action":^{
                       LFStarsViewVC *vc = [[LFStarsViewVC alloc] init];
                       [self.navigationController pushViewController:vc animated:YES];
                   }},
                  @{@"title":@"带三角选项弹窗",@"action":^{
                      LFPopupMenuTestVC *vc = [[LFPopupMenuTestVC alloc] init];
                      [self.navigationController pushViewController:vc animated:YES];
                  }},
                  @{@"title":@"分页控制器",@"action":^{
                      LFSegmentTestVC *vc = [[LFSegmentTestVC alloc] init];
                      [self.navigationController pushViewController:vc animated:YES];
                  }},
                  @{@"title":@"气泡",@"action":^{
                      LFBubbleViewTestVC *vc = [[LFBubbleViewTestVC alloc] init];
                      [self.navigationController pushViewController:vc animated:YES];
                  }},
                  @{@"title":@"大图浏览",@"action":^{
                      LFPhotoBrowserTest *vc = [[LFPhotoBrowserTest alloc] init];
                      [self.navigationController pushViewController:vc animated:YES];
                  }},
                  @{@"title":@"自定义alert",@"action":^{
                      LFAlertViewTestVC *vc = [[LFAlertViewTestVC alloc] init];
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
