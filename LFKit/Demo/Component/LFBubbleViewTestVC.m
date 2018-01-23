//
//  LFBubbleViewTestVC.m
//  LFKit
//
//  Created by 张林峰 on 2018/1/22.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import "LFBubbleViewTestVC.h"
#import "LFBubbleView.h"
#import "LFBaseCardView.h"

@interface LFBubbleViewTestVC ()

@property (strong, nonatomic) UIView *viewTarget;
@property (nonatomic, strong) LFBubbleView *bubbleView;

@end

@implementation LFBubbleViewTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *array = @[@"箭头上",@"箭头左",@"箭头下",@"箭头右"];
    for (NSInteger i = 0; i < array.count; i++) {
        UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(0, 100+i*50, 90, 40)];
        bt.tag = i;
        [bt setTitle:array[i] forState:UIControlStateNormal];
        bt.backgroundColor = [UIColor redColor];
        [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bt addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:bt];
    }
    
    _viewTarget = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 30)/2, self.view.frame.size.height/2, 30, 30)];
    _viewTarget.backgroundColor = [UIColor redColor];
    [self.view addSubview:_viewTarget];
    
}

- (void)buttonClick:(UIButton *)button {
    if (button.tag == 0) {
        [self up:button];
    } else if (button.tag == 1) {
        [self left:button];
    } else if (button.tag == 2) {
        [self down:button];
    } else if (button.tag == 3) {
        [self right:button];
    }
}

- (void)up:(id)sender {
    NSString *strTip = @"可设置边框线，三角大小，三角位置，圆角大小，背景色";
    [_bubbleView removeFromSuperview];
    _bubbleView  = [[LFBubbleView alloc] initWithFrame:CGRectMake(0, 0, 200, 160)];
    _bubbleView.direction = LFTriangleDirection_Up;
    _bubbleView.lbTitle.text = strTip;
    _bubbleView.config.borderColor = [UIColor grayColor];
    _bubbleView.config.borderWidth = 1;
    _bubbleView.config.triangleH = 20;
    _bubbleView.config.triangleW = 20;
    _bubbleView.triangleXY = 40;
    _bubbleView.config.cornerRadius = 20;
    _bubbleView.config.color = [UIColor orangeColor];
    [self.view addSubview:_bubbleView];
    [_bubbleView showInPoint:CGPointMake(_viewTarget.center.x, CGRectGetMaxY(_viewTarget.frame))];
//    [_bubbleView doTranslationAnimate];
    
}
- (void)down:(id)sender {
    NSString *strTip = @"什么都不设置的气泡";
    [_bubbleView removeFromSuperview];
    _bubbleView  = [[LFBubbleView alloc] initWithFrame:CGRectMake(0, 0, 160, 80)];
    _bubbleView.lbTitle.text = strTip;
    [self.view addSubview:_bubbleView];
    [_bubbleView showInPoint:CGPointMake(_viewTarget.center.x,CGRectGetMinY(_viewTarget.frame))];
}

- (void)left:(id)sender {
    NSString *strTip = @"三角距上30";
    [_bubbleView removeFromSuperview];
    _bubbleView  = [[LFBubbleView alloc] initWithFrame:CGRectMake(0, 0, 120, 160)];
    _bubbleView.direction = LFTriangleDirection_Left;
    _bubbleView.lbTitle.text = strTip;
    _bubbleView.triangleXY = 20;
    [self.view addSubview:_bubbleView];
    [_bubbleView showInPoint:CGPointMake(CGRectGetMaxX(_viewTarget.frame), _viewTarget.center.y)];
    [_bubbleView doSpringAnimate];
}
- (void)right:(id)sender {
    NSString *strTip = @"三角在1/4位置";
    [_bubbleView removeFromSuperview];
    _bubbleView  = [[LFBubbleView alloc] initWithFrame:CGRectMake(0, 0, 100, 160)];
    _bubbleView.direction = LFTriangleDirection_Right;
    _bubbleView.lbTitle.text = strTip;
    _bubbleView.triangleXYScale = 1.0f/3.0f;
    _bubbleView.dismissAfterSecond = 5;
    [self.view addSubview:_bubbleView];
    [_bubbleView showInPoint:CGPointMake(CGRectGetMinX(_viewTarget.frame), _viewTarget.center.y)];
}

@end
