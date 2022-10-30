//
//  LFEditPicsCollectionView.h
//  QingShe
//
//  Created by 张林峰 on 2022/10/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFEditPicsCollectionView : UICollectionView

@property (nonatomic, strong) NSMutableArray *dataArray; // 本地路径、网络路径、imgge
@property (nonatomic, strong) NSString *addIconName; // 本地加号图片名
@property (nonatomic, assign) CGFloat cellWidth; // cell宽
@property (nonatomic, assign) CGFloat cellHeight; // cell高
@property (nonatomic, assign) NSInteger oneRowNum; // 一行个数。默认3个。优先级低于cellWidth
@property (nonatomic, assign) CGFloat margin; // cell间距。默认4
@property (nonatomic, assign) NSInteger maxCount; // 最大张数,默认9
@property (nonatomic, assign) BOOL showDeleteButton; // 是否显示删除按钮

@property (copy, nonatomic) void (^clickBlock)(NSInteger index, BOOL isAdd);
@property (copy, nonatomic) void (^deleteBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
