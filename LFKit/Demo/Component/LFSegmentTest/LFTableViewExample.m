//
//  LFTableViewExample.m
//  LFKit
//
//  Created by 张林峰 on 2019/9/2.
//  Copyright © 2019 张林峰. All rights reserved.
//

#import "LFTableViewExample.h"

@interface LFTableViewExample () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation LFTableViewExample

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    self.dataSource = self;
    self.delegate = self;
    [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"myCell"];
    return self;
}

- (void)setArrayData:(NSMutableArray *)arrayData {
    _arrayData = arrayData;
    [self reloadData];
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
    NSString *title = _arrayData[indexPath.row];
    cell.textLabel.text = title;
    return cell;
}

@end
