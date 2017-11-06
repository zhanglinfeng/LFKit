//
//  LFCameraViewController.m
//  LFKit
//
//  Created by 张林峰 on 2017/11/3.
//  Copyright © 2017年 张林峰. All rights reserved.
//
#import "LFCamera.h"
#import "LFCameraViewController.h"
#import "LFCameraResultViewController.h"

@interface LFCameraViewController ()

@property (strong, nonatomic) IBOutlet LFCamera *camera;

@end

@implementation LFCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.camera.effectiveRect = CGRectMake(0, 64, 100, 100);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.camera restart];
}
- (IBAction)changeCamera:(id)sender {
    [self.camera switchCamera:![self.camera isCameraFront]];
}

- (IBAction)takePhoto:(id)sender {
    __weak typeof(self) weakSelf = self;
    [self.camera takePhoto:^(UIImage *img) {
        LFCameraResultViewController *vc = [[LFCameraResultViewController alloc] init];
        vc.image = img;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
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
