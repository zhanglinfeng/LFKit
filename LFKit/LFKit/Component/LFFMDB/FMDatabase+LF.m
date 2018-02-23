//
//  FMDatabase+LF.m
//  LeanFish
//
//  Created by 张林峰 on 2018/1/31.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import "FMDatabase+LF.h"
#import <objc/runtime.h>
#import "LFModel.h"

//// 数据库中常见的几种类型
//#define SQL_TEXT     @"TEXT" //文本
//#define SQL_INTEGER  @"INTEGER" //int long integer
//#define SQL_REAL     @"REAL" //浮点
//#define SQL_BLOB     @"BLOB" //data

static void *lf_pathKey = &lf_pathKey;

@interface FMDatabase ()

@property (nonatomic, strong) NSString *lf_path;//数据库路径

@end

@implementation FMDatabase (LF)

- (NSString *)lf_path {
    return objc_getAssociatedObject(self, &lf_pathKey);
}

-(void)setLf_path:(NSString *)lf_path {
    objc_setAssociatedObject(self, & lf_pathKey, lf_path, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (instancetype)databaseWithName:(NSString *)name {
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
    NSString *filePath = [doc stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",name]];
    FMDatabase *db = [self databaseWithPath:filePath];
    db.lf_path = filePath;
    return db;
}

- (NSString*)lf_getPath {
    return self.lf_path;
}

- (BOOL)lf_createTable:(Class)modelClass pkId:(NSString *)pkId ignoreName:(NSArray *)nameArr {
    NSDictionary *dic = [LFModel getClassAndSuperClassIvarList:modelClass];
    NSString *tableName = NSStringFromClass(modelClass);
    NSMutableString *fieldStr = [[NSMutableString alloc] initWithFormat:@"CREATE TABLE %@ (%@ INTEGER PRIMARY KEY,", tableName, pkId];
    if (pkId.length < 1) {
        pkId = @"id";
        fieldStr = [[NSMutableString alloc] initWithFormat:@"CREATE TABLE %@ (id integer PRIMARY KEY AUTOINCREMENT,", tableName];
    }
    
    int keyCount = 0;
    for (NSString *key in dic) {
        keyCount++;
        if ((nameArr && [nameArr containsObject:key]) || [key isEqualToString:pkId]) {
            continue;
        }
        NSString *type = dic[key];
        type = [LFModel getSqlTypeFromPropertyType:type];
        if (keyCount == dic.count) {
            [fieldStr appendFormat:@" %@ %@)", key, type];
            break;
        }
        [fieldStr appendFormat:@" %@ %@,", key, type];
    }
    
    BOOL creatFlag;
    creatFlag = [self executeUpdate:fieldStr];
    
    return creatFlag;
}

- (BOOL)lf_insertWithTableName:(NSString *)tableName object:(id)object {
    NSArray *columnArr = [self getColumnArr:tableName];
    BOOL flag;
    NSDictionary *dic;
    if ([object isKindOfClass:[NSDictionary class]]) {
        dic = object;
    }else {
        dic = [LFModel getDicFromModel:object];
    }
    
    NSMutableString *finalStr = [[NSMutableString alloc] initWithFormat:@"INSERT INTO %@ (", tableName];
    NSMutableString *tempStr = [NSMutableString stringWithCapacity:0];
    NSMutableArray *argumentsArr = [NSMutableArray arrayWithCapacity:0];
    
    for (NSString *key in dic) {
        
        if (![columnArr containsObject:key]) {
            continue;
        }
        [finalStr appendFormat:@"%@,", key];
        [tempStr appendString:@"?,"];
        
        [argumentsArr addObject:dic[key]];
    }
    
    [finalStr deleteCharactersInRange:NSMakeRange(finalStr.length-1, 1)];
    if (tempStr.length)
        [tempStr deleteCharactersInRange:NSMakeRange(tempStr.length-1, 1)];
    
    [finalStr appendFormat:@") values (%@)", tempStr];
    
    flag = [self executeUpdate:finalStr withArgumentsInArray:argumentsArr];
    return flag;
}

- (BOOL)lf_deleteWithTableName:(NSString *)tableName whereFormat:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    NSString *where = format?[[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:args]:format;
    va_end(args);
    BOOL flag;
    NSMutableString *finalStr = [[NSMutableString alloc] initWithFormat:@"delete from %@ %@", tableName,where];
    flag = [self executeUpdate:finalStr];
    
    return flag;
}

- (BOOL)lf_updateWithTableName:(NSString *)tableName object:(id)object whereFormat:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    NSString *where = format?[[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:args]:format;
    va_end(args);
    BOOL flag;
    NSDictionary *dic;
    NSArray *columnArr = [self getColumnArr:tableName];
    if ([object isKindOfClass:[NSDictionary class]]) {
        dic = object;
    }else {
        dic = [LFModel getDicFromModel:object];
    }
    
    NSMutableString *finalStr = [[NSMutableString alloc] initWithFormat:@"update %@ set ", tableName];
    NSMutableArray *argumentsArr = [NSMutableArray arrayWithCapacity:0];
    
    for (NSString *key in dic) {
        
        if (![columnArr containsObject:key]) {
            continue;
        }
        [finalStr appendFormat:@"%@ = %@,", key, @"?"];
        [argumentsArr addObject:dic[key]];
    }
    
    [finalStr deleteCharactersInRange:NSMakeRange(finalStr.length-1, 1)];
    if (where.length) [finalStr appendFormat:@" %@", where];
    
    
    flag =  [self executeUpdate:finalStr withArgumentsInArray:argumentsArr];
    
    return flag;
}


- (NSArray *)lf_queryWithTableName:(NSString *)tableName object:(id)object whereFormat:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *where = format?[[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:args]:format;
    va_end(args);
    NSMutableArray *resultMArr = [NSMutableArray arrayWithCapacity:0];
    NSDictionary *dic;
    NSMutableString *finalStr = [[NSMutableString alloc] initWithFormat:@"select * from %@ %@", tableName, where?where:@""];
    NSArray *clomnArr = [self getColumnArr:tableName];
    
    FMResultSet *set = [self executeQuery:finalStr];
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        dic = object;
        while ([set next]) {
            NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithCapacity:0];
            for (NSString *key in dic) {
                
                if ([dic[key] isEqualToString:SqlText]) {
                    id value = [set stringForColumn:key];
                    if (value)
                        [resultDic setObject:value forKey:key];
                } else if ([dic[key] isEqualToString:SqlInteger]) {
                    [resultDic setObject:@([set longLongIntForColumn:key]) forKey:key];
                } else if ([dic[key] isEqualToString:SqlReal]) {
                    [resultDic setObject:[NSNumber numberWithDouble:[set doubleForColumn:key]] forKey:key];
                } else if ([dic[key] isEqualToString:SqlBlob]) {
                    id value = [set dataForColumn:key];
                    NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:value];
                    if (dic) {
                        value = dic;
                    }
                    if (value)
                        [resultDic setObject:value forKey:key];
                }
            }
            if (resultDic) [resultMArr addObject:resultDic];
        }
        
    } else {
        Class CLS;
        if ([object isKindOfClass:[NSString class]]) {
            if (!NSClassFromString(object)) {
                CLS = nil;
            } else {
                CLS = NSClassFromString(object);
            }
        } else if ([object isKindOfClass:[NSObject class]]) {
            CLS = [object class];
        } else {
            CLS = object;
        }
        
        if (CLS) {
            NSDictionary *propertyDic = [LFModel getClassAndSuperClassIvarList:CLS];
            while ([set next]) {
                id model = CLS.new;
                for (NSString *name in clomnArr) {
                    NSString *type = [LFModel getSqlTypeFromPropertyType:propertyDic[name]];
                    if ([type isEqualToString:SqlText]) {
                        id value = [set stringForColumn:name];
                        if (value)
                            [model setValue:value forKey:name];
                    } else if ([type isEqualToString:SqlInteger]) {
                        [model setValue:@([set longLongIntForColumn:name]) forKey:name];
                    } else if ([type isEqualToString:SqlReal]) {
                        [model setValue:[NSNumber numberWithDouble:[set doubleForColumn:name]] forKey:name];
                    } else if ([type isEqualToString:SqlBlob]) {
                        id value = [set dataForColumn:name];
                        NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:value];
                        if (dic) {
                            value = dic;
                        }
                        if (value)
                            [model setValue:value forKey:name];
                    }
                }
                [resultMArr addObject:model];
            }
        }
    }
    return resultMArr;
}

