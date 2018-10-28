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

@end

NS_ASSUME_NONNULL_END
