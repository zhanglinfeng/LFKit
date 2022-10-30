//
//  LFPicCollectionCell.h
//  QingShe
//
//  Created by 张林峰 on 2022/9/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFPicCollectionCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, copy) void(^deleteBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
