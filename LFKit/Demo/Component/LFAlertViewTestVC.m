//
//  LFAlertViewTestVC.m
//  LFKit
//
//  Created by 张林峰 on 2019/2/23.
//  Copyright © 2019 张林峰. All rights reserved.
//

#import "LFAlertViewTestVC.h"
#import "LFAlertView.h"

@interface LFAlertViewTestVC ()

@end

@implementation LFAlertViewTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)alert1:(id)sender {
    
    LFAlertView *alert = [[LFAlertView alloc] initWithTitle:@"提示" message:@"温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示" style:LFAlertViewAlert];
    alert.maxHeight = self.view.frame.size.height - 120;
    alert.buttonTitleArray = @[@"ok"];
    alert.clickBlock = ^(UIButton * _Nonnull button) {
        NSLog(@"点击了%@",button.currentTitle);
    };
    
    [alert show];
    
}



- (IBAction)alert2:(id)sender {
    
    LFAlertView *alert = [[LFAlertView alloc] initWithTitle:@"提示" message:nil style:LFAlertViewAlert];
    alert.buttonTitleArray = @[@"cancel",@"ok"];
    alert.clickBlock = ^(UIButton * _Nonnull button) {
        NSLog(@"点击了%@",button.currentTitle);
    };
    
    [alert show];
    
}
- (IBAction)alert3:(id)sender {
    LFAlertView *alert = [[LFAlertView alloc] initWithTitle:@"提示" message:@"温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示" style:LFAlertViewAlert];
    alert.buttonTitleArray = @[@"Cancel",@"OK1",@"OK2"];
    alert.clickBlock = ^(UIButton * _Nonnull button) {
        NSLog(@"点击了%@",button.currentTitle);
    };
    
    [alert show];
    
}


- (IBAction)sheet1:(id)sender {
    
    LFAlertView *alert = [[LFAlertView alloc] initWithTitle:@"提示" message:@"温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示" style:LFAlertViewActionSheet];
    alert.buttonTitleArray = @[@"Cancel",@"ok"];
    alert.clickBlock = ^(UIButton * _Nonnull button) {
        NSLog(@"点击了%@",button.currentTitle);
    };
    
    [alert show];
}

- (IBAction)sheet2:(id)sender {
    LFAlertView *alert = [[LFAlertView alloc] initWithTitle:@"提示" message:nil style:LFAlertViewActionSheet];
    alert.buttonTitleArray = @[@"Cancel",@"ok"];
    alert.clickBlock = ^(UIButton * _Nonnull button) {
        NSLog(@"点击了%@",button.currentTitle);
    };
    [alert show];
}
- (IBAction)sheet3:(id)sender {
    LFAlertView *alert = [[LFAlertView alloc] initWithTitle:nil message:nil style:LFAlertViewActionSheet];
    alert.buttonTitleArray = @[@"Cancel",@"ok",@"ok2"];
    alert.clickBlock = ^(UIButton * _Nonnull button) {
        NSLog(@"点击了%@",button.currentTitle);
    };
    [alert show];
}
- (IBAction)tfAlert1:(id)sender {
    
    LFAlertView *alert = [[LFAlertView alloc] initWithTitle:@"提示" message:@"温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示" style:LFAlertViewAlert];
    UITextField *tf = [[UITextField alloc] init];
    tf.borderStyle = UITextBorderStyleNone;
    tf.layer.borderWidth = 1/[UIScreen mainScreen].scale;
    tf.layer.borderColor = [UIColor darkGrayColor].CGColor;
    tf.textColor = [UIColor blackColor];
    tf.font = [UIFont systemFontOfSize:13];
    tf.backgroundColor = [UIColor whiteColor];
    tf.placeholder = @"请输入密码";
    
    alert.textFieldArray = @[tf];
    alert.buttonTitleArray = @[@"cancel",@"ok"];
    alert.clickBlock = ^(UIButton * _Nonnull button) {
        NSLog(@"点击了%@",button.currentTitle);
    };
    
    [alert show];
    
}

- (IBAction)tfAlert2:(id)sender {
    LFAlertView *alert = [[LFAlertView alloc] initWithTitle:@"提示" message:@"温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示" style:LFAlertViewAlert];
    UITextField *tf = [[UITextField alloc] init];
    tf.borderStyle = UITextBorderStyleNone;
    tf.layer.borderWidth = 1/[UIScreen mainScreen].scale;
    tf.layer.borderColor = [UIColor darkGrayColor].CGColor;
    tf.textColor = [UIColor blackColor];
    tf.font = [UIFont systemFontOfSize:13];
    tf.backgroundColor = [UIColor whiteColor];
    tf.placeholder = @"请输入账号";
    
    UITextField *tf2 = [[UITextField alloc] init];
    tf2.borderStyle = UITextBorderStyleNone;
    tf2.layer.borderWidth = 1/[UIScreen mainScreen].scale;
    tf2.layer.borderColor = [UIColor darkGrayColor].CGColor;
    tf2.textColor = [UIColor blackColor];
    tf2.font = [UIFont systemFontOfSize:13];
    tf2.backgroundColor = [UIColor whiteColor];
    tf2.placeholder = @"请输入密码";
    
    alert.textFieldArray = @[tf,tf2];
    alert.buttonTitleArray = @[@"cancel",@"ok"];
    alert.clickBlock = ^(UIButton * _Nonnull button) {
        NSLog(@"点击了%@",button.currentTitle);
    };
    
    [alert show];
}

@end
