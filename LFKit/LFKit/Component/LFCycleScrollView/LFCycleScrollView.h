//
//  LFCycleScrollView.h
//  APPBaseSDK
//
//  Created by 张林峰 on 16/10/29.
//  Copyright © 2016年 张林峰. All rights reserved.
//

//功能强大的轮播空间，不仅可以轮播图片，还可以轮播自定义的任何view

#import <UIKit/UIKit.h>

@protocol LFCycleScrollViewDelegate;
@protocol LFCycleScrollViewDataSource;

@interface LFCycleScrollView : UIView

@property (nonatomic, strong) NSArray *arrayImage; //图片链接数组，存放NSString类型
@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, strong) UIImage * placeholderImage;
@property (nonatomic, assign) UIViewContentMode contentMode;
@property (nonatomic, assign) BOOL removeTapEvent;
@property (nonatomic, weak) id<LFCycleScrollViewDataSource> dataSource;
@property (nonatomic, weak) id<LFCycleScrollViewDelegate> delegate;
/**
 默认初始化方式:默认有pageController，默认定时滚动，默认滚动时间间隔2秒
 *
 1.如果从外部传入了arrayURL数组，则不需要设置datasource。2.如果需要自定义滚动内容，则设置datasource并实现其方法，arrayURL传nil。
 *  @param frame    frame description
 *  @param arrayImage 图片链接数组，存放NSString类型
 *  @return id
 */
- (id)initWithFrame:(CGRect)frame withImages:(NSArray *)arrayImage;



/**
 *  1.如果从外部传入了arrayURL数组，则不需要设置datasource。2.如果需要自定义滚动内容，则设置datasource并实现其方法，arrayURL传nil。
 *
 *  @param frame            frame description
 *  @param showPageController 是否需要pageController
 *  @param isAutoScroll     是否自动滚动
 *  @param duration         滚动时间间隔
 *  @param arrayImage       图片链接数组，存放NSString类型
 *  @return id
 */
- (id)initWithFrame:(CGRect)frame
 showPageController:(BOOL)showPageController
       IsAutoScroll:(BOOL)isAutoScroll
           Duration:(NSTimeInterval)duration
         withImages:(NSArray *)arrayImage;

//设置PageController点的颜色(非必选，有默认的)
- (void)setPageIndicator:(UIColor *)color highlightColor:(UIColor*)hColor;
//刷新数据
- (void)reloadData;
//获取当前展示的视图
- (UIView *)getCurrentShowView;
//停止滚动
- (void)stopTimer;
//开始滚动
- (void)startTimer;

@end


@protocol LFCycleScrollViewDelegate <NSObject>

@optional

- (void)cycleScrollView:(LFCycleScrollView *)csView currentScrollPage:(NSInteger)index;
- (void)cycleScrollView:(LFCycleScrollView *)csView didScrollAtIndex:(NSInteger)index;
- (void)cycleScrollView:(LFCycleScrollView *)csView beginScrollAtIndex:(NSInteger)index;
- (void)cycleScrollView:(LFCycleScrollView *)csView didClickPageAtIndex:(NSInteger)index;
- (void)cycleScrollView:(LFCycleScrollView *)csView doubleClickAtIndex:(NSInteger)index;

@end

//自定义的轮播内容（非必选，如果选了就要实现下面方法，用法同tableview）
@protocol LFCycleScrollViewDataSource <NSObject>

@required
- (NSInteger)numberOfPagesWithCycleScrollView:(LFCycleScrollView *)csView;
- (UIView *)cycleScrollView:(LFCycleScrollView *)csView pageAtIndex:(NSInteger)index;

@end
