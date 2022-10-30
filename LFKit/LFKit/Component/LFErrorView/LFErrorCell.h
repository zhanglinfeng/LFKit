//
//  LFErrorCell.h
//  LFKit
//
//  Created by 张林峰 on 2018/11/1.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFErrorView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LFErrorCell : UITableViewCell

@property (nonatomic, strong) LFErrorView *errorView;

@property (nonatomic, strong) UIImage *errorImage;
@property (nonatomic, strong) NSString *errorMessage;
@property (nonatomic, assign) CGFloat iconTop; // 图片距离顶部。 如果这个数字超过图片上下居中时距顶部的距离，则上下居中。

@end

NS_ASSUME_NONNULL_END
