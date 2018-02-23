//
//  FMDatabase+LF.h
//  LeanFish
//
//  Created by 张林峰 on 2018/1/31.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import <FMDB/FMDB.h>

@interface FMDatabase (LF)

/**默认Document下创建*/
+ (instancetype)databaseWithName:(NSString *)name;

/**获取数据库路径*/
- (NSString*)lf_getPath;


/**
 创建表

 @param modelClass 自定义类
 @param pkId 主键，可不传
 @param nameArr 类中不参与建表的字段
 @return 是否创建成果
 */
- (BOOL)lf_createTable:(Class)modelClass pkId:(NSString *)pkId ignoreName:(NSArray *)nameArr;

/**
 插入
 
 @param tableName 表的名称
 @param object 要插入的数据,可以是自定义对象或dictionary
 @return 是否插入成功
 */
- (BOOL)lf_insertWithTableName:(NSString *)tableName object:(id)object;

/**
 删除
 
 @param tableName 表的名称
 @param format 条件语句, 如:@"where name = '小李'"
 @return 是否删除成功
 */
- (BOOL)lf_deleteWithTableName:(NSString *)tableName whereFormat:(NSString *)format, ...;

/**
 更新
 
 @param tableName 表的名称
 @param object 要更改的数据,可以是自定义对象或dictionary
 @param format 条件语句, 如:@"where name = '小李'"
 @return 是否更改成功
 */
- (BOOL)lf_updateWithTableName:(NSString *)tableName object:(id)object whereFormat:(NSString *)format, ...;

/**
 查找
 
 @param tableName 表的名称
 @param object 自定义对像的类名(@"Person")、类([Person class])、实例或dictionary，查询的每条结果放到这个自定义对象或字典中
 @param format 条件语句, 如:@"where name = '小李'",
 @return 将结果存入array,数组中的元素的类型为object的类型
 */
- (NSArray *)lf_queryWithTableName:(NSString *)tableName object:(id)object whereFormat:(NSString *)format, ...;

/**
 批量插入或更改
 
 @param dicOrModelArray 要insert数据的数组,也可以将model和dictionary混合装入array
 @return 返回的数组存储未插入成功的下标,数组中元素类型为NSNumber
 */
- (NSArray *)lf_insertWithTableName:(NSString *)tableName dicOrModelArray:(NSArray *)dicOrModelArray;

/**
 根据自定义类增加新字段,该操作已在事务中执行
 
 @param tableName 表的名称
 @param object 自定义对像的类名(@"Person")、类([Person class])、实例
 @param nameArr 不允许生成字段的属性名的数组
 @return 是否成功
 */
- (BOOL)lf_alterTableWithTableName:(NSString *)tableName object:(id)object ignoreName:(NSArray *)nameArr;


/**
 根据字典增加新字段,该操作已在事务中执行

 @param tableName 表的名称
 @param dic 格式为@{@"newname":@"TEXT"}
 @return 是否成功
 */
- (BOOL)lf_alterTableWithTableName:(NSString *)tableName dictionary:(NSDictionary *)dic;

/**删除表*/
- (BOOL)lf_deleteTable:(NSString *)tableName;

/**清空表*/
- (BOOL)lf_deleteAllDataWithTableName:(NSString *)tableName;

/**是否存在表*/
- (BOOL)lf_isExistTable:(NSString *)tableName;

/**表中共有多少条数据*/
- (int)lf_tableItemCountWithTableName:(NSString *)tableName;


#pragma mark - 线程安全

/**多线程*/
- (void)lf_inDatabase:(void(^)(FMDatabase *db))block;

/**事物*/
- (void)lf_inTransaction:(void(^)(FMDatabase *db, BOOL *rollback))block;


@end
