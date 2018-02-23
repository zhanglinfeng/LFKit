//
//  LFModel.h
//  LeanFish
//
//  Created by 张林峰 on 2018/2/3.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SqlText @"text" //数据库的字符类型
#define SqlReal @"real" //数据库的浮点类型
#define SqlInteger @"integer" //数据库的整数类型
#define SqlBlob @"blob" //数据库的二进制类型


@interface LFModel : NSObject <NSCoding>

/**获取类的属性*/
+(NSMutableDictionary*)getClassIvarList:(__unsafe_unretained Class)cla;

/**获取类及父类的属性*/
+(NSDictionary*)getClassAndSuperClassIvarList:(__unsafe_unretained Class)cla;

/**对象转字典*/
+ (NSDictionary *)getDicFromModel:(id)model;

/**属性类型转数据库类型*/
+(NSString*)getSqlTypeFromPropertyType:(NSString*)type;


@end
