//
//  LFPhotoBrowser.m
//  LFKit
//
//  Created by 张林峰 on 2018/6/2.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import "LFPhotoBrowser.h"
#import "LFBigImageCell.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MBProgressHUD.h"

#define kItemMargin 20
#define kLFBigImageCell @"LFBigImageCell"

@interface LFPhotoBrowser ()

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIView *viewBG;//黑色背景，本视图的哥哥，作用是防止转屏看到下面的视图

@end

@implementation LFPhotoBrowser

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.frame = CGRectMake(0, 0, window.frame.size.width, window.frame.size.height);
        self.backgroundColor = [UIColor blackColor];
        self.isSupportLandscape = YES;
        [self loadCollectionView];
        [self addSubview:self.topBar];
    }
    
    return self;
}

-(void)dealloc {
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = CGRectMake(-kItemMargin/2, 0, self.bounds.size.width + kItemMargin, self.bounds.size.height);

//    NSLog(@"33333333=%@",self.collectionView);
//    NSLog(@"当前第%zi",self.currentIndex);
//    [self.collectionView setContentOffset:CGPointMake(self.currentIndex*self.collectionView.frame.size.width, 0) animated:NO];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    self.lbTitle.frame = _topBar.bounds;
    self.btBack.frame = CGRectMake(12, 17, self.btBack.frame.size.width, self.btBack.frame.size.height);
    self.btSave.frame = CGRectMake(_topBar.frame.size.width - 52, 17, self.btSave.frame.size.width, self.btSave.frame.size.height);
    
    if (!self.topBar.hidden) {
        CGFloat top = 0;
        if (@available(iOS 11.0, *)) {
            top = self.safeAreaInsets.top;
        }
        self.topBar.frame = CGRectMake(0, top, self.frame.size.width, 64);
    }
//    NSLog(@"self-layoutSubviews=%@",self);
}

#pragma mark - UICollectionView
- (void)loadCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = kItemMargin;
    layout.sectionInset = UIEdgeInsetsMake(0, kItemMargin/2, 0, kItemMargin/2);
    layout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-kItemMargin/2, 0, self.frame.size.width + kItemMargin, self.frame.size.height) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.bounces = YES;
    self.collectionView.pagingEnabled = YES;
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:[LFBigImageCell class] forCellWithReuseIdentifier:kLFBigImageCell];
}

//section 的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrayData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LFBigImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLFBigImageCell forIndexPath:indexPath];
    LFPhotoModel *photo = self.arrayData[indexPath.item];
    cell.photo = photo;
    cell.placeholder = self.placeholder;
    __weak typeof(self) weakSelf = self;
    cell.singleTapCallBack = ^{
        if (weakSelf.clickBlock) {
            weakSelf.clickBlock(indexPath.item);
        } else {
//            if (weakSelf.isShowTopBar) {
//                [weakSelf setTopBarHidden:!weakSelf.topBar.hidden];
//            } else {
                [weakSelf dismiss];
//            }
        }
    };
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.clickBlock) {
        self.clickBlock(indexPath.item);
    } else {
//        if (self.isShowTopBar) {
//            [self setTopBarHidden:!self.topBar.hidden];
//        } else {
            [self dismiss];
//        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == (UIScrollView *)self.collectionView) {
        CGFloat page = scrollView.contentOffset.x/(scrollView.frame.size.width);
        NSString *str = [NSString stringWithFormat:@"%.0f", page];
        self.currentIndex = str.integerValue;
        self.lbTitle.text = [NSString stringWithFormat:@"%li/%lu",(long)(self.currentIndex+1),(unsigned long)self.arrayData.count];
        if (self.didScrollBlock) {
            self.didScrollBlock(self.currentIndex);
        }
    }
}

- (void)save {
    UIImage *image = [self getCurrentImage];
    [self saveImageToAlbum:image];
}

/** 保存到本地 **/
- (void)saveImageToAlbum:(UIImage *)image {
    if (@available(iOS 11.0, *)) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
                [self showAuthorizationAlert];
            } else {
                UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
            }
        }];
    } else {
        // 获取当前应用对照片的访问授权状态
        PHAuthorizationStatus authorizationStatus = [PHPhotoLibrary authorizationStatus];
        // 如果没有获取访问授权，或者访问授权状态已经被明确禁止，则显示提示语，引导用户开启授权
        if (authorizationStatus == PHAuthorizationStatusRestricted || authorizationStatus == PHAuthorizationStatusDenied) {
            [self showAuthorizationAlert];
        } else {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}


/**  **/
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        //下面的1行代码必须要写，如果不写就会导致指示器的背景永远都会有一层透明度为0.5的背景
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = [UIColor colorWithWhite:0.f alpha:0.8f];
        hud.contentColor = [UIColor whiteColor];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"图片已保存到手机相册";
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:3.f];
        
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        //下面的1行代码必须要写，如果不写就会导致指示器的背景永远都会有一层透明度为0.5的背景
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = [UIColor colorWithWhite:0.f alpha:0.8f];
        hud.contentColor = [UIColor whiteColor];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"保存失败";
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:3.f];
    }
}

