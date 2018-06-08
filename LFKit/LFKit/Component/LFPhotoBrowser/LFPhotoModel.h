//
//  LFPhotoModel.h
//  LFKit
//
//  Created by 张林峰 on 2018/6/2.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h> //照片

@interface LFPhotoModel : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) NSString *smallImageUrl;
@property (nonatomic, strong) NSString *bigImageUrl;

/*
 当前媒体是否为视频
 */
- (BOOL)isVideo;

/*
 获取视频媒体的时长
 */
- (NSInteger)fetchVideoLength;

/*
 获取视频媒体的时长，用于显示
 */
- (NSString *)fetchVideoTimeString;

#pragma mark - 获取asset对应的图片
+ (void)requestImageForAsset:(PHAsset *)asset
                        size:(CGSize)size
                  resizeMode:(PHImageRequestOptionsResizeMode)resizeMode
              needThumbnails:(BOOL)needThumbnails
                  completion:(void (^)(UIImage *image, NSDictionary *info))completion;

+ (void)requestImageForAsset:(PHAsset *)asset compressionQuality:(CGFloat)compressionQuality resizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage *image))completion;

#pragma mark - 计算大小
/**
 * @brief 获取数组内图片的字节大小
 */
+ (void)getPhotosBytesWithArray:(NSArray<LFPhotoModel*>*)photos completion:(void (^)(NSString *photosBytes))completion;
/**
 * @brief 判断图片是否存储在本地/或者已经从iCloud上下载到本地
 */
+ (BOOL)judgeAssetisInLocalAblum:(PHAsset *)asset;

@end
