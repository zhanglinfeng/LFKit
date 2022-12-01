//
//  NSArray+LF.m
//  LFKit
//
//  Created by 张林峰 on 2018/10/28.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import "NSArray+LF.h"

@implementation NSArray (LF)

- (id)lf_objectAtIndex:(NSInteger)index {
    if (index < self.count && index > -1) {
        return [self objectAtIndex:index];
    } else {
        return nil;
    }
}

- (NSMutableArray *)lf_Mutable {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSObject *obj in self) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *mDic = [self lf_MutableWith:(NSDictionary *)obj];
            [tempArray addObject:mDic];
        } else if ([obj isKindOfClass:[NSArray class]]) {
            NSMutableArray *mArr = [(NSArray *)obj lf_Mutable];
            [tempArray addObject:mArr];
            
        } else {
            [tempArray addObject:obj];
        }
    }
    
    return tempArray;
}

- (NSMutableDictionary *)lf_MutableWith:(NSDictionary *)dic {
    NSMutableDictionary *dicResult = [[NSMutableDictionary alloc] init];
    for (NSString *key in dic.allKeys) {
        NSObject *obj = dic[key];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *mDic = [self lf_MutableWith:(NSDictionary *)obj];
            [dicResult setObject:mDic forKey:key];
        } else if ([obj isKindOfClass:[NSArray class]]) {
            NSMutableArray *mArr = [(NSArray *)obj lf_Mutable];
            [dicResult setObject:mArr forKey:key];
        } else {
            [dicResult setObject:obj forKey:key];
        }
    }
    return dicResult;
}

/**去重复*/
- (NSMutableArray *)lf_removeDuplicates {
    NSMutableArray *arrayResult = [NSMutableArray new];
    for (NSObject *obj in self) {
        if (![arrayResult containsObject:obj]) {
            [arrayResult addObject:obj];
        }
    }
    return arrayResult;
}


/**去重复，如果元素是字符串key可不传；如果元素是字典，则传主键*/
- (NSMutableArray *)lf_removeDuplicatesWithKey:(NSString *)key {
    if (self.count < 2) {
        return [[NSMutableArray alloc] initWithArray:self];
    }
    NSMutableArray *arrayResult = [NSMutableArray new];
    NSMutableArray *arrayPk = [NSMutableArray new];
    
    NSObject *obj = self[0];
    if ([obj isKindOfClass:[NSDictionary class]]) {
        if (key.length > 0) {
            for (NSDictionary *dic in self) {
                NSString *pk = dic[key];
                if (![arrayPk containsObject:pk]) {
                    [arrayResult addObject:dic];
                    [arrayPk addObject:pk];
                }
            }
            return arrayResult;
        } else {
            return [[NSMutableArray alloc] initWithArray:self];
        }
    } else if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]]) {
        for (NSObject *obj in self) {
            if (![arrayResult containsObject:obj]) {
                [arrayResult addObject:obj];
            }
        }
    } else {
        if (key.length > 0) {
            for (NSObject *obj in self) {
                NSString *pk = [obj valueForKey:key];
                if (![arrayPk containsObject:pk]) {
                    [arrayResult addObject:obj];
                    [arrayPk addObject:pk];
                }
            }
            return arrayResult;
        } else {
            return [[NSMutableArray alloc] initWithArray:self];
        }
    }
    return arrayResult;
}

/** 查找数组中指定键值对的字典*/
- (NSDictionary *)lf_itemWithKey:(NSString *)key value:(NSString *)value {
    for (NSInteger i = 0; i < self.count; i++) {
        NSDictionary *dic = self[i];
        if ([dic[key] isEqualToString:value]){
            return dic;
        }
    }
    return nil;
}

@end
