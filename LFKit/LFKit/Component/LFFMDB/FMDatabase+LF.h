//
//  FMDatabase+LF.h
//  LFKit
//
//  Created by 张林峰 on 2018/1/30.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import <FMDB/FMDB.h>

@interface FMDatabase (LF)

/**默认Document下创建*/
+ (instancetype)databaseWithName:(NSString *)name;

- (BOOL)lf_createTable:(NSString *)tableName class:(Class)modelClass pkId:(NSString *)pk excludeName:(NSArray *)nameArr;

@end
