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
#import "LFBigImageBrowser.h"
#import "LFBigVideoController.h"

@interface LFThumbnailViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray<LFPhotoModel *> *arrayDataSources;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *viewBottomBar;
@property (nonatomic, strong) UIButton *btnOriginal;
@property (nonatomic, strong) UIButton *btnDone;
@property (assign, nonatomic) BOOL isHiddenStatusBar;

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

-(BOOL)prefersStatusBarHidden {
    return self.isHiddenStatusBar;
}

- (void)dealloc {

}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    self.collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44);
//    self.viewBottomBar.frame = CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44);
    [self.btnDone sizeToFit];
    CGFloat doneW = 70;
    self.btnDone.frame = CGRectMake(self.view.frame.size.width - doneW - 12, 7, doneW, 30);
}

#pragma mark - 初始化
//初始化导航
- (void)initNavigation {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(doCancel)];
    self.navigationItem.rightBarButtonItem = rightItem;
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
    [self.btnOriginal setImage:[UIImage imageNamed:@"photo_radio_normal"] forState:UIControlStateNormal];
    [self.btnOriginal setImage:[UIImage imageNamed:@"photo_radio_normal"] forState:UIControlStateDisabled];
    [self.btnOriginal setImage:[UIImage imageNamed:@"photo_radio_pressed"] forState:UIControlStateSelected];
    [self.btnOriginal setTitleColor:LFAlbumMainColor forState:UIControlStateNormal];
    [self.btnOriginal setTitleColor:LFAlbumMainColor forState:UIControlStateSelected];
    [self.btnOriginal setTitleColor:LFAlbumDisabledColor forState:UIControlStateDisabled];
    [self.btnOriginal addTarget:self action:@selector(userOriginal:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewBottomBar addSubview:self.btnOriginal];
    [self.viewBottomBar addConstraints:@[
                                         [NSLayoutConstraint constraintWithItem:self.btnOriginal attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.viewBottomBar attribute:NSLayoutAttributeLeft multiplier:1 constant:12],
                                         [NSLayoutConstraint constraintWithItem:self.btnOriginal attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.viewBottomBar attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],
                                         ]];
    [self.btnOriginal addConstraint:[NSLayoutConstraint constraintWithItem:self.btnOriginal attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44]];
    
    //确定按钮
    self.btnDone = [[UIButton alloc] init];
//    self.btnDone.translatesAutoresizingMaskIntoConstraints = NO;
    self.btnDone.titleLabel.font = [UIFont systemFontOfSize:16];
    self.btnDone.clipsToBounds = YES;
    self.btnDone.layer.cornerRadius = 4;
    [self.btnDone setBackgroundImage:[LFAlbumModel imageWithColor:LFAlbumMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [self.btnDone setBackgroundImage:[LFAlbumModel imageWithColor:LFAlbumDisabledColor size:CGSizeMake(1, 1)] forState:UIControlStateDisabled];
    [self.btnDone setTitle:@"确定" forState:UIControlStateNormal];
    [self.btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [self.btnDone addTarget:self action:@selector(btnDone_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewBottomBar addSubview:self.btnDone];
//    [self.viewBottomBar addConstraints:@[
//                                         [NSLayoutConstraint constraintWithItem:self.btnDone attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.viewBottomBar attribute:NSLayoutAttributeRight multiplier:1 constant:-12],
//                                         [NSLayoutConstraint constraintWithItem:self.btnDone attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.viewBottomBar attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],
//                                         ]];
//    [self.btnDone addConstraint:[NSLayoutConstraint constraintWithItem:self.btnDone attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30]];
    
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
        hud.label.text = [NSString stringWithFormat:@"最多只能选%li张图片",(long)self.maxSelectCount];
        [hud hideAnimated:YES afterDelay:3];
        return;
    }

    if (!btn.selected) {
        [btn.layer addAnimation:[self GetElasticityAnimation] forKey:nil];
        
        if (![LFPhotoModel judgeAssetisInLocalAblum:model.asset]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.label.text = @"正在从iCloud中下载照片";
            [LFPhotoModel requestImageForAsset:model.asset compressionQuality:0.5 resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                    model.image = image;
                    model.isSelected = YES;
                    [self.arraySelectPhotos addObject:model];
                    [self resetBottomBtnsStatus];
                });
                
            }];
        } else {
            model.isSelected = YES;
            [self.arraySelectPhotos addObject:model];
        }
        
    } else {
        for (LFPhotoModel *sModel in _arraySelectPhotos) {
            if ([model.asset.localIdentifier isEqualToString:sModel.asset.localIdentifier]) {
                model.isSelected = NO;
                [self.arraySelectPhotos removeObject:sModel];
                break;
            }
        }
    }

    btn.selected = !btn.selected;
    [self resetBottomBtnsStatus];
}