// 直接传一个array插入
- (NSArray *)lf_insertWithTableName:(NSString *)tableName dicOrModelArray:(NSArray *)dicOrModelArray {
    int errorIndex = 0;
    NSMutableArray *resultMArr = [NSMutableArray arrayWithCapacity:0];
    for (id object in dicOrModelArray) {
        
        BOOL flag = [self lf_insertWithTableName:tableName object:object];
        if (!flag) {
            [resultMArr addObject:@(errorIndex)];
        }
        errorIndex++;
    }
    return resultMArr;
}

- (BOOL)lf_alterTableWithTableName:(NSString *)tableName object:(id)object ignoreName:(NSArray *)nameArr {
    __block BOOL flag;
    
    [self lf_inTransaction:^(FMDatabase *db, BOOL *rollback) {
        Class CLS;
        if ([object isKindOfClass:[NSString class]]) {
            if (!NSClassFromString(object)) {
                CLS = nil;
            } else {
                CLS = NSClassFromString(object);
            }
        } else if ([object isKindOfClass:[NSObject class]]) {
            CLS = [object class];
        } else {
            CLS = object;
        }
        NSDictionary *propertyDic = [LFModel getClassAndSuperClassIvarList:CLS];
        NSArray *columnArr = [self getColumnArr:tableName];
        for (NSString *key in propertyDic) {
            NSString *type = [LFModel getSqlTypeFromPropertyType:propertyDic[key]];
            if (![columnArr containsObject:key] && ![nameArr containsObject:key]) {
                flag = [self executeUpdate:[NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@", tableName, key, type]];
                if (!flag) {
                    *rollback = YES;
                    return;
                }
            }
        }
    }];
    return flag;
}

- (BOOL)lf_alterTableWithTableName:(NSString *)tableName dictionary:(NSDictionary *)dic {
    __block BOOL flag;
    [self lf_inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (NSString *key in dic) {
            flag = [self executeUpdate:[NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@", tableName, key, dic[key]]];
            if (!flag) {
                *rollback = YES;
                return;
            }
        }
    }];
    
    return flag;
}

- (BOOL)lf_deleteTable:(NSString *)tableName {
    NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
    if (![self executeUpdate:sqlstr])
    {
        return NO;
    }
    return YES;
}

- (BOOL)lf_deleteAllDataWithTableName:(NSString *)tableName {
    NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    if (![self executeUpdate:sqlstr]) {
        return NO;
    }
    return YES;
}

- (BOOL)lf_isExistTable:(NSString *)tableName {
    
    FMResultSet *set = [self executeQuery:@"SELECT count(*) as 'count' FROM sqlite_master WHERE type ='table' and name = ?", tableName];
    while ([set next]) {
        NSInteger count = [set intForColumn:@"count"];
        if (count == 0) {
            return NO;
        } else {
            return YES;
        }
    }
    return NO;
}

- (int)lf_tableItemCountWithTableName:(NSString *)tableName {
    NSString *sqlstr = [NSString stringWithFormat:@"SELECT count(*) as 'count' FROM %@", tableName];
    FMResultSet *set = [self executeQuery:sqlstr];
    while ([set next])
    {
        return [set intForColumn:@"count"];
    }
    return 0;
}

#pragma mark - 私有方法

// 得到表里的字段名称
- (NSArray *)getColumnArr:(NSString *)tableName {
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
    FMResultSet *resultSet = [self getTableSchema:tableName];
    while ([resultSet next]) {
        [mArr addObject:[resultSet stringForColumn:@"name"]];
    }
    
    return mArr;
}

#pragma mark - 线程安全

- (void)lf_inDatabase:(void(^)(FMDatabase *db))block {
    FMDatabaseQueue *dbq = [FMDatabaseQueue databaseQueueWithPath:self.lf_path];
    [dbq inDatabase:block];
}

- (void)lf_inTransaction:(void(^)(FMDatabase *db, BOOL *rollback))block {
    FMDatabaseQueue *dbq = [FMDatabaseQueue databaseQueueWithPath:self.lf_path];
    [dbq inTransaction:block];
    
}

@end
