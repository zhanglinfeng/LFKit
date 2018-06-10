//
//  LFBigVideoController.h
//  LFKit
//
//  Created by 张林峰 on 2018/6/10.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import "LFPhotoModel.h"

#import <UIKit/UIKit.h>

@interface LFBigVideoController : UIViewController

@property (nonatomic, strong) LFPhotoModel *videoModel;

@property (nonatomic, copy) void (^selectVideoBlock)(LFPhotoModel* video); //点击确定按钮回调

@end
