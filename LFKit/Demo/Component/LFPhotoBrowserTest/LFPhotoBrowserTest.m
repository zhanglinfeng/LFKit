//
//  LFPhotoBrowserTest.m
//  LFKit
//
//  Created by 张林峰 on 2018/6/2.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import "LFPhotoBrowserTest.h"
#import "LFAlignCollectionViewFlowLayout.h"
#import "HPImageCell.h"
#import "UIImageView+YYWebImage.h"
#import "LFPhotoModel.h"
#import "LFPhotoBrowser.h"
#import "LFPopupMenu.h"
#import "LFImagePicker.h"

static NSString *kHPImageCell = @"HPImageCell";

@interface LFPhotoBrowserTest () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *arrayImage;
@property (assign, nonatomic) BOOL isHiddenStatusBar;
@property (nonatomic, strong) LFImagePicker *picker;

@end

@implementation LFPhotoBrowserTest

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *itemPick = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStyleDone target:self action:@selector(select_Click)];
    self.navigationItem.rightBarButtonItems = @[itemPick];
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.arrayImage = [[NSMutableArray alloc] init];
    [self loadCollectionView];
    [self loadData];
    self.picker = [[LFImagePicker alloc] init];
}

-(BOOL)prefersStatusBarHidden {
    return self.isHiddenStatusBar;
}

#pragma mark - CollectionView

- (void)loadCollectionView {
    LFAlignCollectionViewFlowLayout *layout = [[LFAlignCollectionViewFlowLayout alloc] initWthType:LFAlignCollectionViewFlowLayoutTypeLeft];
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1; //上下的间距 可以设置0看下效果
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSize = CGSizeMake((self.view.frame.size.width - 2)/3, (self.view.frame.size.width - 2)/3);
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    //    self.collectionView.bounces = YES;
    self.collectionView.alwaysBounceVertical = YES;
    //    self.collectionView.delaysContentTouches = NO;
   
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HPImageCell class]) bundle:nil] forCellWithReuseIdentifier:kHPImageCell];
}

//section 的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrayImage.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HPImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHPImageCell forIndexPath:indexPath];
    LFPhotoModel *photo = self.arrayImage[indexPath.item];
    if (photo.image) {
        cell.ivPicture.image = photo.image;
    } else {
        [cell.ivPicture yy_setImageWithURL:[NSURL URLWithString:photo.smallImageUrl] placeholder:[UIImage imageNamed:@"img_default"]];
    }
    
    return cell;
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //    HPBigImageController *vc = [[HPBigImageController alloc] init];
    //    vc.arrayData = self.arrayImage;
    //    vc.currentIndex = indexPath.item;
    //    [self presentViewController:vc animated:YES completion:nil];

    self.isHiddenStatusBar = YES;
    [self setNeedsStatusBarAppearanceUpdate]; 
    LFPhotoBrowser *browser= [[LFPhotoBrowser alloc] init];
    browser.ctr = self;
    browser.arrayData = self.arrayImage;
    browser.currentIndex = indexPath.item;
    browser.isShowTopBar = YES;
    HPImageCell *cell = (HPImageCell *)[collectionView cellForItemAtIndexPath:indexPath];
    CGRect rect = [self.collectionView convertRect:cell.frame toView:[UIApplication sharedApplication].keyWindow];
//    browser.beginRect = rect;
    browser.beginImage = cell.ivPicture.image;
    [browser show];
    browser.didDismiss = ^{
        self.isHiddenStatusBar = NO;
        [self setNeedsStatusBarAppearanceUpdate];
    };
  
}


