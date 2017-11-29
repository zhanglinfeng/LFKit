//
//  LFBadge.h
//  LFKit
//
//  Created by 张林峰 on 2017/11/24.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LFBadgeType) {
    LFBadgeType_Center,//Badge中心对准父视图右上角
    LFBadgeType_RightTop,//Badge右上角对准父视图右上角
    LFBadgeType_LeftBottom//Badge左下角对准父视图右上角
};

/**角标控件，支持xib和代码2种方式使用*/

@interface LFBadge : UIView

@property (nonatomic, strong) UILabel *lbText;//默认白字，字体14

//最大数字，不设置则默认99，要在count之前设置
@property (nonatomic, assign) NSInteger maxCount;

//@"0"或者nil隐藏，@""显示红点，大于maxCount的数字字符串显示maxCount++，其他字符串就显示本来样子(你也可以显示new)
@property (nonatomic, copy) NSString *count;

@property (nonatomic, assign) CGFloat redDotSize;//红点大小，不设置则默认8

/****使用了addToTopRight情况下，下面2个属性才生效****/
@property (nonatomic) UIEdgeInsets edgeInsets;//对右上角的偏移量,默认UIEdgeInsetsZero
@property (nonatomic) LFBadgeType type;


/**将角标加到TabBarItem上*/
- (void)addToTabBarItem:(UITabBarItem *)tabBarItem;

/**将角标加到BarButtonItem上*/
- (void)addToBarButtonItem:(UIBarButtonItem *)barButtonItem;

/**
 添加到父视图右上角的约束
 注意:如果需求不是放在父视图右上角，就不要调用该方法，自行设置其他约束，或者frame都行
 */
- (void)addToTopRight;

@end

