//
//  NSDictionary+LF.h
//  LFKit
//
//  Created by 张林峰 on 2018/10/28.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (LF)

- (NSString *)lf_stringForKey:(NSString *)key;
- (NSInteger)lf_integerForKey:(NSString *)key;
- (float)lf_floatForKey:(NSString *)key;
- (BOOL)lf_boolForKey:(NSString *)key;
- (NSMutableArray *)lf_arrayForKey:(NSString *)key;
- (NSMutableDictionary *)lf_dictionaryKey:(NSString *)key;
- (long long)lf_longLongForKey:(NSString *)key;

/**转成可变型数据，包括里面的字典、数组*/
- (NSMutableDictionary *)lf_Mutable;

/**返回一个用于url参数的string
 如key1=value1&key2=value2
 */
- (NSString *)getURLArgumentsString;


/**
 改变字典中某些key的名字
 
 @param param 字典数组@[@{@"原始key1":@"新key1",@"原始key2":@"新key2"},...]
 @return 结果
 */
- (NSMutableDictionary *)changeKeyName:(NSDictionary *)param;


/**
 改变数组中的字典中某些key的名字
 @param array 数据源
 @param param 字典数组@[@{@"原始key1":@"新key1",@"原始key2":@"新key2"},...]
 @return 结果
 */
+ (NSMutableArray *)changeKeyNameFromArray:(NSArray *)array param:(NSDictionary *)param;


/**
 从字典中提取数据组成列表需要的结构（基本多个section的列表需要用到）
 
 @param ktArray @[@{@"数据节点1的key":"需要设置的title"},@{@"数据节点2的key":"需要设置的title"},...]
 @param param 字典数组@[@{@"原始key1":@"新key1",@"原始key2":@"新key2"}]
 @return 结果 例如:
 @[
 @{
 @"title":str1;
 @"data":@[dic1,dic2];
 },
 @{
 @"title":str2;
 @"data":@[dic3,dic4];
 }
 ]
 */
- (NSMutableArray *)getArrayWithKeyTitles:(NSArray *)ktArray param:(NSDictionary *)param;

@end

NS_ASSUME_NONNULL_END
