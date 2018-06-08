//
//  LFThumbnailViewController.m
//  LFKit
//
//  Created by 张林峰 on 2018/6/4.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import "LFThumbnailViewController.h"
#import "LFPhotoModel.h"
#import "LFPhotoCollectionCell.h"
#import "LFAlbumModel.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface LFThumbnailViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray<LFPhotoModel *> *arrayDataSources;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *viewBottomBar;
@property (nonatomic, strong) UIButton *btnOriginal;
@property (nonatomic, strong) UIButton *btnDone;

@end

@implementation LFThumbnailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化导航
    [self initNavigation];
    //初始化列表
    [self initCollectionView];
    //初始化底部条
    [self initBottomBar];
    //初始化数据
    [self loadData];
    
    [self resetBottomBtnsStatus];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //update selected data
    [self.collectionView reloadData];
    [self resetBottomBtnsStatus];
}

- (void)dealloc {

}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    self.collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44);
//    self.viewBottomBar.frame = CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44);
}

#pragma mark - 初始化
//初始化导航
- (void)initNavigation {

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(doCancel)];
    self.navigationItem.rightBarButtonItem = rightItem;
    UIButton *btnLeft = self.navigationItem.leftBarButtonItem.customView;
    [btnLeft addTarget:self action:@selector(back_Click) forControlEvents:UIControlEventTouchUpInside];
}

//初始化列表
- (void)initCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((CGRectGetWidth(self.view.bounds)-9)/4, (CGRectGetWidth(self.view.bounds)-9)/4);
    layout.minimumInteritemSpacing = 1.5;
    layout.minimumLineSpacing = 1.5;
    layout.sectionInset = UIEdgeInsetsMake(3, 0, 3, 0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44) collectionViewLayout:layout];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.collectionView registerClass:[LFPhotoCollectionCell class] forCellWithReuseIdentifier:@"LFPhotoCollectionCell"];
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-44],
                                [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]
                                ]];
}

//初始化底部条
- (void)initBottomBar {
    self.viewBottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44)];
    self.viewBottomBar.backgroundColor = [UIColor whiteColor];
    self.viewBottomBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.viewBottomBar.layer.shadowOffset = CGSizeMake(0, 1);
    [self.view addSubview:self.viewBottomBar];
    self.viewBottomBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.viewBottomBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.viewBottomBar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.viewBottomBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]
                                ]];
    [self.viewBottomBar addConstraint:[NSLayoutConstraint constraintWithItem:self.viewBottomBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44]];
    
    //原图
    self.btnOriginal = [[UIButton alloc] init];
    self.btnOriginal.translatesAutoresizingMaskIntoConstraints = NO;
    self.btnOriginal.backgroundColor = [UIColor clearColor];
    self.btnOriginal.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.btnOriginal setTitle:@"原图" forState:UIControlStateNormal];
    [self.btnOriginal setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.btnOriginal addTarget:self action:@selector(btnPreview_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewBottomBar addSubview:self.btnOriginal];
    [self.viewBottomBar addConstraints:@[
                                         [NSLayoutConstraint constraintWithItem:self.btnOriginal attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.viewBottomBar attribute:NSLayoutAttributeLeft multiplier:1 constant:12],
                                         [NSLayoutConstraint constraintWithItem:self.btnOriginal attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.viewBottomBar attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],
                                         ]];
    [self.btnOriginal addConstraint:[NSLayoutConstraint constraintWithItem:self.btnOriginal attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44]];
    
    //确定按钮
    self.btnDone = [[UIButton alloc] init];
    self.btnDone.translatesAutoresizingMaskIntoConstraints = NO;
    self.btnDone.titleLabel.font = [UIFont systemFontOfSize:16];
    self.btnDone.clipsToBounds = YES;
    self.btnDone.backgroundColor = [UIColor blueColor];
    [self.btnDone setTitle:@"确定" forState:UIControlStateNormal];
    [self.btnDone setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];

    [self.btnDone addTarget:self action:@selector(btnDone_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewBottomBar addSubview:self.btnDone];
    [self.viewBottomBar addConstraints:@[
                                         [NSLayoutConstraint constraintWithItem:self.btnDone attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.viewBottomBar attribute:NSLayoutAttributeRight multiplier:1 constant:-12],
                                         [NSLayoutConstraint constraintWithItem:self.btnDone attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.viewBottomBar attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],
                                         ]];
    [self.btnDone addConstraint:[NSLayoutConstraint constraintWithItem:self.btnDone attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44]];
    
}

//初始化数据
- (void)loadData {
    NSArray *arraySource = self.assetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumVideos ? [LFAlbumModel getVideoAssetsInAssetCollection:self.assetCollection ascending:NO] : [LFAlbumModel getImageAssetsInAssetCollection:self.assetCollection ascending:NO] ;

    NSMutableArray<LFPhotoModel *> *mArraySource = [NSMutableArray array];
    for (PHAsset *asset in arraySource) {
        LFPhotoModel *model = [[LFPhotoModel alloc] init];
        model.asset = asset;
        [mArraySource addObject:model];
    }
    self.arrayDataSources = mArraySource;
    [self.collectionView reloadData];
}

#pragma mark - UIButton Action
- (void)cell_btn_Click:(UIButton *)btn
{
    LFPhotoModel *model = self.arrayDataSources[btn.tag];
    //选择照片

    if (_arraySelectPhotos.count >= self.maxSelectCount
        && btn.selected == NO) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = [NSString stringWithFormat:@"最多只能选%zi张图片",self.maxSelectCount];
        [hud hideAnimated:YES afterDelay:3];
        return;
    }

    if (!btn.selected) {
        //添加图片到选中数组
        [btn.layer addAnimation:[self GetElasticityAnimation] forKey:nil];
        
        if (![LFPhotoModel judgeAssetisInLocalAblum:model.asset]) {
            
        } else {
            
        }
        [self.arraySelectPhotos addObject:model];
    } else {
        for (LFPhotoModel *sModel in _arraySelectPhotos) {
            if ([model.asset.localIdentifier isEqualToString:sModel.asset.localIdentifier]) {
                [self.arraySelectPhotos removeObject:sModel];
                break;
            }
        }
    }

    btn.selected = !btn.selected;
    [self resetBottomBtnsStatus];
}

