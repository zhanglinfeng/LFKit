//
//  LFPhotoModel.m
//  LFKit
//
//  Created by 张林峰 on 2018/6/2.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import "LFPhotoModel.h"

@implementation LFPhotoModel

/** 字符串数组转大图浏览组件所需数据模型 */
+ (NSMutableArray *)getDatasFromStringArray:(NSArray *)array {
    if (array.count < 1) {
        return nil;
    }
    NSMutableArray *mArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < array.count; i++) {
        NSString *str = array[i];
        LFPhotoModel *model = [[LFPhotoModel alloc] init];
        model.bigImageUrl = str;
        [mArray addObject:model];
    }
    return  mArray;
}

- (BOOL)isVideo {
    return self.asset.mediaType == PHAssetMediaTypeVideo;
}

- (NSInteger)fetchVideoLength {
    if ([self isVideo] == NO) {
        return 0;
    }
    return self.asset.duration;
}

- (NSString *)fetchVideoTimeString {
    NSInteger second = [self fetchVideoLength];
    NSInteger minutes = (second / 60) % 60;
    NSInteger seconds = second % 60;
    NSString *result = [NSString stringWithFormat:@"%02li:%02li",(long)minutes,(long)seconds];
    return result;
}

#pragma mark - 获取asset对应的图片

+ (void)requestImageForAsset:(PHAsset *)asset
                        size:(CGSize)size
                  resizeMode:(PHImageRequestOptionsResizeMode)resizeMode
              needThumbnails:(BOOL)needThumbnails
                  completion:(void (^)(UIImage *image, NSDictionary *info))completion
{
    static PHImageRequestID requestID = -1;
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    /**
     resizeMode：对请求的图像怎样缩放。有三种选择：None，默认加载方式；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
     deliveryMode：图像质量。有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。
     这个属性只有在 synchronous 为 true 时有效。
     */
    
    option.resizeMode = resizeMode;//控制照片尺寸
    //option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;//控制照片质量
    option.networkAccessAllowed = YES;//YES会请求iCloud照片;
    
    /*
     info字典提供请求状态信息:
     PHImageResultIsInCloudKey：图像是否必须从iCloud请求
     PHImageResultIsDegradedKey：当前UIImage是否是低质量的，这个可以实现给用户先显示一个预览图
     PHImageResultRequestIDKey和PHImageCancelledKey：请求ID以及请求是否已经被取消
     PHImageErrorKey：如果没有图像，字典内的错误信息
     */
    
    requestID = [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
        BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey];
        //不要该判断，即如果该图片在iCloud上时候，会先显示一张模糊的预览图，待加载完毕后会显示高清图
        // && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]
        BOOL isThumbnails = [[info objectForKey:PHImageResultIsDegradedKey] boolValue];
        if (downloadFinined && completion && image) {
            if (needThumbnails) {
                completion(image, info); //需要缩略图，返回第一次的回调
            } else if (isThumbnails == NO){
                completion(image, info); //不需求缩略图，仅返回第二次的回调
            }
        }
    }];
}

+ (void)requestImageForAsset:(PHAsset *)asset compressionQuality:(CGFloat)compressionQuality resizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage *image))completion
{
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = resizeMode;//控制照片尺寸
    option.networkAccessAllowed = YES;//YES会请求iCloud照片;
    
    [[PHCachingImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
        if (downloadFinined && completion) {
            NSData *data = UIImageJPEGRepresentation([UIImage imageWithData:imageData], compressionQuality);
            completion([UIImage imageWithData:data]);
        }
    }];
}

#pragma mark - 计算大小
/**
 * @brief 获取数组内图片的字节大小
 */
+ (void)getPhotosBytesWithArray:(NSArray<LFPhotoModel*>*)photos completion:(void (^)(NSString *photosBytes))completion
{
    __block NSInteger dataLength = 0;
    
    __block NSInteger count = photos.count;
    
    __weak typeof(self) weakSelf = self;
    for (int i = 0; i < photos.count; i++) {
        LFPhotoModel *model = photos[i];
        [[PHCachingImageManager defaultManager] requestImageDataForAsset:model.asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            dataLength += imageData.length;
            count--;
            if (count <= 0) {
                if (completion) {
                    completion([strongSelf transformDataLength:dataLength]);
                }
            }
        }];
    }
}

+ (NSString *)transformDataLength:(NSInteger)dataLength {
    NSString *bytes = @"";
    if (dataLength >= 0.1 * (1024 * 1024)) {
        bytes = [NSString stringWithFormat:@"%.1fM",dataLength/1024/1024.0];
    } else if (dataLength >= 1024) {
        bytes = [NSString stringWithFormat:@"%.0fK",dataLength/1024.0];
    } else {
        bytes = [NSString stringWithFormat:@"%li",(long)dataLength];
    }
    return bytes;
}

/**
 * @brief 判断图片是否存储在本地/或者已经从iCloud上下载到本地
 */
+ (BOOL)judgeAssetisInLocalAblum:(PHAsset *)asset
{
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.networkAccessAllowed = NO;
    option.synchronous = YES;
    
    __block BOOL isInLocalAblum = YES;
    
    [[PHCachingImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        isInLocalAblum = imageData ? YES : NO;
    }];
    return isInLocalAblum;
}

@end
