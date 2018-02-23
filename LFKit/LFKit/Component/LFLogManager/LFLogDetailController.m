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

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (@available(iOS 11.0, *)) {
        self.textView.frame = CGRectMake(0, self.view.safeAreaInsets.top, self.view.frame.size.width, self.view.frame.size.height - self.view.safeAreaInsets.top);
    } else {
        self.textView.frame = self.view.bounds;
    }
}

@end
