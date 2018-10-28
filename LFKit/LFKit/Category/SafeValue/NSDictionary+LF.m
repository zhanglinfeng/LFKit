//
//  NSDictionary+LF.m
//  LFKit
//
//  Created by 张林峰 on 2018/10/28.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import "NSDictionary+LF.h"

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

@end
