//
//  LFLogDetailController.m
//  BaseAPP
//
//  Created by 张林峰 on 2017/11/1.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import "LFLogDetailController.h"

@interface LFLogDetailController ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation LFLogDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.textView.editable = NO;
    self.textView.text = self.logText;
    [self.view addSubview:self.textView];
}

@end
