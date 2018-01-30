//
//  FMDatabase+LF.m
//  LFKit
//
//  Created by 张林峰 on 2018/1/30.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import "FMDatabase+LF.h"
#import <objc/runtime.h>

// 数据库中常见的几种类型
#define SQL_TEXT     @"TEXT" //文本
#define SQL_INTEGER  @"INTEGER" //int long integer ...
#define SQL_REAL     @"REAL" //浮点
#define SQL_BLOB     @"BLOB" //data

@implementation FMDatabase (LF)

+ (instancetype)databaseWithName:(NSString *)name {
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
    NSString *filePath = [doc stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",name]];
   return [self databaseWithPath:filePath];
}

- (BOOL)lf_createTable:(NSString *)tableName class:(Class)modelClass pkId:(NSString *)pk excludeName:(NSArray *)nameArr {
    NSDictionary *dic = [self getDicFromClass:modelClass excludePropertyName:nameArr];
    
    NSMutableString *fieldStr = [[NSMutableString alloc] initWithFormat:@"CREATE TABLE %@ (pk INTEGER PRIMARY KEY,", tableName];
    if (pk.length < 1) {
        fieldStr = [[NSMutableString alloc] initWithFormat:@"CREATE TABLE %@ (id integer PRIMARY KEY AUTOINCREMENT,", tableName];
    }
    
    int keyCount = 0;
    for (NSString *key in dic) {
        
        keyCount++;
        if ((nameArr && [nameArr containsObject:key]) || [key isEqualToString:@"pkid"]) {
            continue;
        }
        if (keyCount == dic.count) {
            [fieldStr appendFormat:@" %@ %@)", key, dic[key]];
            break;
        }
        
        [fieldStr appendFormat:@" %@ %@,", key, dic[key]];
    }
    
    BOOL creatFlag;
    creatFlag = [self executeUpdate:fieldStr];
    
    return creatFlag;
}

- (NSDictionary *)getDicFromClass:(Class)cls excludePropertyName:(NSArray *)nameArr {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithCapacity:0];
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        
        NSString *name = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
        if ([nameArr containsObject:name]) continue;
        
        NSString *type = [NSString stringWithCString:property_getAttributes(properties[i]) encoding:NSUTF8StringEncoding];
        
        id value = [self propertTypeConvert:type];
        if (value) {
            [mDic setObject:value forKey:name];
        }
        
    }
    free(properties);
    
    return mDic;
}

- (NSString *)propertTypeConvert:(NSString *)typeStr {
    NSString *resultStr = nil;
    if ([typeStr hasPrefix:@"T@\"NSString\""]) {
        resultStr = SQL_TEXT;
    } else if ([typeStr hasPrefix:@"T@\"NSData\""]) {
        resultStr = SQL_BLOB;
    } else if ([typeStr hasPrefix:@"Ti"]||[typeStr hasPrefix:@"TI"]||[typeStr hasPrefix:@"Ts"]||[typeStr hasPrefix:@"TS"]||[typeStr hasPrefix:@"T@\"NSNumber\""]||[typeStr hasPrefix:@"TB"]||[typeStr hasPrefix:@"Tq"]||[typeStr hasPrefix:@"TQ"]) {
        resultStr = SQL_INTEGER;
    } else if ([typeStr hasPrefix:@"Tf"] || [typeStr hasPrefix:@"Td"]){
        resultStr= SQL_REAL;
    }
    
    return resultStr;
}

@end
