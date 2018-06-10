//
//  LFPhotoCollectionCell.h
//  LFKit
//
//  Created by 张林峰 on 2018/6/6.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFPhotoCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *btnSelect;
@property (nonatomic, strong) UIView *coverView;//蒙层,不可点时显示蒙层

- (void)setIsVideo:(BOOL)isVideo;
- (void)setTime:(NSString *)time;

@end
