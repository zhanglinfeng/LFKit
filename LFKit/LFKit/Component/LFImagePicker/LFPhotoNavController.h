//
//  LFPhotoNavController.h
//  LFKit
//
//  Created by 张林峰 on 2018/6/10.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, LFPhotoNavBarStyle) {
    LFPhotoNavBarStyleBlack,
    LFPhotoNavBarStyleLightContent
};

@interface LFPhotoNavController : UINavigationController

@property (nonatomic, assign) LFPhotoNavBarStyle navbarStyle;

@end