- (void)userOriginal:(UIButton *)button {
    if (self.arraySelectPhotos.count < 1) {
        return;
    }
    button.selected = !button.selected;
    self.isSelectOriginalPhoto = button.selected;
    
    [LFPhotoModel getPhotosBytesWithArray:self.arraySelectPhotos completion:^(NSString *photosBytes) {
        [button setTitle:[NSString stringWithFormat:@"原图(%@)", photosBytes] forState:UIControlStateSelected];
        if ([NSThread currentThread] != [NSThread mainThread]) {
            NSLog(@"*********不在主线程4*********");
        }
    }];
}

- (void)btnDone_Click:(id)sender
{
    if (self.DoneBlock) {
        self.DoneBlock(self.isSelectOriginalPhoto);
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
    [self.btnDone setTitle:[NSString stringWithFormat:@"确定(%@)",@(self.arraySelectPhotos.count)] forState:UIControlStateNormal];
    [self.btnDone setTitle:[NSString stringWithFormat:@"确定(%@)",@(self.arraySelectPhotos.count)] forState:UIControlStateDisabled];
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

- (void)showVideo:(LFPhotoModel *)model {
    LFBigVideoController *bv = [[LFBigVideoController alloc] init];
    bv.videoModel = model;
    bv.selectVideoBlock = ^(LFPhotoModel *video) {
        [self.arraySelectPhotos addObject:video];
        if (self.DoneBlock) {
            self.DoneBlock(self.isSelectOriginalPhoto);
        }
    };
    [self.navigationController pushViewController:bv animated:YES];
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LFPhotoCollectionCell";
    LFPhotoModel *model = self.arrayDataSources[indexPath.row];
    LFPhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    CGSize size = cell.frame.size;
    size.width *= 2.5;
    size.height *= 2.5;
    [LFPhotoModel requestImageForAsset:model.asset size:size resizeMode:PHImageRequestOptionsResizeModeExact needThumbnails:YES completion:^(UIImage *image, NSDictionary *info) {
        cell.imageView.image = image;
        if ([NSThread currentThread] != [NSThread mainThread]) {
            NSLog(@"*********不在主线程2*********");
        }
    }];
    //区分照片、视频数据
    BOOL isVideo = [model isVideo];
    [cell setIsVideo:isVideo];
    cell.coverView.hidden = YES;
    if (isVideo == NO) { //照片UI
        cell.btnSelect.selected = model.isSelected;
        cell.btnSelect.tag = indexPath.row;
        [cell.btnSelect addTarget:self action:@selector(cell_btn_Click:) forControlEvents:UIControlEventTouchUpInside];
    } else { //视频UI
        [cell setTime:[model fetchVideoTimeString]];
        cell.coverView.hidden = self.arraySelectPhotos.count < 1;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LFPhotoModel *model = self.arrayDataSources[indexPath.row];
    //选择视频
    if ([model isVideo] && self.arraySelectPhotos.count < 1) {
        [self showVideo:model];
    } else {
        self.isHiddenStatusBar = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        
        LFBigImageBrowser *browser = [[LFBigImageBrowser alloc] init];
        browser.ctr = self;
        browser.arrayData = self.arrayDataSources;
        browser.arraySelectPhotos = self.arraySelectPhotos;
        browser.maxSelectCount = self.maxSelectCount;
        browser.currentIndex = indexPath.item;
        browser.isSelectOriginalPhoto = self.isSelectOriginalPhoto;
        browser.isShowTopBar = YES;
        browser.DoneBlock = self.DoneBlock;
        [browser show];
        
        __weak LFBigImageBrowser *b_browser = browser;
        __weak typeof(self) weakSelf = self;
        browser.didDismiss = ^{
            weakSelf.isSelectOriginalPhoto = b_browser.isSelectOriginalPhoto;
            [weakSelf.collectionView reloadData];
            [weakSelf resetBottomBtnsStatus];
            weakSelf.isHiddenStatusBar = NO;
            [weakSelf setNeedsStatusBarAppearanceUpdate];
        };
        browser.DoneBlock = self.DoneBlock;
    }
}

@end
