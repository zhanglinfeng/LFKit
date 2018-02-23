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
#import "CocoaLumberjack.h"

extern DDLogLevel ddLogLevel;

@interface LFLogListController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *allLogFiles;
@property (nonatomic, strong) NSArray *logPaths;
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
    
    self.allLogFiles = [[NSMutableArray alloc] init];;
    self.logPaths = [LFLogManager shareInstance].dicFileLogger.allKeys;
    for (NSString *path in self.logPaths) {
        NSArray *strArray = [path componentsSeparatedByString:@"/"];
        NSString *title = @"日志列表";
        if (strArray.count > 0) {
            title = [strArray lastObject];
        }
        title = [NSString stringWithFormat:@"自定义日志%@",title];
        NSArray *arrayFile = [[LFLogManager shareInstance] getLogFilesWithPath:path];
        if (arrayFile.count > 0) {
            NSDictionary *dic = @{@"title":title,@"data":arrayFile};
            [self.allLogFiles addObject:dic];
        }
    }
    
    NSArray *all = [[LFLogManager shareInstance] getAllLogFiles];
    if (all.count > 0) {
        NSDictionary *dicAll = @{@"title":@"所有日志",@"data":all};
        [self.allLogFiles addObject:dicAll];
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section < self.allLogFiles.count) {
        return 40;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.allLogFiles.count + 2 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < self.allLogFiles.count) {
        NSDictionary *dic = self.allLogFiles[section];
        NSArray * arrayfile = dic[@"data"];
        return arrayfile.count;
    }
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 30)];
    if (section < self.allLogFiles.count) {
        NSDictionary *dic = self.allLogFiles[section];
        NSString *title = dic[@"title"];

        UILabel *myLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, [[UIScreen mainScreen] bounds].size.width, 30)];
        myLabel.text = title;
        [headView addSubview:myLabel];
    }
    
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    if (indexPath.section < self.allLogFiles.count) {
        NSDictionary *dic = self.allLogFiles[indexPath.section];
        NSArray *arrayFile = dic[@"data"];
        DDLogFileInfo *logFileInfo = (DDLogFileInfo *)arrayFile[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [self.dateFormatter stringFromDate:logFileInfo.creationDate];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    } else if (indexPath.section == self.allLogFiles.count) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = @"清理所有日志";
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    if (indexPath.section < self.allLogFiles.count) {
        NSDictionary *dic = self.allLogFiles[indexPath.section];
        NSArray *arrayFile = dic[@"data"];
        DDLogFileInfo *logFileInfo = (DDLogFileInfo *)arrayFile[indexPath.row];

        NSData *logData = [NSData dataWithContentsOfFile:logFileInfo.filePath];
        NSString *logText = [[NSString alloc] initWithData:logData encoding:NSUTF8StringEncoding];
        LFLogDetailController *vc = [[LFLogDetailController alloc] init];
        vc.logText = logText;
        vc.logDate = [self.dateFormatter stringFromDate:logFileInfo.creationDate];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (indexPath.section == self.allLogFiles.count) {
        
        for (NSDictionary *dic in self.allLogFiles) {
            NSArray *arrayFile = dic[@"data"];
            for (DDLogFileInfo *logFileInfo in arrayFile) {
                //除了当前 其它进行清除
                //            if (logFileInfo.isArchived) {
                [[NSFileManager defaultManager] removeItemAtPath:logFileInfo.filePath error:nil];
                //            }
            }
        }
        
        [self loadLogFiles];
        [self.tableView reloadData];
    }  else if (indexPath.section == self.allLogFiles.count + 1) {
        LFSelectLogLevelVC *vc = [[LFSelectLogLevelVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
    
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

//点击删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    

    NSDictionary *dic = self.allLogFiles[indexPath.section];
    NSArray *arrayFile = dic[@"data"];
    DDLogFileInfo *logFileInfo = arrayFile[indexPath.row];
    [[NSFileManager defaultManager] removeItemAtPath:logFileInfo.filePath error:nil];
    
    //注意：一定是先更新数据，再执行删除的动画或者其他操作，否则会出现崩溃
    [self loadLogFiles];

    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationTop];
    
}



@end
