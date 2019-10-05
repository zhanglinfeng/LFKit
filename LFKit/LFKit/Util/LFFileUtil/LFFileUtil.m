//
//  LFFileUtil.m
//  BaseAPP
//
//  Created by 张林峰 on 16/2/1.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import "LFFileUtil.h"

@implementation LFFileUtil

/**获取Document文件目录*/
+(NSString*)getDocumentFilePathWithName:(NSString*)name
{
    //得到文件沙盒document路径
    NSArray* documents=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* document=[documents objectAtIndex:0];
    
    //获取文件目录
    NSString *path = [document stringByAppendingPathComponent:name];
    
    [LFFileUtil creatDirectory:path];
    
    return path;
}

/**获取Temp文件目录*/
+(NSString*)getTempFilePathWithName:(NSString*)name {
    //得到文件沙盒tmp路径
    NSString *tempPath = NSTemporaryDirectory();
    //获取文件目录
    return [tempPath stringByAppendingPathComponent:name];
}

/**获取Home文件目录*/
+ (NSString*)getHomeFilePathWithName:(NSString*)name {
    //得到文件沙盒tmp路径
    NSString *tempPath = NSHomeDirectory();
    //获取文件目录
    return [tempPath stringByAppendingPathComponent:name];
}

/**获取Cache文件目录*/
+ (NSString*)getCacheFilePathWithName:(NSString*)name {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    return [cachesDir stringByAppendingPathComponent:name];
}

/**创建目录*/
+ (BOOL)creatDirectory:(NSString *)path {
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    //目标路径的目录不存在则创建目录
    if (!(isDir == YES && existed == YES)) {
        return [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        return NO;
    }
}

/**删除目录或文件*/
+ (BOOL)deleteItemAtPath:(NSString *)path {
    NSFileManager* fileManager=[NSFileManager defaultManager];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:path];
    if (blHave) {
        return [fileManager removeItemAtPath:path error:nil];
    } else {
        return NO;
    }
}

/**移动文件*/
+ (BOOL)moveItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (srcPath.length < 1) {
        return NO;
    }
    BOOL srcExisted = [fileManager fileExistsAtPath:srcPath isDirectory:nil];
    if (!srcExisted) {
        return NO;
    }
    
    //如果不存在则创建目录
    [self creatDirectory:[dstPath stringByDeletingLastPathComponent]];
    
    NSError *error;
    BOOL moveSuccess = [fileManager moveItemAtPath:srcPath toPath:dstPath error:&error];
    return moveSuccess;
}


@end
