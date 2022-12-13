//
//  LFPicturesCollectionView.h
//  QingShe
//
//  Created by 张林峰 on 2022/9/23.
//

#import <UIKit/UIKit.h>
#import <LFKit/LFPhotoModel.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LFPicturesCollectionViewDelegate <NSObject>

@optional

// 可选外部实现。外部不实现就用内部的大图浏览
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

/**显示单图或多图的照片墙*/
@interface LFPicturesCollectionView : UICollectionView

@property (nonatomic, weak) UIViewController *ctrl;

// 数组元素结构必须为@{@"url": xxx, @"height": xx, @"width": xx }
@property (nonatomic, strong) NSMutableArray <LFPhotoModel *>*dataArray;

@property (nonatomic, assign) CGFloat margin; // cell间距。默认4
@property (nonatomic, assign) CGFloat maxHeight; // 单图最大高度
@property (nonatomic, assign) CGFloat maxWidth; // 单图最大宽度,默认就是本组件宽度
@property (nonatomic, assign) CGFloat minHeight; // 最小高度
@property (nonatomic, assign) CGFloat minWidth; // 最小宽度
@property (nonatomic, assign) NSInteger maxCount; // 最大张数,默认9
@property (nonatomic, assign) BOOL needSave; // 是否需要保存
@property (nonatomic, weak) id<LFPicturesCollectionViewDelegate> picDelegate;

/**获取图片大小*/
- (CGSize)getPicSize;

@end

NS_ASSUME_NONNULL_END
