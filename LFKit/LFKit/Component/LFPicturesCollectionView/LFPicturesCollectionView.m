//
//  LFPicturesCollectionView.m
//  QingShe
//
//  Created by 张林峰 on 2022/9/23.
//

#import "LFPicturesCollectionView.h"
#import <LFKit/LFPhotoBrowser.h>
#import "LFPicCollectionCell.h"
#import <LFKit/UIViewController+LF.h>

@interface LFPicturesCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation LFPicturesCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    if (self) {
        [self setupCollectionView];
    }
    
    return  self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupCollectionView];
}

- (void)setupCollectionView {
    //设置cell对齐方式
        SEL sel = NSSelectorFromString(@"_setRowAlignmentsOptions:");
        if ([self.collectionViewLayout respondsToSelector:sel]) {
            
            void (*action)(id, SEL, NSDictionary*) = (void (*)(id, SEL, NSDictionary*)) objc_msgSend;
            action(self.collectionViewLayout, sel, @{@"UIFlowLayoutCommonRowHorizontalAlignmentKey":@(NSTextAlignmentLeft),
                                                     @"UIFlowLayoutLastRowHorizontalAlignmentKey" : @(NSTextAlignmentLeft),
                                                     @"UIFlowLayoutRowVerticalAlignmentKey" : @(NSTextAlignmentCenter)});
            
//            ((void(*)(id,SEL,NSDictionary*))objc_msgSend)(self.collectionViewLayout,sel,
//                                                          @{@"UIFlowLayoutCommonRowHorizontalAlignmentKey":@(NSTextAlignmentLeft),
//                                                            @"UIFlowLayoutLastRowHorizontalAlignmentKey" : @(NSTextAlignmentLeft),
//                                                            @"UIFlowLayoutRowVerticalAlignmentKey" : @(NSTextAlignmentCenter)});
        }

    
    self.backgroundColor = [UIColor clearColor];
    self.delegate = self;
    self.dataSource = self;
    self.bounces = NO;
    self.scrollEnabled = NO;
    [self registerClass:[LFPicCollectionCell class] forCellWithReuseIdentifier:@"LFPicCollectionCell"];
    
    self.margin = 4;
//    self.maxWidth = 240;
//    self.maxHeight = 240;
    self.minWidth = 60;
    self.minHeight = 60;
    self.maxCount = 9;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.maxWidth < 1) {
        self.maxWidth = self.frame.size.width;
    }
    if (self.maxHeight < 1) {
        self.maxHeight = self.frame.size.width;
    }
}

- (void)setDataArray:(NSMutableArray <LFPhotoModel *>*)dataArray {
    _dataArray = dataArray;
    [self reloadData];
}

/**获取图片大小*/
- (CGSize)getPicSize {
    if (self.dataArray.count == 1) { // 单图
        LFPhotoModel *photo = self.dataArray[0];
        CGFloat ratio = self.maxHeight / self.maxWidth; // 标准长宽比
        CGFloat ratio1 = self.maxHeight / self.minWidth; // 超长图长宽比
        CGFloat ratio2 = self.minHeight / self.maxWidth; // 超宽图长宽比
        CGFloat height = photo.height;
        CGFloat width = photo.width;
        if (height > 0 && width > 0) {
            CGFloat currentRatio = height / width; // 当前长宽比
            if (currentRatio > ratio1) { // 超长图
                return CGSizeMake(self.minWidth, self.maxHeight);
            } else if (currentRatio > ratio) { // 长度顶格，宽度按比例算
                return CGSizeMake(self.maxHeight / currentRatio, self.maxHeight);
            } else if (currentRatio > ratio2) { // 宽度顶格，长度按比例计算
                return CGSizeMake(self.maxWidth, self.maxWidth * currentRatio);
            } else { // 超宽图
                return CGSizeMake(self.maxWidth, self.minHeight);
            }
            
        } else {
            return CGSizeMake(self.maxWidth, self.maxHeight);
        }
    } else { // 多图
        
        // -0.1是防止刚好突破临界值，导致1行只能显示2张图
        CGFloat w = (self.frame.size.width - self.margin * 2) / 3 - 0.1;
        return CGSizeMake(w, w);
    }
}

#pragma mark - UICollectionViewDataSource UICollectionViewDelegate

//section 的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count < self.maxCount ? self.dataArray.count : self.maxCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LFPicCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LFPicCollectionCell" forIndexPath:indexPath];
    LFPhotoModel *photo = self.dataArray[indexPath.item];
    cell.imageUrl = photo.smallImageUrl;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LFPhotoBrowser *browser= [[LFPhotoBrowser alloc] init];
    browser.ctr = [UIViewController lf_currentViewController];
    browser.arrayData = self.dataArray ;
    browser.currentIndex = indexPath.item;
    LFPicCollectionCell *cell = (LFPicCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    CGRect rect = [self convertRect:cell.frame toView:[UIApplication sharedApplication].keyWindow];
    browser.beginRect = rect;
    browser.beginImage = cell.imageView.image;
    [browser show];
}

//设置每个UICollectionViewCell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath

{
    return [self getPicSize];
}


//定义每个item 最小左右间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return self.margin;
}

//定义每个item 最小上下间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return  self.margin;
}


@end


