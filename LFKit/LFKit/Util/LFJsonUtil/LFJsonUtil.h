//
//  LFJsonUtil.h
//  BaseAPP
//
//  Created by 张林峰 on 16/1/26.
//  Copyright © 2016年 张林峰. All rights reserved.
//
//本类功能：各种json类型转dict或array

#import <Foundation/Foundation.h>

@interface LFJsonUtil : NSObject

/**json字符串转dict或array*/
+ (id)objectFromJSONString:(NSString *)string;

/**json的NSData转dict或array*/
+ (id)objectFromJSONData:(NSData *)data;

/**json的NSData转dict或array,带编码参数*/ 
+ (id)objectFromJSONData:(NSData *)data UsingEncoding:(NSStringEncoding)encoding;

/**dict或arrayz转json */
+ (NSString *)jsonFromObject:(id)object;

@end
