//
//  UILabel+LF.m
//  BaseAPP
//
//  Created by 张林峰 on 16/1/29.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import "UILabel+LF.h"
#import <objc/runtime.h>

static void *tipNumberKey = &tipNumberKey;

@implementation UILabel (LF)

- (NSString *)tipNumber {
    return objc_getAssociatedObject(self, &tipNumberKey);
}

-(void)setTipNumber:(NSString *)tipNumber {
    objc_setAssociatedObject(self, & tipNumberKey, tipNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//消息数量，有值时将显示为红色椭圆label
-(void)layoutSubviews {
    [super layoutSubviews];
    if (self.tipNumber) {
        self.backgroundColor = [UIColor redColor];
        self.textColor = [UIColor whiteColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.hidden = self.tipNumber.length < 1 ? YES : NO;
        if ([self.tipNumber isEqualToString:@"0"]) {
            self.hidden = YES;
        } 
        if (self.tipNumber.length > 2) {
            self.tipNumber = @"99+";
        }
        if ([self.tipNumber isEqualToString:@"-1"]) {
            self.tipNumber = @"";
            CGRect frame = self.frame;
            frame.size.width = 10;
            frame.size.height = 10;
            self.frame = frame;
        }
        
        self.text = self.tipNumber;
        float radius = self.frame.size.height < self.frame.size.width ? self.frame.size.height : self.frame.size.width;
        self.clipsToBounds = YES;
        self.layer.cornerRadius = radius / 2.0f;
    }
}


/**正数加前缀“＋”，颜色红；负数颜色绿；空值当0处理*/
- (void)setColorNumberText:(NSString *)text {
    text = text.length > 0 ? text : @"0";
    if (text.floatValue > 0) {
        self.text = [NSString stringWithFormat:@"+%0.1f",text.floatValue];
        self.textColor = [UIColor redColor];
    } else if(text.floatValue < 0) {
        self.text = [NSString stringWithFormat:@"%0.1f",text.floatValue];
        self.textColor = [UIColor greenColor];
    } else {
        self.text = [NSString stringWithFormat:@"%0.1f",text.floatValue];
    }
}

/**正数加前缀“＋”；空值当0处理*/
-(void)setNumberText:(NSString *)text {
    text = text.length > 0 ? text : @"0";
    if (text.floatValue > 0) {
        self.text = [NSString stringWithFormat:@"+%0.1f",text.floatValue];
    } else {
        self.text = [NSString stringWithFormat:@"%0.1f",text.floatValue];
    }
}

/**正数加前缀“＋”，颜色红；负数颜色绿*/
- (void)setColorNumber:(float)number {
    if (number > 0) {
        self.text = [NSString stringWithFormat:@"+%0.1f",number];
        self.textColor = [UIColor redColor];
    } else if (number < 0) {
        self.text = [NSString stringWithFormat:@"%0.1f",number];
        self.textColor = [UIColor greenColor];
    } else {
        self.text = [NSString stringWithFormat:@"%0.1f",number];
    }
}

/**正数加前缀“＋”*/
-(void)setNumber:(float)number {
    if (number > 0) {
        self.text = [NSString stringWithFormat:@"+%0.1f",number];
    } else {
        self.text = [NSString stringWithFormat:@"%0.1f",number];
    }
}


@end
