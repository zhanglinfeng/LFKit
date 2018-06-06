//
//  LFImagePicker.h
//  LFQRCode
//
//  Created by 张林峰 on 2017/5/16.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//注意：一定要定义成全局变量，否则没有回调

@interface LFImagePicker : NSObject

//原生相册单选
- (void)pickSingleImageWithController:(UIViewController *)ctr allowsEditing:(BOOL)allowsEditing resultBlock:(void(^)(UIImage *image))resultBlock;

//原生拍照
- (void)pickImageFromCameraWithController:(UIViewController *)ctr allowsEditing:(BOOL)allowsEditing resultBlock:(void(^)(UIImage *image))resultBlock;

@end
