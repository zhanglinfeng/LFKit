//
//  NSDictionary+LF.m
//  LFKit
//
//  Created by 张林峰 on 2018/10/28.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import "NSDictionary+LF.h"
#import "NSMutableDictionary+LF.h"
#import "NSArray+LF.h"

@implementation NSDictionary (LF)

- (NSString *)lf_stringForKey:(NSString *)key {
    id tmpValue = [self objectForKey:key];
    if (tmpValue == nil || tmpValue == [NSNull null]) {
        return @"";
    }
    if ([tmpValue isKindOfClass:[NSString class]]) {
        return tmpValue;
    } else {
        @try {
            return [NSString stringWithFormat:@"%@",tmpValue];
        }
        @catch (NSException *exception) {
            return @"";
        }
    }
}

- (NSInteger)lf_integerForKey:(NSString *)key {
    id tmpValue = [self objectForKey:key];
    if (tmpValue == nil || tmpValue == [NSNull null]) {
        return 0;
    }
    if ([tmpValue isKindOfClass:[NSNumber class]]) {
        return [tmpValue integerValue];
    } else {
        @try {
            return [tmpValue integerValue];
        }
        @catch (NSException *exception) {
            return 0;
        }
    }
}

- (float)lf_floatForKey:(NSString *)key {
    id tmpValue = [self objectForKey:key];
    if (tmpValue == nil || tmpValue == [NSNull null]) {
        return 0.0;
    }
    if ([tmpValue isKindOfClass:[NSNumber class]]) {
        return [tmpValue floatValue];
    } else {
        @try {
            return [tmpValue floatValue];
        }
        @catch (NSException *exception) {
            return 0.0;
        }
    }
}

- (BOOL)lf_boolForKey:(NSString *)key {
    id tmpValue = [self objectForKey:key];
    if (tmpValue == nil || tmpValue == [NSNull null]) {
        return NO;
    }
    if ([tmpValue isKindOfClass:[NSNumber class]]) {
        return [tmpValue boolValue];
    } else {
        @try {
            return [tmpValue boolValue];
        }
        @catch (NSException *exception) {
            return NO;
        }
    }
}

- (NSMutableArray *)lf_arrayForKey:(NSString *)key {
    id tmpValue = [self objectForKey:key];
    if (tmpValue == nil || tmpValue == [NSNull null]) {
        return [NSMutableArray new];
    }
    if ([tmpValue isKindOfClass:[NSArray class]]) {
        if ([tmpValue isKindOfClass:[NSMutableArray class]]) {
            return tmpValue;
        } else {
            return [[NSMutableArray alloc] initWithArray:(NSArray *)tmpValue];
        }
    } else {
        return [NSMutableArray new];
    }
}

- (NSMutableDictionary *)lf_dictionaryKey:(NSString *)key {
    id tmpValue = [self objectForKey:key];
    if (tmpValue == nil || tmpValue == [NSNull null]) {
        return [NSMutableDictionary new];
    }
    if ([tmpValue isKindOfClass:[NSDictionary class]]) {
        if ([tmpValue isKindOfClass:[NSMutableDictionary class]]) {
            return tmpValue;
        } else {
            return [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary *)tmpValue];
        }
    } else {
        return [NSMutableDictionary new];
    }
}

- (long long)lf_longLongForKey:(NSString *)key {
    id tmpValue = [self objectForKey:key];
    if (tmpValue == nil || tmpValue == [NSNull null]) {
        return 0.0;
    }
    if ([tmpValue isKindOfClass:[NSNumber class]]) {
        return [tmpValue longLongValue];
    } else {
        @try {
            return [tmpValue longLongValue];
        }
        @catch (NSException *exception) {
            return 0.0;
        }
    }
}

- (NSMutableDictionary *)lf_Mutable {
    NSMutableDictionary *dicResult = [[NSMutableDictionary alloc] init];
    for (NSString *key in self.allKeys) {
        NSObject *obj = self[key];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *mDic = [(NSDictionary *)obj lf_Mutable];
            [dicResult setObject:mDic forKey:key];
        } else if ([obj isKindOfClass:[NSArray class]]) {
            NSMutableArray *mArr = [self lf_MutableWith:(NSArray *)obj];
            [dicResult setObject:mArr forKey:key];
        } else {
            [dicResult setObject:obj forKey:key];
        }
    }
    return dicResult;
}

- (NSMutableArray *)lf_MutableWith:(NSArray *)array {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSObject *obj in array) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *mDic = [(NSDictionary *)obj lf_Mutable];
            [tempArray addObject:mDic];
        } else if ([obj isKindOfClass:[NSArray class]]) {
            NSMutableArray *mArr = [self lf_MutableWith:(NSArray *)obj];
            [tempArray addObject:mArr];
            
        } else {
            [tempArray addObject:obj];
        }
    }
    
    return tempArray;
}

/**返回一个用于url参数的string
 如key1=value1&key2=value2
 */
- (NSString *)getURLArgumentsString {
    //所有key
    NSArray *allkeys = [self allKeys];
    
    //遍历所有key 进行拼接
    __block NSMutableString *paramStr = [NSMutableString string];
    [allkeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
        //该key对应的值
        NSString *value = [self lf_stringForKey:key];
        [paramStr appendString:key];
        [paramStr appendString:@"="];
        [paramStr appendString:value];
        if (idx != allkeys.count - 1)
        {
            [paramStr appendString:@"&"];
        }
    }];
    
    return paramStr;
}

/**
 改变字典中某些key的名字
 
 @param param 字典数组@[@{@"原始key1":@"新key1",@"原始key2":@"新key2"},...]
 @return 结果
 */
- (NSMutableDictionary *)changeKeyName:(NSDictionary *)param {
    NSMutableDictionary *dicTemp = [NSMutableDictionary new];
    NSArray *allkeys = [self allKeys];
    NSArray *paramKeys = param.allKeys;
    for (NSString *key in allkeys) {
        if ([paramKeys containsObject:key]) {
            [dicTemp lf_setObject:self[key] forKey:param[key]];
        } else {
            [dicTemp lf_setObject:self[key] forKey:key];
        }
    }
    return dicTemp;
}

/**
 改变数组中的字典中某些key的名字
 @param array 数据源
 @param param 字典数组@[@{@"原始key1":@"新key1",@"原始key2":@"新key2"},...]
 @return 结果
 */
+ (NSMutableArray *)changeKeyNameFromArray:(NSArray *)array param:(NSDictionary *)param {
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in array) {
        NSMutableDictionary *dicTemp = [dic changeKeyName:param];
        [temp addObject:dicTemp];
    }
    return temp;
}


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
- (NSMutableArray *)getArrayWithKeyTitles:(NSArray *)ktArray param:(NSDictionary *)param {
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *dic in ktArray) {
        NSMutableDictionary *dicTemp = [NSMutableDictionary new];
        NSString *key = [dic.allKeys lf_objectAtIndex:0];
        NSArray *array = [self lf_arrayForKey:key];
        if (array.count < 1) {
            continue;
        }
        //格式化数组中字典的key为统一值
        NSMutableArray *formatterArray = [NSDictionary changeKeyNameFromArray:array param:param];
        [dicTemp setObject:formatterArray forKey:@"data"];
        [dicTemp setObject:[dic lf_stringForKey:key] forKey:@"title"];
        [temp addObject:dicTemp];
    }
    return temp;
}

@end
