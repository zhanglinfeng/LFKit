//
//  LFPopupMenu.m
//  LFPopupMenu
//
//  Created by 张林峰 on 2017/8/20.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import "LFPopupMenu.h"
#import <objc/runtime.h>

@implementation LFPopupMenuItem

+ (LFPopupMenuItem *)createWithTitle:(NSString *)title image:(UIImage *)image {
    LFPopupMenuItem *item = [[LFPopupMenuItem alloc] init];
    item.title = title;
    item.image = image;
    return item;
}

@end


@implementation LFPopupMenuConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.rowHeight = 60;
        self.arrowH = 9;
        self.arrowW = 9;
        self.popupMargin = 5;
        self.leftEdgeMargin = 16;
        self.rightEdgeMargin = 16;
        self.textMargin = 8;
        self.cornerRadius = 6;
        self.arrowCornerRadius = 0;
        self.lineColor = [UIColor grayColor];
        self.textFont = [UIFont systemFontOfSize:15];
        self.textColor = [UIColor blackColor];
        self.fillColor = [UIColor whiteColor];
        self.needBorder =NO;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    id obj = [[[self class] allocWithZone:zone] init];
    
    Class class = [self class];
    unsigned int count = 0;
    //获取类中所有成员变量名
    Ivar *ivar = class_copyIvarList(class, &count);
    for (int i = 0; i < count; i++) {
        Ivar iva = ivar[i];
        const char *name = ivar_getName(iva);
        NSString *strName = [NSString stringWithUTF8String:name];
        //进行解档取值
//            id value = [decoder decodeObjectForKey:strName];
        id value = [self valueForKey:strName];
        //利用KVC对属性赋值
        [obj setValue:value forKey:strName];
    }
    free(ivar);
    
    return obj;
}

@end


@implementation LFPopupMenuDefaultConfig

+ (instancetype)sharedInstance {
    static LFPopupMenuDefaultConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.config = [[LFPopupMenuConfig alloc] init];
    });
    return instance;
}

@end


@interface LFPopupMenu ()

@property (nonatomic, strong) UIView *containerView;//容器，用于自定义弹窗内视图
@property (nonatomic, strong) UIImageView *ivBG;
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, assign) BOOL isUp;
@property (nonatomic, copy) void(^action)(NSInteger index);

@end

@implementation LFPopupMenu

#pragma mark - UI

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
        self.config = [[LFPopupMenuDefaultConfig sharedInstance].config copy];
        self.direction = PopupMenuDirection_Auto;
        self.menuSuperView = [UIApplication sharedApplication].keyWindow;
        
        self.containerView = [[UIView alloc] init];
        self.containerView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.containerView];
    }
    return self;
}

- (void)configWithItems:(NSArray<LFPopupMenuItem *>*)items action:(void(^)(NSInteger index))action {
    self.menuItems = items;
    self.action = action;
    [self adjustMaxWidth];
    self.containerView.frame = CGRectMake(0, self.config.arrowH, self.frame.size.width, self.frame.size.height - self.config.arrowH);
    if (self.imgBG) {
        self.ivBG = [[UIImageView alloc] initWithFrame:self.bounds];
        self.ivBG.image = self.imgBG;
        [self insertSubview:self.ivBG atIndex:0];
    }
    
    for (NSInteger i = 0; i < self.menuItems.count; i++) {
        LFPopupMenuItem *item = self.menuItems[i];
        CGFloat imgH = item.image.size.height;
        CGFloat imgW = item.image.size.width;
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(self.config.leftEdgeMargin, (self.config.rowHeight - imgH)/2 + self.config.rowHeight*i, imgW, imgH)];
        iv.image = item.image;
        [self.containerView addSubview:iv];
        
        CGFloat lbX = imgW > 0 ? (self.config.leftEdgeMargin + imgW + self.config.textMargin) : self.config.leftEdgeMargin;
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(lbX, i*self.config.rowHeight, self.frame.size.width - lbX - self.config.rightEdgeMargin, self.config.rowHeight)];
        lb.textColor = self.config.textColor;
        lb.text = item.title;
        lb.font = [UIFont systemFontOfSize:15];
        [self.containerView addSubview:lb];
        
        UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(0, i*self.config.rowHeight, self.frame.size.width, self.config.rowHeight)];
        bt.backgroundColor = [UIColor clearColor];
        bt.tag = i;
        [bt addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:bt];
        
        if (i > 0) {
            UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(self.config.lineMargin, i*self.config.rowHeight, self.frame.size.width - self.config.lineMargin, 1.0f/[UIScreen mainScreen].scale)];
            viewLine.backgroundColor = self.config.lineColor;
            [self.containerView addSubview:viewLine];
        }
    }
}

