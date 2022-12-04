//
//  LFEditPicsCollectionView.m
//  QingShe
//
//  Created by 张林峰 on 2022/10/3.
//

#import "LFEditPicsCollectionView.h"
#import <LFKit/LFPhotoBrowser.h>
#import "LFPicCollectionCell.h"
#import "UIViewController+LF.h"
#import <objc/message.h>

@interface LFEditPicsCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation LFEditPicsCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self setupCollectionView];
    }
    return  self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupCollectionView];
}

// //扩大点击区域（解决超出父视图的删除按钮不可点击）
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect bounds = self.bounds;
    //扩大点击区域
    bounds = CGRectOffset(bounds, 10, -10);
    //若点击的点在新的bounds里面就返回yes
    return CGRectContainsPoint(bounds, point);
}


- (void)setupCollectionView {
    //设置cell对齐方式
        SEL sel = NSSelectorFromString(@"_setRowAlignmentsOptions:");
        if ([self.collectionViewLayout respondsToSelector:sel]) {
            ((void(*)(id,SEL,NSDictionary*))objc_msgSend)(self.collectionViewLayout,sel,
                                                          @{@"UIFlowLayoutCommonRowHorizontalAlignmentKey":@(NSTextAlignmentLeft),
                                                            @"UIFlowLayoutLastRowHorizontalAlignmentKey" : @(NSTextAlignmentLeft),
                                                            @"UIFlowLayoutRowVerticalAlignmentKey" : @(NSTextAlignmentCenter)});
        }

    self.backgroundColor = [UIColor clearColor];
    self.delegate = self;
    self.dataSource = self;
    self.bounces = NO;
    self.showsHorizontalScrollIndicator = NO;
    [self registerClass:[LFPicCollectionCell class] forCellWithReuseIdentifier:@"LFPicCollectionCell"];
    self.margin = 8;
//    self.cellWidth = 90;
//    self.cellHeight = 90;
    self.oneRowNum = 3;
    self.maxCount = 9;
    self.addIconName = @"lf_addPhoto";
//    self.addIconName = @"plus.square.dashed";
    self.dataArray = [[NSMutableArray alloc] init];
    self.clipsToBounds = NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    [self reloadData];
}

#pragma mark - UICollectionViewDataSource UICollectionViewDelegate

//section 的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.dataArray.count < self.maxCount) {
        return self.dataArray.count + 1;
    } else {
        return self.maxCount;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LFPicCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LFPicCollectionCell" forIndexPath:indexPath];
    
    if (indexPath.item < self.dataArray.count) {
        id obj = self.dataArray[indexPath.item];
        if ([obj isKindOfClass:[UIImage class]]) {
            cell.imageView.image = obj;
        } else {
            cell.imageUrl = obj;
        }
        cell.deleteBlock = self.deleteBlock;
        cell.deleteButton.hidden = !self.showDeleteButton;
        cell.imageView.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1];
    } else {
        cell.imageView.backgroundColor = [UIColor clearColor];
        cell.imageView.image = [UIImage imageNamed:self.addIconName];
        cell.deleteButton.hidden = YES;
    }
    
    cell.index = indexPath.item;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BOOL isAdd = indexPath.item == self.dataArray.count;
    if (self.clickBlock) {
        self.clickBlock(indexPath.item, isAdd);
    }
}

//设置每个UICollectionViewCell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath

{
    if (self.cellWidth > 0 && self.cellHeight > 0) {
        return CGSizeMake(self.cellWidth, self.cellHeight);
    } else {
        CGFloat w = (self.frame.size.width - (self.margin * (self.oneRowNum - 1))) / self.oneRowNum - 0.1;
        return CGSizeMake(w, w);;
    }
    
    
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
