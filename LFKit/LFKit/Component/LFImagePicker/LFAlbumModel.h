//
//  LFAlbumModel.h
//  LFKit
//
//  Created by 张林峰 on 2018/6/4.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface LFAlbumModel : NSObject

@property (nonatomic, copy) NSString *title; //相册名字
@property (nonatomic, assign) NSInteger count; //该相册内相片数量
@property (nonatomic, strong) PHAsset *headImageAsset; //相册第一张图片缩略图
@property (nonatomic, strong) PHAssetCollection *assetCollection; //相册集，通过该属性获取该相册集下所有照片

/**获取用户照片相册列表*/
+ (NSArray<LFAlbumModel *> *)getPhotoAlbumList;

/**获取用户视频相册列表*/
+ (NSArray<LFAlbumModel *> *)getVideoAlbumList;

/**获取用户所有相册列表，包含视频*/
+ (NSArray<LFAlbumModel *> *)getPhotoAndVideoAlbumList;

/**获取相册集中的图片Asset*/
+ (NSArray<PHAsset *> *)getImageAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending;

/**获取相册集中的视频Asset*/
+ (NSArray<PHAsset *> *)getVideoAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending;

@end
