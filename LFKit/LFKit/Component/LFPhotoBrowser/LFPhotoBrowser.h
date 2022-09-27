//
//  LFPhotoBrowser.h
//  LFKit
//
//  Created by 张林峰 on 2018/6/2.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFPhotoModel.h"

@interface LFPhotoBrowser : UIView <UICollectionViewDelegate,UICollectionViewDataSource>

#pragma mark - 必传参
@property (nonatomic, strong) NSArray <LFPhotoModel *>*arrayData;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, weak) UIViewController *ctr;//用于弹权限框的alert

#pragma mark - 可不传
@property (nonatomic, strong) UIImage *placeholder;
@property (nonatomic) CGRect beginRect;//外面列表中cell转换到window的rect，用于做转场动画（不传则没有转场动画）
@property (nonatomic, strong) UIImage *beginImage;//外面列表中被点击的图片，用于做转场动画（不传则没有转场动画）
//@property (nonatomic, assign) BOOL isShowTopBar;//yes单击显示头部bar，no单击大图浏览器消失，默认为no
@property (nonatomic, assign) BOOL isSupportLandscape;//是否支持横屏，默认yes

#pragma mark - 方便外面设置字体、图标，没事不需设置
@property (strong, nonatomic) UIView *topBar;
@property (nonatomic, strong) UIButton *btBack;
@property (nonatomic, strong) UIButton *btSave;
@property (nonatomic, strong) UILabel *lbTitle;

@property (nonatomic, copy) void(^clickBlock)(NSInteger index);//单击事件，如果传了block，则优先使用block事件，否则根据isShowTopBar判断使用何种单击事件
@property (nonatomic, copy) void(^didScrollBlock)(NSInteger index);
@property (nonatomic, copy) void(^didDismiss)(void);//消失事件（让状态栏显示会用到）

//展示
- (void)show;

- (UIImage *)getCurrentImage;

- (void)dismiss;

//保存图片
- (void)save;

@end
