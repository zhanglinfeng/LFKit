//
//  LFAlbumModel.m
//  LFKit
//
//  Created by 张林峰 on 2018/6/4.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import "LFAlbumModel.h"

@implementation LFAlbumModel

/**获取用户照片相册列表*/
+ (NSArray<LFAlbumModel *> *)getPhotoAlbumList
{
    NSMutableArray<LFAlbumModel *> *photoAlbumList = [NSMutableArray array];
    
    //***获取所有智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL *stop) {
        //过滤掉最近删除、视频
        if (@available(iOS 10.2, *)) {
            if(collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumVideos && collection.assetCollectionSubtype < PHAssetCollectionSubtypeSmartAlbumDepthEffect){
                NSArray<PHAsset *> *assets = [self getImageAssetsInAssetCollection:collection ascending:NO];
                if (assets.count > 0) {
                    LFAlbumModel *album = [[LFAlbumModel alloc] init];
                    album.title = collection.localizedTitle;
                    album.count = assets.count;
                    album.headImageAsset = assets.firstObject;
                    album.assetCollection = collection;
                    [photoAlbumList addObject:album];
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }];
    
    //***获取用户创建的相册，过滤视频
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray<PHAsset *> *assets = [self getImageAssetsInAssetCollection:collection ascending:NO];
        if (assets.count > 0) {
            LFAlbumModel *album = [[LFAlbumModel alloc] init];
            album.title = collection.localizedTitle;
            album.count = assets.count;
            album.headImageAsset = assets.firstObject;
            album.assetCollection = collection;
            [photoAlbumList addObject:album];
        }
    }];
    return photoAlbumList;
}

/**获取用户视频相册列表*/
+ (NSArray<LFAlbumModel *> *)getVideoAlbumList
{
    NSMutableArray<LFAlbumModel *> *photoAblumList = [NSMutableArray array];
    
    //添加视频列表入口
    PHFetchResult *videoAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumVideos options:nil];
    [videoAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray<PHAsset *> *assets = [self getVideoAssetsInAssetCollection:collection ascending:NO];
        if (assets.count > 0) {
            LFAlbumModel *album = [[LFAlbumModel alloc] init];
            album.title = @"视频";
            album.count = assets.count;
            album.headImageAsset = assets.firstObject;
            album.assetCollection = collection;
            [photoAblumList addObject:album];
        }
    }];
    return photoAblumList;
}

/**获取用户所有相册列表，包含视频*/
+ (NSArray<LFAlbumModel *> *)getPhotoAndVideoAlbumList {
    NSMutableArray<LFAlbumModel *> *photoAlbumList = [NSMutableArray arrayWithArray:[self getPhotoAlbumList]];
    [photoAlbumList addObjectsFromArray:[self getVideoAlbumList]];
    
    return photoAlbumList;
}



/**获取相册集中的图片Asset*/
+ (NSArray<PHAsset *> *)getImageAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending
{
    NSMutableArray<PHAsset *> *arr = [NSMutableArray array];
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (((PHAsset *)obj).mediaType == PHAssetMediaTypeImage) {
            [arr addObject:obj];
        }
    }];
    return arr;
}

/**获取相册集中的视频Asset*/
+ (NSArray<PHAsset *> *)getVideoAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending
{
    NSMutableArray<PHAsset *> *arr = [NSMutableArray array];
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (((PHAsset *)obj).mediaType == PHAssetMediaTypeVideo) {
            [arr addObject:obj];
        }
    }];
    return arr;
}

@end