- (void)btnPreview_Click:(id)sender {
    [self pushShowBigImgVCWithDataArray:self.arraySelectPhotos selectIndex:0];
}

- (void)btnDone_Click:(id)sender
{
    if (self.DoneBlock) {
        self.DoneBlock(self.arraySelectPhotos);
    }
}

- (void)navRightBtn_Click
{
    if (self.CancelBlock) {
        self.CancelBlock();
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private Method
- (void)resetBottomBtnsStatus
{
    if (self.arraySelectPhotos.count > 0) {
        self.btnOriginal.enabled = YES;
        self.btnDone.enabled = YES;
    } else {
        self.btnOriginal.enabled = NO;
        self.btnDone.enabled = NO;
    }

}

//按钮弹性动画
- (CAKeyframeAnimation *)GetElasticityAnimation {
    CAKeyframeAnimation *animate = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animate.duration = 0.3;
    animate.removedOnCompletion = YES;
    animate.fillMode = kCAFillModeForwards;
    
    animate.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)],
                       [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    return animate;
}

- (void)doCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//跳转到大图
- (void)pushShowBigImgVCWithDataArray:(NSMutableArray<LFPhotoModel *> *)dataArray selectIndex:(NSInteger)selectIndex {
//    ELBigImageController *svc = [[ELBigImageController alloc] init];
//    svc.arrayDataSources = dataArray;
//    svc.arraySelectPhotos = self.arraySelectPhotos;
//    svc.selectIndex    = selectIndex;
//    svc.maxSelectCount = _maxSelectCount;
//    svc.isSelectOriginalPhoto = self.isSelectOriginalPhoto;
//    [svc setBackBlock:^(NSArray<ELPhotoModel *> *selectedPhotos) {
//        [self.collectionView reloadData];
//        [self resetBottomBtnsStatus];
//    }];
//    [svc setBtnDoneBlock:^(NSArray<ELPhotoModel *> *selectedPhotos) {
//        [self btnDone_Click:nil];
//    }];
//    [self.navigationController pushViewController:svc animated:YES];
}

- (void)showVideo:(LFPhotoModel *)model {
//    ELBigVideoController *bv = [[ELBigVideoController alloc] init];
//    bv.videoModel = model;
//    [bv setBtnDoneBlock:^(NSArray<ELPhotoModel *> *selectedPhotos) {
//        self.arraySelectPhotos = [NSMutableArray arrayWithArray:selectedPhotos];
//        [self btnDone_Click:nil]; //替换一下选取的数据，再抛出回调
//    }];
//    [self.navigationController pushViewController:bv animated:YES];
}

#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrayDataSources.count;
}

//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellIdentifier = @"LFPhotoCollectionCell";
//    ELPhotoModel *model = self.arrayDataSources[indexPath.row];
//    ELPhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
//    CGSize size = cell.frame.size;
//    size.width *= 2.5;
//    size.height *= 2.5;
//    [[ELPhotoTool shareInstance] requestImageForAsset:model.asset size:size resizeMode:PHImageRequestOptionsResizeModeExact needThumbnails:NO completion:^(UIImage *image, NSDictionary *info) {
//        cell.imageView.image = image;
//    }];
//    //区分照片、视频数据
//    BOOL isVideo = [model isVideo];
//    [cell setIsVideo:isVideo];
//    if (isVideo == NO) { //照片UI
//        cell.btnSelect.selected = NO;
//        for (ELPhotoModel *sModel in self.arraySelectPhotos) {
//            if ([sModel.localIdentifier isEqualToString:model.localIdentifier]) {
//                cell.btnSelect.selected = YES;
//                break;
//            }
//        }
//        cell.btnSelect.tag = indexPath.row;
//        [cell.btnSelect addTarget:self action:@selector(cell_btn_Click:) forControlEvents:UIControlEventTouchUpInside];
//    } else { //视频UI
//        [cell setTime:[model fetchVideoTimeString]];
//    }
//    return cell;
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    ELPhotoModel *model = self.arrayDataSources[indexPath.row];
//    //选择视频
//    if ([model isVideo]) {
//        if (self.arraySelectPhotos.count > 0) {
//            [self el_photo_alertTips:@"选择照片时不能选择视频"];
//            return;
//        }
//        //去视频处理
//        [self showVideo:model];
//        return;
//    }
//    [self pushShowBigImgVCWithDataArray:self.arrayDataSources selectIndex:indexPath.item];
}

@end
