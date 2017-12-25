//
//  LFAlignCollectionViewFlowLayout.h
//  LFKit
//
//  Created by 张林峰 on 2017/12/25.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,LFAlignCollectionViewFlowLayoutType){
    LFAlignCollectionViewFlowLayoutTypeLeft,
    LFAlignCollectionViewFlowLayoutTypeCenter,
    LFAlignCollectionViewFlowLayoutTypeRight
};


/**
 可设置对齐样式的CollectionViewFlowLayout
 */
@interface LFAlignCollectionViewFlowLayout : UICollectionViewFlowLayout

-(instancetype)initWthType:(LFAlignCollectionViewFlowLayoutType)alignType;

@end
