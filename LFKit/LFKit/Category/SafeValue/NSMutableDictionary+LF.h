//
//  NSMutableDictionary+LF.h
//  LFKit
//
//  Created by 张林峰 on 2018/10/28.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary (LF)

- (void)lf_setObject:(id)obj forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
