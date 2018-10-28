//
//  NSMutableDictionary+LF.m
//  LFKit
//
//  Created by 张林峰 on 2018/10/28.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import "NSMutableDictionary+LF.h"

@implementation NSMutableDictionary (LF)

- (void)lf_setObject:(id)obj forKey:(NSString *)key {
    if (obj != nil && key != nil) {
        [self setObject:obj forKey:key];
    }
}

@end
