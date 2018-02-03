//
//  LFJsonUtil.m
//  BaseAPP
//
//  Created by 张林峰 on 16/1/26.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import "LFJsonUtil.h"

@implementation LFJsonUtil

+ (id)objectFromJSONString:(NSString *)string {
    
    id result = nil;
    result = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)] options:0 error:nil];
    if (result == nil) {
        // 后台的JSON错了，尝试修正
        NSString *possibleJson = [self stringByHealJSONString:string];
        result = [NSJSONSerialization JSONObjectWithData:[possibleJson dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)] options:0 error:nil];
    }
    return result;
}

+ (NSString *)stringByHealJSONString:(NSString *)string
{
    NSMutableString *mStr = [[NSMutableString alloc]initWithCapacity:string.length];
    // 处理所有需要escape的字符
    for(int i=0; i< string.length; i++){
        unichar c = [string characterAtIndex:i];
        NSString *s = [NSString stringWithCharacters:&c length:1];
        switch (c) {
            case '\b':
                [mStr appendString:@"\\b"];
                break;
            case '\f':
                [mStr appendString:@"\\f"];
                break;
            case '\n':
                [mStr appendString:@"\\n"];
                break;
            case '\r':
                [mStr appendString:@"\\r"];
                break;
            case '\t':
                [mStr appendString:@"\\t"];
                break;
            case '\v':
                [mStr appendString:@"\\v"];
                break;
            default:
                [mStr appendString:s];
                break;
        }
    }
    return mStr;
}

+ (id)objectFromJSONData:(NSData *)data {
    id result = nil;
    result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (result == nil) {
        //可能后台JSON有问题，尝试修复
        NSString *originalString = [[NSString alloc]initWithData:data encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
        result = [self objectFromJSONString:originalString];
    }
    
    return result;
}

+ (id)objectFromJSONData:(NSData *)data UsingEncoding:(NSStringEncoding)encoding {
    NSString *jsonString = [[NSString alloc]initWithData:data encoding:encoding];
    NSData *transformedData = [jsonString dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    
    return [self objectFromJSONData:transformedData];
}

/**dict或arrayz转json */
- (NSString *)jsonFromObject:(id)object {
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if (!error) {
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    return @"";
}

@end
