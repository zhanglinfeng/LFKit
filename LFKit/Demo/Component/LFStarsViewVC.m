//
//  LFStarsViewVC.m
//  LFKit
//
//  Created by 张林峰 on 2017/12/25.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import "LFStarsViewVC.h"
#import "LFStarsView.h"

@interface LFStarsViewVC ()

@property (nonatomic, strong) LFStarsView *starsView;
@property (strong, nonatomic) IBOutlet LFStarsView *starsView2;
@property (strong, nonatomic) IBOutlet UITextField *tf;

@end

@implementation LFStarsViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _starsView = [[LFStarsView alloc] initWithFrame:CGRectMake(20, 100, 100, 20)];
    [_starsView configWithStarNumber:5 image:[UIImage imageNamed:@"star_gray"] highlightImage:[UIImage imageNamed:@"star_highlight"]];
    [self.view addSubview:_starsView];
    
    [_starsView2 configWithStarNumber:5 image:[UIImage imageNamed:@"star_gray"] highlightImage:[UIImage imageNamed:@"star_highlight"]];
}

//是否允许用户点击、滑动星星
- (IBAction)change:(id)sender {
    UISwitch *sw = (UISwitch *)sender;
    if (sw.isOn) {//给selectBlock则允许点击滑动
        __weak typeof(self) weakSelf = self;
        _starsView.selectBlock = ^(CGFloat value) {
            weakSelf.tf.text = [NSString stringWithFormat:@"%f",value];
        };
        _starsView2.selectBlock = ^(CGFloat value) {
            weakSelf.tf.text = [NSString stringWithFormat:@"%f",value];
        };
    } else {//selectBlock = nil则不允许
        _starsView.selectBlock = nil;
        _starsView2.selectBlock = nil;
    }
}

- (IBAction)OK:(id)sender {
    [self.view endEditing:YES];
    _starsView.value = _tf.text.floatValue;
    _starsView2.value = _tf.text.floatValue;
}


@end
