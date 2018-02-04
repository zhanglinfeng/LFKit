//
//  LFPopupMenuDefaultConfig.m
//  LFKit
//
//  Created by 张林峰 on 2018/2/3.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import "LFPopupMenuDefaultConfig.h"
#import <objc/runtime.h>

@implementation LFPopupMenuDefaultConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.rowHeight = 50;
        self.arrowH = 9;
        self.arrowW = 9;
        self.popupMargin = 5;
        self.leftEdgeMargin = 16;
        self.rightEdgeMargin = 16;
        self.textMargin = 8;
        self.cornerRadius = 6;
        self.arrowCornerRadius = 0;
        self.lineColor = [UIColor grayColor];
        self.textFont = [UIFont systemFontOfSize:15];
        self.textColor = [UIColor blackColor];
        self.fillColor = [UIColor whiteColor];
        self.needBorder =NO;
    }
    return self;
}

+ (instancetype)sharedInstance {
    static LFPopupMenuDefaultConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
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
