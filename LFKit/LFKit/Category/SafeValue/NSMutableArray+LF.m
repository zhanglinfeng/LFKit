//
//  NSMutableArray+LF.m
//  LFKit
//
//  Created by 张林峰 on 2018/10/28.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import "NSMutableArray+LF.h"

@implementation NSMutableArray (LF)

- (void)lf_removeObjectAtIndex:(NSUInteger)index {
    if (index < self.count && index > -1) {
        [self removeObjectAtIndex:index];
    }
}

- (void)lf_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (index < self.count && index > -1) {
        [self replaceObjectAtIndex:index withObject:anObject];
    }
}

- (void)lf_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (index < self.count && index > -1) {
        [self insertObject:anObject atIndex:index];
    }
}

/**加一个不重复的元素*/
- (void)addDifferentObject:(id)anObject {
    if (![self containsObject:anObject]) {
        [self addObject:anObject];
    }
}

/**加一个主键不重复的元素，如果元素是字符串key可以不用传；如果元素是字典，则传主键*/
- (void)addObject:(id)anObject withKey:(NSString *)key {
    if (self.count < 1) {
        [self addObject:anObject];
    } else {
        if ([anObject isKindOfClass:[NSDictionary class]]) {
            if (key.length > 0) {
                BOOL has = NO;
                for (NSDictionary *dic in self) {
                    NSString *pk = dic[key];
                    if ([pk isEqualToString:((NSDictionary *)anObject)[key]]) {
                        has = YES;
                        break;
                    }
                }
                if (!has) {
                    [self addObject:anObject];
                }
                
            } else {
                [self addObject:anObject];
            }
        } else if ([anObject isKindOfClass:[NSString class]] || [anObject isKindOfClass:[NSNumber class]]) {
            if (![self containsObject:anObject]) {
                [self addObject:anObject];
            }
        } else {
            if (key.length > 0) {
                BOOL has = NO;
                for (NSObject *obj in self) {
                    NSString *pk = [obj valueForKey:key];
                    if ([pk isEqualToString:[anObject valueForKey:key]]) {
                        has = YES;
                        break;
                    }
                }
                if (!has) {
                    [self addObject:anObject];
                }
                
            } else {
                [self addObject:anObject];
            }
        }
    }
}

@end
