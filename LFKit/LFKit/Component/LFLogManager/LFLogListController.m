//
//  LFLogListController.m
//  BaseAPP
//
//  Created by 张林峰 on 2017/11/1.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import "LFLogListController.h"
#import "LFLogDetailController.h"
#import "LFLogManager.h"
#import "LFSelectLogLevelVC.h"

extern DDLogLevel ddLogLevel;

@interface LFLogListController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *logFiles;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation LFLogListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"日志列表";
    [self loadLogFiles];
    [self initUI];
}

- (void)initUI {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"mycell"];
    [self.view addSubview:_tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tableView reloadData];
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

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
//    NSLog(@"zlf->安全底部%f顶部%f",self.view.safeAreaInsets.bottom,self.view.safeAreaInsets.top);
//    NSLog(@"大视图2%@",self.view);
}

//读取日志的文件个数
- (void)loadLogFiles {
    self.logFiles = [LFLogManager shareInstance].fileLogger.logFileManager.sortedLogFileInfos;
}

//时间格式
- (NSDateFormatter *)dateFormatter
{
    if (_dateFormatter) {
        return _dateFormatter;
    }
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return _dateFormatter;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 40;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.logFiles.count;
    }
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 30)];
    if (section==0) {
        UILabel *myLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, [[UIScreen mainScreen] bounds].size.width, 30)];
        myLabel.text=@"日记列表";
        [headView addSubview:myLabel];
    }
    
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    if (indexPath.section == 0) {
        DDLogFileInfo *logFileInfo = (DDLogFileInfo *)self.logFiles[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [self.dateFormatter stringFromDate:logFileInfo.creationDate];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    } else if (indexPath.section == 1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = @"清理旧的记录";
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        if (ddLogLevel == DDLogLevelAll) {
            cell.textLabel.text = [NSString stringWithFormat:@"打印级别:DDLogLevelAll"];
        } else if (ddLogLevel == DDLogLevelVerbose) {
            cell.textLabel.text = [NSString stringWithFormat:@"打印级别:DDLogLevelVerbose"];
        } else if (ddLogLevel == DDLogLevelDebug) {
            cell.textLabel.text = [NSString stringWithFormat:@"打印级别:DDLogLevelDebug"];
        } else if (ddLogLevel == DDLogLevelInfo) {
            cell.textLabel.text = [NSString stringWithFormat:@"打印级别:DDLogLevelInfo"];
        } else if (ddLogLevel == DDLogLevelWarning) {
            cell.textLabel.text = [NSString stringWithFormat:@"打印级别:DDLogLevelWarning"];
        } else if (ddLogLevel == DDLogLevelError) {
            cell.textLabel.text = [NSString stringWithFormat:@"打印级别:DDLogLevelError"];
        } else if (ddLogLevel == DDLogLevelOff) {
            cell.textLabel.text = [NSString stringWithFormat:@"打印级别:DDLogLevelOff"];
        } else {
            cell.textLabel.text = [NSString stringWithFormat:@"打印级别:"];
        }
        
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        DDLogFileInfo *logFileInfo = (DDLogFileInfo *)self.logFiles[indexPath.row];
        NSData *logData = [NSData dataWithContentsOfFile:logFileInfo.filePath];
        NSString *logText = [[NSString alloc] initWithData:logData encoding:NSUTF8StringEncoding];
        LFLogDetailController *vc = [[LFLogDetailController alloc] init];
        vc.logText = logText;
        vc.logDate = [self.dateFormatter stringFromDate:logFileInfo.creationDate];
        [self.navigationController pushViewController:vc animated:YES];
        
    }  else if (indexPath.section == 1) {
        for (DDLogFileInfo *logFileInfo in self.logFiles) {
            //除了当前 其它进行清除
            if (logFileInfo.isArchived) {
                [[NSFileManager defaultManager] removeItemAtPath:logFileInfo.filePath error:nil];
            }
        }
        
        [self loadLogFiles];
        [self.tableView reloadData];
    }  else if (indexPath.section == 2) {
        LFSelectLogLevelVC *vc = [[LFSelectLogLevelVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
