//
//  NSArray+LF.h
//  LFKit
//
//  Created by 张林峰 on 2018/10/28.
//  Copyright © 2018年 张林峰. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface NSArray (LF)

/**安全取值*/
- (id)lf_objectAtIndex:(NSInteger)index;

/**转成可变型数据，包括里面的字典、数组*/
- (NSMutableArray *)lf_Mutable;

/**去重复*/
- (NSMutableArray *)lf_removeDuplicates;

/**主键去重复，如果元素是字符串key可不传；如果元素是字典，则传主键*/
- (NSMutableArray *)lf_removeDuplicatesWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
