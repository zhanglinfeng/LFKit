//
//  LFErrorCell.h
//  LFKit
//
//  Created by 张林峰 on 2018/11/1.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFErrorCell : UITableViewCell

@property (nonatomic, strong) UIImage *errorImage;
@property (nonatomic, strong) NSString *errorMessage;

@end

NS_ASSUME_NONNULL_END
