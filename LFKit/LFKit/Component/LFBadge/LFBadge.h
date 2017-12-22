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

/**未读消息角标控件，支持xib和代码2种方式使用，支持拖拽清除*/

@interface LFBadge : UIView

@property (nonatomic, strong) UIColor *badgeCorlor;//角标颜色，默认红色
@property (nonatomic, strong) UILabel *lbText;//默认白字，字体14，角标大小自动适应字体大小
@property (nonatomic) BOOL needDisappearEffects;//是否需要消失特效，爆炸特效

//最大数字，不设置则默认99，要在count之前设置
@property (nonatomic, assign) NSInteger maxCount;

//@"0"或者nil隐藏，@""显示红点，大于maxCount的数字字符串显示maxCount++，其他字符串就显示本来样子(你也可以显示new)
@property (nonatomic, copy) NSString *count;

@property (nonatomic, assign) CGFloat redDotSize;//红点大小，不设置则默认8
@property (nonatomic, assign) CGFloat maxDistance;//大圆脱离小圆的最大距离

/**自行设置其他约束或者frame时下面2属性无效****/
@property (nonatomic) UIEdgeInsets edgeInsets;//对父视图右上角的偏移量,默认UIEdgeInsetsZero
@property (nonatomic) LFBadgeType type;

/**拖动清除回调（设置了这个才会有拖动效果）*/
@property (nonatomic, copy) void(^clearBlock)(void);


/**添加到父视图右上角(自动加约束)*/
- (void)addToView:(UIView*)superview;

/**将角标加到TabBarItem右上角(自动加约束)*/
- (void)addToTabBarItem:(UITabBarItem *)tabBarItem;

/**将角标加到BarButtonItem右上角(自动加约束)*/
- (void)addToBarButtonItem:(UIBarButtonItem *)barButtonItem;

/**清除角标约束（如果不想加到父视图右上角可调该方法，然后自行设置其他约束或者frame）*/
- (void)clearBadgeConstraint;

@end
