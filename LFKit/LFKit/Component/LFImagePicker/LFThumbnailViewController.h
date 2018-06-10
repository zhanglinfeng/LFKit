//
//  LFThumbnailViewController.h
//  LFKit
//
//  Created by 张林峰 on 2018/6/4.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFPhotoModel.h"

@interface LFThumbnailViewController : UIViewController

//相册属性
@property (nonatomic, strong) PHAssetCollection *assetCollection;

//当前已经选择的图片
@property (nonatomic, strong) NSMutableArray<LFPhotoModel *> *arraySelectPhotos;
//最大选择数
@property (nonatomic, assign) NSInteger maxSelectCount;
//是否选择了原图
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;

//选则完成后回调
@property (nonatomic, copy) void (^DoneBlock)(BOOL isOriginalPhoto);


//取消选择后回调
@property (nonatomic, copy) void (^CancelBlock)(void);

@end
