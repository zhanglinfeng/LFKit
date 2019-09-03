//
//  LFTextViewExampleVC.m
//  LFKit
//
//  Created by 张林峰 on 2019/9/3.
//  Copyright © 2019 张林峰. All rights reserved.
//

#import "LFTextViewExampleVC.h"
#import "UITextView+LF.h"

@interface LFTextViewExampleVC ()

@end

@implementation LFTextViewExampleVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(20, 100, self.view.frame.size.width - 40, 300)];
    tv.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tv.font = [UIFont systemFontOfSize:13];
    
//    tv.placeholderColor = [UIColor redColor];
    tv.placeholderFont = [UIFont systemFontOfSize:16];
//    tv.countColor = [UIColor greenColor];
    tv.countFont = [UIFont systemFontOfSize:18];
    tv.maxCount = @(8);
//    tv.isLimit = @YES;
//    tv.text = @"123456789";
    [self.view addSubview:tv];
    
    tv.placeholder = @"请输入内容";
    
    __block UITextView *btv = tv;
    tv.textDidChangeBlock = ^(NSString * _Nonnull text, BOOL isOut) {
        if (isOut) {
            btv.countColor = [UIColor redColor];
        } else {
            btv.countColor = [UIColor lightGrayColor];
        }
    };
}


@end
