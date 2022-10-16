//
//  NSMutableArray+LF.h
//  LFKit
//
//  Created by 张林峰 on 2018/10/28.
//  Copyright © 2018年 张林峰. All rights reserved.
//




@interface NSMutableArray (LF)

- (void)lf_removeObjectAtIndex:(NSInteger)index;
- (void)lf_replaceObjectAtIndex:(NSInteger)index withObject:(id)anObject;
- (void)lf_insertObject:(id)anObject atIndex:(NSInteger)index;
- (void)lf_addObject:(id)anObject;

/**加一个不重复的元素*/
- (void)addDifferentObject:(id)anObject;

/**加一个主键不重复的元素，如果元素是字符串key可以不用传；如果元素是字典，则传主键*/
- (void)addObject:(id)anObject withKey:(NSString *)key;

@end

