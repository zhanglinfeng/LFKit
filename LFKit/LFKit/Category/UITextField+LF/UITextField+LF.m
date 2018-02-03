//
//  UITextField+LF.m
//  APPBaseSDK
//
//  Created by 张林峰 on 16/6/9.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import "UITextField+LF.h"
#import <objc/runtime.h>

static void *maxLengthKey = &maxLengthKey;

@implementation UITextField (LF)

- (void)shake {
    CGPoint y = CGPointMake(self.layer.position.x-10, self.layer.position.y);
    CGPoint x = CGPointMake(self.layer.position.x+10, self.layer.position.y);
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    [self.layer addAnimation:animation forKey:nil];
}

- (void)setMaxLength:(NSNumber *)maxLength {
    objc_setAssociatedObject(self, &maxLengthKey, maxLength, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (NSNumber *)maxLength {
    return objc_getAssociatedObject(self, &maxLengthKey);
}


- (void)textFieldDidChange:(UITextField *)textField {
    NSNumber * nlength = self.maxLength;
    NSInteger maxLength = nlength.integerValue;
    if (textField.text.length > maxLength) {
        UITextRange *markedRange = [textField markedTextRange];
        if (markedRange) {
            return;
        }
        //Emoji占2个字符，如果是超出了半个Emoji，用maxLength位置来截取会出现Emoji截为2半
        //超出最大长度的那个字符序列(Emoji算一个字符序列)的range
        NSRange range = [textField.text rangeOfComposedCharacterSequenceAtIndex:maxLength];
        textField.text = [textField.text substringToIndex:range.location];
    }
}

@end
