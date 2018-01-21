//
//  LFSegmentView.h
//  LFKit
//
//  Created by 张林峰 on 2018/1/21.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LFSegmentIndicateStyle) {
    LFSegmentIndicateStyleAlignText, //指示线对齐文字
    LFSegmentIndicateStyleAlignFull, //指示线对齐整个
};

@interface LFSegmentConfig : NSObject <NSCopying>

@property (nonatomic) LFSegmentIndicateStyle indicateStyle;
@property (nonatomic, strong) UIFont * _Nonnull font;//字体，默认16
@property (nonatomic, strong, nullable) UIColor *selectedColor;//选中的字体颜色,默认红色
@property (nonatomic, strong, nullable) UIColor *normalColor;//未选中的字体颜色，默认灰色
@property (nonatomic, strong, nullable) UIColor *indicateColor;//指示线颜色,默认和字体颜色一样
@property (nonatomic, assign) CGFloat indicateHeight;//指示线高，默认2
@property (nonatomic, assign) CGFloat minItemSpace;//最小间距，默认20

@end


/**
 （可选）配置LFSegmentView默认样式的单例，只需应用启动时配置一次即可
 作用：如果多处使用LFSegmentView，配置默认样式，就不用繁琐的设置那些属性
 */
@interface LFSegmentDefaultConfig : NSObject

@property (nonatomic, strong) LFSegmentConfig * _Nonnull config;

+ (instancetype _Nullable )sharedInstance;

@end


@interface LFSegmentView : UIView

@property (nonatomic, strong, nullable) UIImage *backgroundImage;//背景图
@property (nonatomic, readonly) UIView * _Nonnull indicateView; //指示杆
@property (nonatomic, readonly) UIView * _Nonnull bottomLine; //底部分割线
@property (nonatomic, strong, readonly) UIButton * _Nullable selectedButton;
@property (nonatomic, strong, readonly) NSArray <UIButton *>* _Nonnull buttons;
@property (nonatomic, strong, readonly) UIScrollView * _Nonnull contentView;
@property (nonatomic, readonly) NSUInteger currentIndex;
@property (nonatomic, assign) NSTimeInterval duration;  //滑动时间，默认0.3
@property (nonatomic, copy) void(^ _Nullable selectedBlock)(NSInteger index, UIButton * _Nullable button);

- (__nullable instancetype)initWithFrame:(CGRect)frame titles:(NSArray <NSString *>*_Nonnull)titles;

/**设置样式*/
- (void)setConfig:(LFSegmentConfig *_Nonnull)config;

- (void)setSelectedIndex:(NSInteger)index;

/**调整线位置*/
- (void)adjustLinePosition:(CGFloat)offsetX;

@end
