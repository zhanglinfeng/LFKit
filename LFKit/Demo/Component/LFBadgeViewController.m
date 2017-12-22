//
//  LFBadgeViewController.m
//  LFKit
//
//  Created by 张林峰 on 2017/11/24.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import "LFBadgeViewController.h"
#import "LFBadge.h"

@interface LFBadgeViewController ()
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UITextField *tf;
@property (strong, nonatomic) LFBadge *badge1;
@property (strong, nonatomic) LFBadge *badge2;
@property (strong, nonatomic) LFBadge *badge3;
@property (strong, nonatomic) IBOutlet LFBadge *badge4;//在xib上，0行代码即可接入使用，请忽视xib上的约束错误，因为在内部用代码加过约束

@end

@implementation LFBadgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _badge1 = [[LFBadge alloc] init];
    [_badge1 addToView:self.view1];
    _badge1.type = LFBadgeType_RightTop;
    _badge1.clearBlock = ^{
        NSLog(@"清除未读消息角标");
    };
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setCount)];
    self.navigationItem.rightBarButtonItem = barItem;
    
    //延时一会才能拿到barItem
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _badge2 = [[LFBadge alloc] init];
        _badge2.type = LFBadgeType_RightTop;
        [_badge2 addToBarButtonItem:barItem];
  
    });
    
    _badge3 = [[LFBadge alloc] init];
    [_badge3 addToTabBarItem:self.navigationController.tabBarItem];
    
    _badge4.clearBlock = ^{
        NSLog(@"清除未读消息角标");
    };

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCount {
    
}
- (IBAction)ok:(id)sender {
    _badge1.count = _tf.text;
    _badge2.count = _tf.text;
    _badge3.count = _tf.text;
    _badge4.count = _tf.text;
    [self.view endEditing:YES];
    
    if ([_tf.text isEqualToString:@""]) {//红点
        _badge2.edgeInsets = UIEdgeInsetsMake(5, 0, 0, 2);
    } else {//数字
        _badge2.edgeInsets = UIEdgeInsetsZero;
    }
}



@end