/**完全自定义菜单弹窗*/
- (void)configWithCustomView:(UIView *)customView{
    self.containerView.frame = CGRectMake(self.containerView.frame.origin.x, self.containerView.frame.origin.y, customView.frame.size.width, customView.frame.size.height);
    self.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height + self.config.arrowH);
    [self.containerView addSubview:customView];
    if (self.imgBG) {
        self.ivBG = [[UIImageView alloc] initWithFrame:self.bounds];
        self.ivBG.image = self.imgBG;
        [self insertSubview:self.ivBG atIndex:0];
    }
}


#pragma mark - Action

- (void)selectItem:(UIButton *)button {
    if (self.action) {
        self.action(button.tag);
    }
    
    [self dismiss];
}

#pragma mark - 公有方法

//显示菜单窗,有imgBG的情况下调用
- (void)showInPoint:(CGPoint)point {
    [self addToWindow];
    
    self.frame = CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height);
    if (self.anchorPoint.y > 0.5) {
        self.containerView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - self.config.arrowH);
    }
    // 弹出动画
    self.maskView.alpha = 0;
    CGRect oldFrame = self.frame;
    self.layer.anchorPoint = self.anchorPoint;
    self.frame = oldFrame;
    self.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    [UIView animateWithDuration:0.25f animations:^{
        self.transform = CGAffineTransformIdentity;
        self.maskView.alpha = 1.f;
    }];
}

//显示菜单窗,无imgBG的情况下调用

- (void)showArrowInPoint:(CGPoint)point {
    if (self.direction == PopupMenuDirection_Up) {
        self.isUp = YES;
    } else if (self.direction == PopupMenuDirection_Down) {
        self.isUp = NO;
    } else {
        self.isUp = point.y < self.maskView.frame.size.height/2;
    }
    
    [self private_showArrowInPoint:point];
}

//显示菜单窗,无imgBG的情况下调用
- (void)showArrowToView:(UIView*)view {
    CGRect pointViewRect = [view.superview convertRect:view.frame toView:self.menuSuperView];
    // 弹窗箭头指向的点
    CGPoint toPoint = CGPointMake(CGRectGetMidX(pointViewRect), 0);
    if (self.direction == PopupMenuDirection_Up) {
        self.isUp = YES;
    } else if (self.direction == PopupMenuDirection_Down) {
        self.isUp = NO;
    } else {
        self.isUp = CGRectGetMidY(pointViewRect) < self.menuSuperView.frame.size.height/2;
    }
    
    if (self.isUp) {
        toPoint.y = CGRectGetMaxY(pointViewRect) + 2;
    } else {
        toPoint.y = CGRectGetMinY(pointViewRect) - 2;
    }
    [self private_showArrowInPoint:toPoint];
}

- (void)dismiss {
    if (self.dismissComplete) {
        self.dismissComplete();
    }
    [self.maskView removeFromSuperview];
    [self removeFromSuperview];
}

