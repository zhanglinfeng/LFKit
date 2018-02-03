//
//  LFSegmentDefaultConfig.m
//  LFKit
//
//  Created by 张林峰 on 2018/2/3.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import "LFSegmentDefaultConfig.h"

@implementation LFSegmentDefaultConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectedColor = [UIColor redColor];
        self.normalColor = [UIColor grayColor];
        self.indicateColor = self.selectedColor;
        self.indicateHeight = 2;
        self.minItemSpace = 20;
        self.font = [UIFont systemFontOfSize:16];
    }
    return self;
}

+ (instancetype)sharedInstance {
    static LFSegmentDefaultConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
    });
    return instance;
}

@end
