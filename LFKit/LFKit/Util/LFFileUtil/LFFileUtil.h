//
//  LFFileUtil.h
//  BaseAPP
//
//  Created by 张林峰 on 16/2/1.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LFFileUtil : NSObject

/**获取Document文件路径*/
+ (NSString*)getDocumentFilePathWithName:(NSString*)name;

/**获取Temp文件路径*/
+ (NSString*)getTempFilePathWithName:(NSString*)name;

/**获取Home文件路径*/
+ (NSString*)getHomeFilePathWithName:(NSString*)name;

/**获取Cache文件路径*/
+ (NSString*)getCacheFilePathWithName:(NSString*)name;

/**创建目录(已判断是否存在，无脑用就行)*/
+ (BOOL)creatDirectory:(NSString *)path;

/**删除目录或文件*/
+ (BOOL)deleteItemAtPath:(NSString *)path;

/**移动文件*/
+ (BOOL)moveItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath;

@end