#pragma mark - 私有方法
//根据字数调整最大宽度
- (void)adjustMaxWidth {
    CGFloat textW = 0.0;
    CGFloat imageW = 0.0;
    for (NSInteger i = 0; i < self.menuItems.count; i++) {
        LFPopupMenuItem *item = self.menuItems[i];
        NSStringDrawingOptions opts = NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading;
        CGRect rect = [item.title boundingRectWithSize:CGSizeZero
                                               options:opts
                                            attributes:@{NSFontAttributeName: self.config.textFont}
                                               context:nil];
        
        textW = textW > rect.size.width ? textW : rect.size.width;
        
        
        imageW = imageW > item.image.size.width ? imageW : item.image.size.width;
    }
    CGFloat totalMargin = (textW > 0 && imageW > 0) ? (self.config.leftEdgeMargin + self.config.rightEdgeMargin + self.config.textMargin) : (self.config.leftEdgeMargin + self.config.rightEdgeMargin);
    CGFloat totalWidth = textW + imageW + totalMargin;
    totalWidth = totalWidth > self.config.minWidth ? totalWidth : self.config.minWidth;
    self.frame = CGRectMake(0, 0, totalWidth, self.config.rowHeight * self.menuItems.count + self.config.arrowH);
}

//私有的显示
- (void)private_showArrowInPoint:(CGPoint)point {
    [self addToWindow];
    CGFloat popupX;//窗口x
    CGFloat popupY;//窗口y
    
    // 如果箭头指向的点过于偏左或者过于偏右则需要重新调整箭头 x 轴的坐标
    CGFloat minHorizontalEdge = self.config.popupMargin + self.config.cornerRadius + self.config.arrowW/2;
    if (point.x < minHorizontalEdge) {
        point.x = minHorizontalEdge;
    }
    
    if (point.x > self.maskView.frame.size.width - minHorizontalEdge) {
        point.x = self.maskView.frame.size.width - minHorizontalEdge;
    }
    
    popupX = point.x - self.frame.size.width/2;
    popupY = point.y;
    //窗口靠左
    if (point.x <= self.frame.size.width/2 + self.config.popupMargin) {
        popupX = self.config.popupMargin;
    }
    //窗口靠右
    if (self.maskView.frame.size.width - point.x <= self.frame.size.width/2 + self.config.popupMargin) {
        popupX = self.maskView.frame.size.width - self.config.popupMargin - self.frame.size.width;
    }
    //箭头向下
    if (!self.isUp) {
        popupY = point.y - self.frame.size.height;
        self.containerView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - self.config.arrowH);
    }
    
    self.frame = CGRectMake(popupX, popupY, self.frame.size.width, self.frame.size.height);
    
    // 箭头相对本窗口的坐标
    CGPoint arrowPoint = CGPointMake(point.x - CGRectGetMinX(self.frame), self.isUp ? 0 : self.frame.size.height);
    
    CGFloat maskTop = self.isUp ? self.config.arrowH : 0; // 顶部Y值
    CGFloat maskBottom = self.isUp ? self.frame.size.height : self.frame.size.height - self.config.arrowH; // 底部Y值
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    // 左上圆角
    [maskPath moveToPoint:CGPointMake(0, self.config.cornerRadius + maskTop)];
    [maskPath addArcWithCenter:CGPointMake(self.config.cornerRadius, self.config.cornerRadius + maskTop)
                        radius:self.config.cornerRadius
                    startAngle:M_PI
                      endAngle:1.5*M_PI
                     clockwise:YES];
    // 箭头朝上
    if (self.isUp) {
        [maskPath addLineToPoint:CGPointMake(arrowPoint.x - self.config.arrowW/2, self.config.arrowH)];
        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x - self.config.arrowCornerRadius, self.config.arrowCornerRadius)
                         controlPoint:CGPointMake(arrowPoint.x - self.config.arrowW/2 + self.config.arrowCornerRadius, self.config.arrowH)];
        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x + self.config.arrowCornerRadius, self.config.arrowCornerRadius)
                         controlPoint:arrowPoint];
        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x + self.config.arrowW/2, self.config.arrowH)
                         controlPoint:CGPointMake(arrowPoint.x + self.config.arrowW/2 - self.config.arrowCornerRadius, self.config.arrowH)];
    }
    // 右上圆角
    [maskPath addLineToPoint:CGPointMake(self.frame.size.width - self.config.cornerRadius, maskTop)];
    [maskPath addArcWithCenter:CGPointMake(self.frame.size.width - self.config.cornerRadius, maskTop + self.config.cornerRadius)
                        radius:self.config.cornerRadius
                    startAngle:1.5*M_PI
                      endAngle:0
                     clockwise:YES];
    // 右下圆角
    [maskPath addLineToPoint:CGPointMake(self.frame.size.width, maskBottom - self.config.cornerRadius)];
    [maskPath addArcWithCenter:CGPointMake(self.frame.size.width - self.config.cornerRadius, maskBottom - self.config.cornerRadius)
                        radius:self.config.cornerRadius
                    startAngle:0
                      endAngle:0.5*M_PI
                     clockwise:YES];
    // 箭头朝下
    if (!self.isUp) {
        [maskPath addLineToPoint:CGPointMake(arrowPoint.x + self.config.arrowW/2, self.frame.size.height - self.config.arrowH)];
        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x + self.config.arrowCornerRadius, self.frame.size.height - self.config.arrowCornerRadius)
                         controlPoint:CGPointMake(arrowPoint.x + self.config.arrowW/2 - self.config.arrowCornerRadius, self.frame.size.height - self.config.arrowH)];
        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x - self.config.arrowCornerRadius, self.frame.size.height - self.config.arrowCornerRadius)
                         controlPoint:arrowPoint];
        [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x - self.config.arrowW/2, self.frame.size.height - self.config.arrowH)
                         controlPoint:CGPointMake(arrowPoint.x - self.config.arrowW/2 + self.config.arrowCornerRadius, self.frame.size.height - self.config.arrowH)];
    }
    // 左下圆角
    [maskPath addLineToPoint:CGPointMake(self.config.cornerRadius, maskBottom)];
    [maskPath addArcWithCenter:CGPointMake(self.config.cornerRadius, maskBottom - self.config.cornerRadius)
                        radius:self.config.cornerRadius
                    startAngle:0.5*M_PI
                      endAngle:M_PI
                     clockwise:YES];
    [maskPath closePath];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.bounds;
    shapeLayer.path = maskPath.CGPath;
    shapeLayer.lineWidth = 1/[UIScreen mainScreen].scale;
    shapeLayer.fillColor = self.config.fillColor.CGColor;
    shapeLayer.strokeColor = self.config.needBorder ? self.config.lineColor.CGColor : [UIColor clearColor].CGColor;
    [self.layer insertSublayer:shapeLayer atIndex:0];
    
    // 弹出动画
    self.maskView.alpha = 0;
    CGRect oldFrame = self.frame;
    self.layer.anchorPoint = CGPointMake(arrowPoint.x/self.frame.size.width, self.isUp ? 0.f : 1.f);
    self.frame = oldFrame;
    self.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    [UIView animateWithDuration:0.25f animations:^{
        self.transform = CGAffineTransformIdentity;
        self.maskView.alpha = 1.f;
    }];
}

//将maskView和popup加到window上
- (void)addToWindow {
    self.maskView.frame = self.menuSuperView.bounds;
    [self.menuSuperView addSubview:self.maskView];
    
    //点击手势
    UITapGestureRecognizer *tapGestureRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tapGestureRecognizer.cancelsTouchesInView = NO;//为yes只响应优先级最高的事件，Button高于手势，textfield高于手势，textview高于手势，手势高于tableview。为no同时都响应，默认为yes
    [self.maskView addGestureRecognizer:tapGestureRecognizer];
    
    [self.menuSuperView addSubview:self];
}

#pragma mark - Property
- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor clearColor];
    }
    return _maskView;
}

@end