- (void)showAuthorizationAlert {
    if (!self.ctr) {
        return;
    }
    NSString *appDisplayName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *message = [NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册", appDisplayName];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) { }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"去开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }]];
    
    [self.ctr presentViewController:alert animated:YES completion:^{
        //防止被大图挡住
        [alert.view.superview.superview bringSubviewToFront:alert.view.superview];
    }];
    
}


-(UIView *)topBar {
    if (!_topBar) {
        CGFloat top = 0;
        if (@available(iOS 11.0, *)) {
            top = self.safeAreaInsets.top;
        }
        _topBar = [[UIView alloc] initWithFrame:CGRectMake(0, top, self.frame.size.width, 64)];
        _topBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.lbTitle = [[UILabel alloc] initWithFrame:_topBar.bounds];
        self.lbTitle.textAlignment = NSTextAlignmentCenter;
        self.lbTitle.textColor = [UIColor whiteColor];
        self.lbTitle.font = [UIFont systemFontOfSize:15];
        [_topBar addSubview:self.lbTitle];
        
        self.btBack = [[UIButton alloc] initWithFrame:CGRectMake(12, 17, 40, 30)];
        [self.btBack setTitle:@"关闭" forState:UIControlStateNormal];
        self.btBack.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.btBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btBack addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_topBar addSubview:self.btBack];
        
        self.btSave = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 52, 17, 40, 30)];
        [self.btSave setTitle:@"保存" forState:UIControlStateNormal];
        self.btSave.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.btSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btSave addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        [_topBar addSubview:self.btSave];
//        _topBar.hidden = YES;
    }
    return _topBar;
}

#pragma mark - 内部方法

- (void)setTopBarHidden:(BOOL)hidden {
    if (hidden) {
        [UIView animateWithDuration:0.2 animations:^{
            self.topBar.frame = CGRectMake(0, -64, self.bounds.size.width, 64);
        } completion:^(BOOL finished) {
            self.topBar.hidden = YES;
        }];
    } else {
        self.topBar.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            CGFloat top = 0;
            if (@available(iOS 11.0, *)) {
                top = self.safeAreaInsets.top;
            }
            self.topBar.frame = CGRectMake(0, top, self.bounds.size.width, 64);
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)onDeviceOrientationChangeWithObserver
{
    [self onDeviceOrientationChange];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)onDeviceOrientationChange {
    if (!self.isSupportLandscape) {
        return;
    }
    
    NSArray *visibleCells = [self.collectionView visibleCells];
    if (visibleCells.count > 0) {
        LFBigImageCell *cell = visibleCells[0];
        [cell.scrollView setZoomScale:1.0 animated:YES];
    }
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    __weak typeof(self) weakSelf = self;
    CGRect screenBounds = [UIScreen mainScreen].bounds;
//    NSLog(@"屏幕w=%f,h=%f",screenBounds.size.width,screenBounds.size.height);
    if (UIDeviceOrientationIsLandscape(orientation)) {
        [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//            [[UIApplication sharedApplication] setStatusBarOrientation:(UIInterfaceOrientation)orientation];
            weakSelf.transform = (orientation==UIDeviceOrientationLandscapeRight)?CGAffineTransformMakeRotation(M_PI*1.5):CGAffineTransformMakeRotation(M_PI/2);
//            self.bounds = CGRectMake(0, 0, screenBounds.size.height, screenBounds.size.width);
        
//            [self setNeedsLayout];
//            [self layoutIfNeeded];
//            NSLog(@"11111=%@",self);
//            NSLog(@"22222=%@",self.collectionView);
        } completion:^(BOOL finished) {
            weakSelf.bounds = CGRectMake(0, 0, screenBounds.size.height, screenBounds.size.width);
//            [weakSelf setTopBarHidden:weakSelf.topBar.hidden];
            [weakSelf setNeedsLayout];
            [weakSelf layoutIfNeeded];
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            layout.minimumLineSpacing = kItemMargin;
            layout.sectionInset = UIEdgeInsetsMake(0, kItemMargin/2, 0, kItemMargin/2);
            layout.itemSize = CGSizeMake(weakSelf.collectionView.frame.size.width - kItemMargin, weakSelf.collectionView.frame.size.height);
            weakSelf.collectionView.collectionViewLayout = layout;
            [weakSelf.collectionView reloadData];
        }];
    }else if (orientation==UIDeviceOrientationPortrait || orientation==UIDeviceOrientationPortraitUpsideDown){
        
        [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//            [[UIApplication sharedApplication] setStatusBarOrientation:(UIInterfaceOrientation)orientation];
            weakSelf.transform = (orientation==UIDeviceOrientationPortrait)?CGAffineTransformIdentity:CGAffineTransformMakeRotation(M_PI);
//            self.bounds = screenBounds;
            
//            [self setNeedsLayout];
//            [self layoutIfNeeded];
//            NSLog(@"*11111=%@",self);
//            NSLog(@"*22222=%@",self.collectionView);
        } completion:^(BOOL finished) {
            weakSelf.bounds = screenBounds;
//            [weakSelf setTopBarHidden:weakSelf.topBar.hidden];
            [weakSelf setNeedsLayout];
            [weakSelf layoutIfNeeded];
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            layout.minimumLineSpacing = kItemMargin;
            layout.sectionInset = UIEdgeInsetsMake(0, kItemMargin/2, 0, kItemMargin/2);
            layout.itemSize = CGSizeMake(weakSelf.collectionView.frame.size.width - kItemMargin, weakSelf.collectionView.frame.size.height);
            weakSelf.collectionView.collectionViewLayout = layout;
            [weakSelf.collectionView reloadData];
        }];
    }
}

