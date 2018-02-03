//
//  LFBubbleViewDefaultConfig.m
//  LFKit
//
//  Created by 张林峰 on 2018/2/3.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import "LFBubbleViewDefaultConfig.h"
#import <objc/runtime.h>

@implementation LFBubbleViewDefaultConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.color = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:12];
        self.cornerRadius = 5;
        self.triangleH = 7;
        self.triangleW = 7;
        self.edgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    }
    return self;
}

static LFBubbleViewDefaultConfig *_instance = nil;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    id obj = [[[self class] allocWithZone:zone] init];
    
    Class class = [self class];
    unsigned int count = 0;
    //获取类中所有成员变量名
    Ivar *ivar = class_copyIvarList(class, &count);
    for (int i = 0; i < count; i++) {
        Ivar iva = ivar[i];
        const char *name = ivar_getName(iva);
        NSString *strName = [NSString stringWithUTF8String:name];
        //进行解档取值
        //            id value = [decoder decodeObjectForKey:strName];
        id value = [self valueForKey:strName];
        //利用KVC对属性赋值
        [obj setValue:value forKey:strName];
    }
    free(ivar);
    
    return obj;
}

@end
