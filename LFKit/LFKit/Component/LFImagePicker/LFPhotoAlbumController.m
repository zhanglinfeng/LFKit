//
//  LFPhotoAlbumController.m
//  LFKit
//
//  Created by 张林峰 on 2018/6/4.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import "LFPhotoAlbumController.h"
#import "LFAlbumModel.h"
#import "LFThumbnailViewController.h"
#import "LFPhotoAlbumCell.h"

@interface LFPhotoAlbumController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableList;
@property (nonatomic, strong) NSMutableArray<LFAlbumModel *> *arrayDataSources;

@end

@implementation LFPhotoAlbumController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.arraySelectPhotos) {
        self.arraySelectPhotos = [NSMutableArray array];
    }
    [self initNav];
    [self initTable];
    [self loadAlbums];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableList.frame = self.view.bounds;
}

- (void)dealloc {

}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

#pragma mark - Private Method



- (void)initNav {
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.navigationItem.title = self.dataType == LFPhotoDataTypeVideos ? @"视频" :  @"照片";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(doCancel)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)initTable {
    [self.view addSubview:self.tableList];
}

- (void)loadAlbums {
    self.arrayDataSources = [NSMutableArray array];
    if (self.dataType == LFPhotoDataTypeAll) {
        //相册数据全选
        [self.arrayDataSources addObjectsFromArray:[LFAlbumModel getPhotoAndVideoAlbumList]];
    } else if (self.dataType == LFPhotoDataTypePhotos) {
        //只选照片
        [self.arrayDataSources addObjectsFromArray:[LFAlbumModel getPhotoAlbumList]];
    } else if (self.dataType == LFPhotoDataTypeVideos) {
        //只选视频
        [self.arrayDataSources addObjectsFromArray:[LFAlbumModel getVideoAlbumList]];
    }
}

- (void)pushToAllPhoto:(LFAlbumModel *)album {
    __weak typeof(self) weakSelf = self;
    LFThumbnailViewController *tvc = [[LFThumbnailViewController alloc] init];
    tvc.title = album.title;
    tvc.maxSelectCount = self.maxSelectCount;
    tvc.assetCollection = album.assetCollection;
    tvc.arraySelectPhotos = self.arraySelectPhotos;
    tvc.DoneBlock = ^(BOOL isOriginalPhoto) {
        if (weakSelf.DoneBlock) {
            weakSelf.DoneBlock(weakSelf.arraySelectPhotos, isOriginalPhoto);
        }
    };
    tvc.CancelBlock = self.CancelBlock;
    [self.navigationController pushViewController:tvc animated:YES];
}

- (void)doCancel {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayDataSources.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"LFPhotoAlbumCell";
    LFPhotoAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    LFAlbumModel *albumModel= _arrayDataSources[indexPath.row];

    [LFPhotoModel requestImageForAsset:albumModel.headImageAsset size:CGSizeMake(65*3, 65*3) resizeMode:PHImageRequestOptionsResizeModeFast needThumbnails:YES completion:^(UIImage *image, NSDictionary *info) {
        cell.headImageView.image = image;
        if ([NSThread currentThread] != [NSThread mainThread]) {
            NSLog(@"*********不在主线程1*********");
        }
    }];
    cell.labTitle.text = [NSString stringWithFormat:@"%@ (%ld)", albumModel.title,albumModel.count];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    LFAlbumModel *album = self.arrayDataSources[indexPath.row];
    [self pushToAllPhoto:album];
}

#pragma mark - Getter
- (UITableView *)tableList {
    if (!_tableList) {
        _tableList = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableList.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableList.dataSource = self;
        _tableList.delegate = self;
        [_tableList registerClass:[LFPhotoAlbumCell class] forCellReuseIdentifier:@"LFPhotoAlbumCell"];
    }
    return _tableList;
}

@end
