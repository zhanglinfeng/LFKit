//
//  LFPhotoAlbumController.h
//  LFKit
//
//  Created by 张林峰 on 2018/6/4.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFPhotoModel.h"

typedef NS_ENUM (NSUInteger, LFPhotoDataType) {
    LFPhotoDataTypeAll,    //选照片、视频
    LFPhotoDataTypeVideos, //只选视频
    LFPhotoDataTypePhotos  //只选照片
};

/**相册列表*/
@interface LFPhotoAlbumController : UIViewController

@property (nonatomic, assign) LFPhotoDataType dataType;

//最大选择数
@property (nonatomic, assign) NSInteger maxSelectCount;

//当前已经选择的图片
@property (nonatomic, strong) NSMutableArray<LFPhotoModel *> *arraySelectPhotos;

//选则完成后回调
@property (nonatomic, copy) void (^DoneBlock)(NSMutableArray<LFPhotoModel *> *arraySelectPhotos, BOOL isOriginalPhoto);

//取消选择后回调
@property (nonatomic, copy) void (^CancelBlock)(void);

@end
