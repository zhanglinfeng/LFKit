//
//  LFAnnulusProgress.h
//  LFKit
//
//  Created by 张林峰 on 2017/12/25.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 环形进度条
 */
@interface LFAnnulusProgress : UIView

@property (nonatomic, assign) CGFloat progressValue;
@property (nonatomic, strong) UIColor *startColor;
@property (nonatomic, strong) UIColor *centerColor;
@property (nonatomic, strong) UIColor *endColor;
@property (nonatomic, assign) CGFloat bgLineWidth;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat endAngle;
@property (nonatomic, assign) BOOL isClockWise;//是否顺时针

/**一定要在初始化时确定大小*/
-(instancetype)initWithFrame:(CGRect)frame;
- (void)createUI;
- (void)removeUI;

@end
