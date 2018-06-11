//
//  LFBigImageCell.h
//  LFKit
//
//  Created by 张林峰 on 2018/6/2.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFPhotoModel.h"

@interface LFBigImageCell : UICollectionViewCell

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImage *placeholder;
@property (nonatomic, strong) LFPhotoModel *photo;

@property (nonatomic, copy)   void (^singleTapCallBack)(void);

- (UIImage *)getImage;

@end
