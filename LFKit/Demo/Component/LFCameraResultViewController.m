//
//  LFCameraResultViewController.m
//  LFKit
//
//  Created by 张林峰 on 2017/11/3.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import "LFCameraResultViewController.h"

@interface LFCameraResultViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation LFCameraResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.imageView.image = self.image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
