//
//  LFBigImageBrowser.h
//  LFKit
//
//  Created by 张林峰 on 2018/6/10.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import "LFPhotoBrowser.h"
#import "LFPhotoModel.h"

@interface LFBigImageBrowser : LFPhotoBrowser

//最大选择数
@property (nonatomic, assign) NSInteger maxSelectCount;

//是否选择了原图
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;
//当前已经选择的图片
@property (nonatomic, strong) NSMutableArray<LFPhotoModel *> *arraySelectPhotos;

//选则完成后回调
@property (nonatomic, copy) void (^DoneBlock)(BOOL isOriginalPhoto);



@end