#pragma mark - 外部方法

//-(void)setIsShowTopBar:(BOOL)isShowTopBar {
//    _isShowTopBar = isShowTopBar;
//    self.topBar.hidden = !isShowTopBar;
//}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_currentIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    self.lbTitle.text = [NSString stringWithFormat:@"%li/%lu",(long)(_currentIndex+1),(unsigned long)self.arrayData.count];
}

- (UIImage *)getCurrentImage {
    NSArray *visibleCells = [self.collectionView visibleCells];
    if (visibleCells.count > 0) {
        LFBigImageCell *cell = visibleCells[0];
        return [cell getImage];
    }
    return nil;
}


- (void)show {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    self.viewBG = [[UIView alloc] initWithFrame:window.bounds];
    self.viewBG.center = window.center;
    self.viewBG.bounds = window.bounds;
    self.viewBG.backgroundColor = [UIColor blackColor];
    [window addSubview:self.viewBG];
    
    self.center = CGPointMake(window.bounds.size.width*0.5, window.bounds.size.height *0.5);
    self.bounds = CGRectMake(0, 0, window.bounds.size.width, window.bounds.size.height);
    [window addSubview:self];
    //转场动画
    CGFloat delay = 0;
    if (self.beginImage && self.beginRect.size.width > 0) {
        // 这2行防止转场动画消失后，cell中图片加载完成前出现的黑屏闪一下
        LFPhotoModel *photo = self.arrayData[self.currentIndex];
        photo.smallImage = self.beginImage;
        
        delay = 0.3;
        UIImageView *tempView = [[UIImageView alloc] init];
        tempView.contentMode = UIViewContentModeScaleAspectFill;
        tempView.clipsToBounds = YES;
        tempView.frame = self.beginRect;
        tempView.image = self.beginImage;
        [self addSubview:tempView];
        
        CGFloat placeImageSizeW = tempView.image.size.width;
        CGFloat placeImageSizeH = tempView.image.size.height;
        CGRect targetTemp;
        
        CGFloat placeHolderH = (placeImageSizeH * self.frame.size.width)/placeImageSizeW;
        if (placeHolderH <= self.frame.size.height) {
            targetTemp = CGRectMake(0, (self.frame.size.height - placeHolderH) * 0.5 , self.frame.size.width, placeHolderH);
        } else {
            targetTemp = CGRectMake(0, 0, self.frame.size.width, placeHolderH);
        }
        
        self.collectionView.hidden = YES;
        
        [UIView animateWithDuration:0.3 animations:^{
            tempView.frame = targetTemp;
        } completion:^(BOOL finished) {
            [tempView removeFromSuperview];
            self.collectionView.hidden = NO;
        }];
    }
    
    
    [self performSelector:@selector(onDeviceOrientationChangeWithObserver) withObject:nil afterDelay:delay + 0.1];
    
}

- (void)dismiss {
    if (self.didDismiss) {
        self.didDismiss();
    }
    
    [self.viewBG removeFromSuperview];
    
    if (self.beginImage && self.beginRect.size.width > 0) {
        UIImageView *tempImageView = [[UIImageView alloc] init];
        tempImageView.contentMode = UIViewContentModeScaleAspectFill;
        tempImageView.clipsToBounds = YES;
        tempImageView.image = [self getCurrentImage];
        CGFloat tempImageSizeH = tempImageView.image.size.height;
        CGFloat tempImageSizeW = tempImageView.image.size.width;
        CGFloat tempImageViewH = (tempImageSizeH * self.frame.size.width)/tempImageSizeW;
        
        if (tempImageViewH < self.frame.size.height) {
            tempImageView.frame = CGRectMake(0, (self.frame.size.height - tempImageViewH)*0.5, self.frame.size.width, tempImageViewH);
        } else {
            tempImageView.frame = CGRectMake(0, 0, self.frame.size.width, tempImageViewH);
        }
        [self addSubview:tempImageView];
        
        self.topBar.hidden = YES;
        self.collectionView.hidden = YES;
        
        self.backgroundColor = [UIColor clearColor];
        [UIView animateWithDuration:0.3 animations:^{
            tempImageView.frame = self.beginRect;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [tempImageView removeFromSuperview];
        }];
    } else {
        [self removeFromSuperview];
    }
    
}

@end
