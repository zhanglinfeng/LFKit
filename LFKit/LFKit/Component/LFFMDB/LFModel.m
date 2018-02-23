//
//  LFModel.m
//  LeanFish
//
//  Created by 张林峰 on 2018/2/3.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import "LFModel.h"
#import <objc/runtime.h>
#import <CoreData/CoreData.h>



@implementation LFModel

- (void)encodeWithCoder:(NSCoder *)encoder {
    Class class = [self class];
    while (class != [NSObject class]) {
        unsigned int count;
        Ivar *ivar = class_copyIvarList(class, &count);
        for (int i = 0; i < count; i++) {
            Ivar iv = ivar[i];
            const char *name = ivar_getName(iv);
            NSString *strName = [NSString stringWithUTF8String:name];
            //利用KVC取值
            id value = [self valueForKey:strName];
            [encoder encodeObject:value forKey:strName];
        }
        free(ivar);
        
        class = class_getSuperclass(class);
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        
        Class class = [self class];
        while (class != [NSObject class]) {
            unsigned int count = 0;
            //获取类中所有成员变量名
            Ivar *ivar = class_copyIvarList(class, &count);
            for (int i = 0; i < count; i++) {
                Ivar iva = ivar[i];
                const char *name = ivar_getName(iva);
                NSString *strName = [NSString stringWithUTF8String:name];
                //进行解档取值
                id value = [decoder decodeObjectForKey:strName];
                //利用KVC对属性赋值
                [self setValue:value forKey:strName];
            }
            free(ivar);
            
            class = class_getSuperclass(class);
        }
    }
    return self;
}



#pragma mark - 类方法
/**获取类的属性*/
+(NSMutableDictionary*)getClassIvarList:(__unsafe_unretained Class)cla {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    unsigned int numIvars; //成员变量个数
    Ivar *vars = class_copyIvarList(cla, &numIvars);
    for(int i = 0; i < numIvars; i++) {
        Ivar thisIvar = vars[i];
        NSString* name = [NSString stringWithUTF8String:ivar_getName(thisIvar)];//获取成员变量的名
        if ([name hasPrefix:@"_"]) {
            name = [name substringFromIndex:1];
        }
        NSString* type = [NSString stringWithUTF8String:ivar_getTypeEncoding(thisIvar)];
        
        dic[name] = type;
    }
    free(vars);//释放资源
    
    return dic;
}

/**获取类及父类的属性*/
+(NSDictionary*)getClassAndSuperClassIvarList:(__unsafe_unretained Class)cla {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    Class c = cla;
    while (c) {
        NSMutableDictionary *sDic = [LFModel getClassIvarList:c];
        [dic addEntriesFromDictionary:sDic];
        c = class_getSuperclass(c);
        if ([self isClassFromFoundation:c]) break;
    }
    return dic;
}

/**对象转字典*/
+ (NSDictionary *)getDicFromModel:(id)model {

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    unsigned int numIvars; //成员变量个数
    Ivar *vars = class_copyIvarList([model class], &numIvars);
    for(int i = 0; i < numIvars; i++) {
        Ivar thisIvar = vars[i];
        NSString* name = [NSString stringWithUTF8String:ivar_getName(thisIvar)];//获取成员变量的名
        if ([name hasPrefix:@"_"]) {
            name = [name substringFromIndex:1];
        }
        id value = [model valueForKey:name];
        NSString* type = [NSString stringWithUTF8String:ivar_getTypeEncoding(thisIvar)];
        NSString *sqlType = [LFModel getSqlTypeFromPropertyType:type];
        if ([sqlType isEqualToString:SqlBlob] && ![value isKindOfClass:[NSData class]]) {
            NSData * data = [NSKeyedArchiver archivedDataWithRootObject:value];
            value = data;
        }
        dic[name] = value;
    }
    free(vars);//释放资源
    
    return dic;
}

/**属性类型转数据库类型*/
+(NSString*)getSqlTypeFromPropertyType:(NSString*)type {
    if([type isEqualToString:@"i"]||[type isEqualToString:@"I"]||
       [type isEqualToString:@"s"]||[type isEqualToString:@"S"]||
       [type isEqualToString:@"q"]||[type isEqualToString:@"Q"]||
       [type isEqualToString:@"b"]||[type isEqualToString:@"B"]||
       [type isEqualToString:@"c"]||[type isEqualToString:@"C"]|
       [type isEqualToString:@"l"]||[type isEqualToString:@"L"]) {
        return SqlInteger;
    } else if([type isEqualToString:@"f"]||[type isEqualToString:@"F"]||
              [type isEqualToString:@"d"]||[type isEqualToString:@"D"]){
        return SqlReal;
    } else if ([type containsString:@"NSString"]) {
        return SqlText;
    } else {
        return SqlBlob;
    }
}


#pragma mark - 私有方法

/**是否是基础类*/
+ (BOOL)isClassFromFoundation:(Class)c {
    // 集合中没有NSObject，因为几乎所有的类都是继承自NSObject，具体是不是NSObject需要特殊判断
    NSSet * foundationClasses = [NSSet setWithObjects:
                                 [NSURL class],
                                 [NSDate class],
                                 [NSValue class],
                                 [NSData class],
                                 [NSError class],
                                 [NSArray class],
                                 [NSDictionary class],
                                 [NSString class],
                                 [NSAttributedString class], nil];
    
    if (c == [NSObject class] || c == [NSManagedObject class]) return YES;
    __block BOOL result = NO;
    [foundationClasses enumerateObjectsUsingBlock:^(Class foundationClass, BOOL *stop) {
        if ([c isSubclassOfClass:foundationClass]) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}

@end