- (void)loadData {
    LFPhotoModel *model1 = [[LFPhotoModel alloc] init];
    model1.smallImageUrl = @"http://ww2.sinaimg.cn/thumbnail/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg";
    model1.bigImageUrl = @"http://ww2.sinaimg.cn/bmiddle/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg";
    
    LFPhotoModel *model2 = [[LFPhotoModel alloc] init];
    model2.smallImageUrl = @"http://ww4.sinaimg.cn/thumbnail/9e9cb0c9jw1ep7nlyu8waj20c80kptae.jpg";
    model2.bigImageUrl = @"http://ww4.sinaimg.cn/bmiddle/9e9cb0c9jw1ep7nlyu8waj20c80kptae.jpg";
    
    LFPhotoModel *model3 = [[LFPhotoModel alloc] init];
    model3.smallImageUrl = @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif";
    model3.bigImageUrl = @"http://ww2.sinaimg.cn/bmiddle/642beb18gw1ep3629gfm0g206o050b2a.gif";
    
    LFPhotoModel *model4 = [[LFPhotoModel alloc] init];
    model4.smallImageUrl = @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg";
    model4.bigImageUrl = @"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg";
    
    LFPhotoModel *model5 = [[LFPhotoModel alloc] init];
    model5.smallImageUrl = @"http://ww2.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg";
    model5.bigImageUrl = @"http://ww2.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg";
    
    LFPhotoModel *model6 = [[LFPhotoModel alloc] init];
    model6.smallImageUrl = @"http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg";
    model6.bigImageUrl = @"http://ww4.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg";
    
    LFPhotoModel *model7 = [[LFPhotoModel alloc] init];
    model7.smallImageUrl = @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg";
    model7.bigImageUrl = @"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg";
    
    LFPhotoModel *model8 = [[LFPhotoModel alloc] init];
    model8.smallImageUrl = @"http://ww2.sinaimg.cn/thumbnail/677febf5gw1erma104rhyj20k03dz16y.jpg";
    model8.bigImageUrl = @"http://ww2.sinaimg.cn/bmiddle/677febf5gw1erma104rhyj20k03dz16y.jpg";
    
    LFPhotoModel *model9 = [[LFPhotoModel alloc] init];
    model9.smallImageUrl = @"http://ww4.sinaimg.cn/thumbnail/677febf5gw1erma1g5xd0j20k0esa7wj.jpg";
    model9.bigImageUrl = @"http://ww4.sinaimg.cn/bmiddle/677febf5gw1erma1g5xd0j20k0esa7wj.jpg";
    [self.arrayImage addObjectsFromArray:@[model1,model2,model3,model4,model5,model6,model7,model8,model9]];
    [self.collectionView reloadData];
    
}

- (void)select_Click {
    LFPopupMenuItem *item1 = [LFPopupMenuItem createWithTitle:@"拍照" image:nil];
    LFPopupMenuItem *item2 = [LFPopupMenuItem createWithTitle:@"原生相册" image:nil];
    LFPopupMenuItem *item3 = [LFPopupMenuItem createWithTitle:@"多选相册" image:nil];
    LFPopupMenu *menu = [[LFPopupMenu alloc] init];
    __weak typeof(self) weakSelf = self;
    [menu configWithItems:@[item1,item2,item3]
                   action:^(NSInteger index) {
                       if (index == 0) {
                           [weakSelf.picker pickImageFromCameraWithController:weakSelf allowsEditing:YES resultBlock:^(UIImage *image) {
                               LFPhotoModel *photo = [[LFPhotoModel alloc] init];
                               photo.image = image;
                               [weakSelf.arrayImage addObject:photo];
                               [weakSelf.collectionView reloadData];
                           }];
                       } else if (index == 1) {
                           [weakSelf.picker pickSingleImageWithController:weakSelf allowsEditing:NO resultBlock:^(UIImage *image) {
                               LFPhotoModel *photo = [[LFPhotoModel alloc] init];
                               photo.image = image;
                               [weakSelf.arrayImage addObject:photo];
                               [weakSelf.collectionView reloadData];
                           }];
                       } else {
                           [weakSelf.picker pickMultiImageWithController:weakSelf maxCount:9 dataType:LFPhotoDataTypeAll resultBlock:^(NSMutableArray<LFPhotoModel *> *arraySelectPhotoModel) {
                               [weakSelf.arrayImage addObjectsFromArray:arraySelectPhotoModel];
                               [weakSelf.collectionView reloadData];
                           }];
                       }
                   }];
    [menu showArrowInPoint:CGPointMake(self.view.frame.size.width - 25, self.navigationController.navigationBar.frame.size.height + self.navigationController.navigationBar.frame.origin.y)];
}


@end
