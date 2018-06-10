//
//  LFPhotoNavController.m
//  LFKit
//
//  Created by 张林峰 on 2018/6/10.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import "LFPhotoNavController.h"
#import "LFAlbumModel.h"

@interface LFPhotoNavController ()

@end

@implementation LFPhotoNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.translucent = YES;
    self.navbarStyle = LFPhotoNavBarStyleBlack;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.topViewController preferredStatusBarStyle];
}

- (void)setNavbarStyle:(LFPhotoNavBarStyle)navbarStyle {
    _navbarStyle = navbarStyle;
    switch (_navbarStyle) {
        case LFPhotoNavBarStyleBlack:
        {
            [self navBlackStyle]; //无需重复设置
        }
            break;
        case LFPhotoNavBarStyleLightContent:
        {
            [self navLightContentStyle];
        }
            break;
        default:
            break;
    }
}

- (void)navBlackStyle {
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.barTintColor = [UIColor blackColor];
    
    [self.navigationBar setBackgroundImage:[[LFAlbumModel imageWithColor:[UIColor blackColor] size:CGSizeMake(1, 1)] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:nil];
}

- (void)navLightContentStyle {
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                                 NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.navigationBar.tintColor = [UIColor blackColor];
    self.navigationBar.barTintColor = [UIColor whiteColor];
    UIImage *image = [LFAlbumModel imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:nil];
}

@end
