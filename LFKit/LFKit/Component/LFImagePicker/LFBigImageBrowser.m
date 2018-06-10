//
//  LFBigImageBrowser.m
//  LFKit
//
//  Created by 张林峰 on 2018/6/10.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import "LFBigImageBrowser.h"
#import "MBProgressHUD.h"
#import "LFAlbumModel.h"

/*
 有待改进：1.滑动后选中状态没更新
 2.验证大于9情况
 */

@interface LFBigImageBrowser ()

@property (nonatomic, strong) UIView *viewBottomBar;
@property (nonatomic, strong) UIButton *btnOriginal;
@property (nonatomic, strong) UIButton *btnDone;

@end

@implementation LFBigImageBrowser

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.btSave setTitle:@"" forState:UIControlStateNormal];
        [self.btSave removeTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        [self.btSave setImage:[UIImage imageNamed:@"photo_radio_normal"] forState:UIControlStateNormal];
        [self.btSave setImage:[UIImage imageNamed:@"photo_radio_pressed"] forState:UIControlStateSelected];
        [self.btSave addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
        
        [self initBottomBar];
        __weak typeof(self) weakSelf = self;
        self.clickBlock = ^(NSInteger index) {
            [weakSelf setBarHidden:!weakSelf.topBar.hidden];
        };
    }
    return self;
}

- (void)dealloc {
    
}

-(void)layoutSubviews {
    [super layoutSubviews];
    if (self.topBar.hidden) {
        self.topBar.frame = CGRectMake(0, -44, self.bounds.size.width, 44);
        self.viewBottomBar.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 44);
    } else {
        self.topBar.frame = CGRectMake(0, 0, self.bounds.size.width, 44);
        self.viewBottomBar.frame = CGRectMake(0, self.bounds.size.height - 44, self.bounds.size.width, 44);
    }
    [self.btnOriginal sizeToFit];
    [self.btnDone sizeToFit];
    self.btnOriginal.frame = CGRectMake(12, 0, self.btnOriginal.frame.size.width, 44);
    CGFloat doneW = 70;
    self.btnDone.frame = CGRectMake(self.bounds.size.width - doneW - 12, 7, doneW, 30);
}

//初始化底部条
- (void)initBottomBar {
    self.viewBottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 44, self.frame.size.width, 44)];
    self.viewBottomBar.backgroundColor = [UIColor whiteColor];
    self.viewBottomBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.viewBottomBar.layer.shadowOffset = CGSizeMake(0, 1);
    [self addSubview:self.viewBottomBar];


    //原图
    self.btnOriginal = [[UIButton alloc] init];
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


    //确定按钮
    self.btnDone = [[UIButton alloc] init];
    self.btnDone.titleLabel.font = [UIFont systemFontOfSize:16];
    self.btnDone.clipsToBounds = YES;
    self.btnDone.layer.cornerRadius = 4;
    [self.btnDone setBackgroundImage:[LFAlbumModel imageWithColor:LFAlbumMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [self.btnDone setBackgroundImage:[LFAlbumModel imageWithColor:LFAlbumDisabledColor size:CGSizeMake(1, 1)] forState:UIControlStateDisabled];
    [self.btnDone setTitle:@"确定" forState:UIControlStateNormal];
    [self.btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [self.btnDone addTarget:self action:@selector(btnDone_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewBottomBar addSubview:self.btnDone];

}


- (void)setBarHidden:(BOOL)hidden {
    if (hidden) {
        [UIView animateWithDuration:0.2 animations:^{
            self.topBar.frame = CGRectMake(0, -44, self.bounds.size.width, 44);
            self.viewBottomBar.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 44);
        } completion:^(BOOL finished) {
            self.topBar.hidden = YES;
            self.viewBottomBar.hidden = YES;
        }];
    } else {
        self.topBar.hidden = NO;
        self.viewBottomBar.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.topBar.frame = CGRectMake(0, 0, self.bounds.size.width, 44);
            self.viewBottomBar.frame = CGRectMake(0, self.bounds.size.height - 44, self.bounds.size.width, 44);
        } completion:^(BOOL finished) {

        }];
    }
}

- (void)setArraySelectPhotos:(NSMutableArray<LFPhotoModel *> *)arraySelectPhotos {
    _arraySelectPhotos = arraySelectPhotos;
    self.btnOriginal.enabled = _arraySelectPhotos.count > 0;
}

- (void)selectImage:(UIButton *)button {
    button.selected = !button.selected;
    
    if (self.arraySelectPhotos.count >= self.maxSelectCount
        && button.selected == NO) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = [NSString stringWithFormat:@"最多只能选%zi张图片",self.maxSelectCount];
        [hud hideAnimated:YES afterDelay:3];
        return;
    }
    
    LFPhotoModel *model = self.arrayData[self.currentIndex];
    if (button.selected) {
        if (![LFPhotoModel judgeAssetisInLocalAblum:model.asset]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
            hud.label.text = @"正在从iCloud中下载照片";
            [LFPhotoModel requestImageForAsset:model.asset compressionQuality:0.5 resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                });
                model.image = image;
                [self.arraySelectPhotos addObject:model];
                [self resetBottomBtnsStatus];
            }];
        } else {
            [self.arraySelectPhotos addObject:model];

        }
    } else {
        for (LFPhotoModel *sModel in _arraySelectPhotos) {
            if ([model.asset.localIdentifier isEqualToString:sModel.asset.localIdentifier]) {
                [self.arraySelectPhotos removeObject:sModel];
                break;
            }
        }
    }
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
        [button sizeToFit];
        button.frame = CGRectMake(12, 0, button.frame.size.width, 44);
    }];
    [button sizeToFit];
    button.frame = CGRectMake(12, 0, button.frame.size.width, 44);
}

- (void)btnDone_Click:(id)sender
{
    if (self.DoneBlock) {
        self.DoneBlock(self.isSelectOriginalPhoto);
    }
}

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

@end
