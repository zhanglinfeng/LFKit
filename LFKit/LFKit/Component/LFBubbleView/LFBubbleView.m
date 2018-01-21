//
//  LFBubbleView.m
//  LFBubbleViewDemo
//
//  Created by 张林峰 on 16/6/29.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import "LFBubbleView.h"
#import <objc/runtime.h>

@implementation LFBubbleViewConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.color = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:12];
        self.cornerRadius = 5;
        self.triangleH = 7;
        self.triangleW = 7;
        self.edgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
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


@implementation LFBubbleViewDefaultConfig

static LFBubbleViewDefaultConfig *_instance = nil;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        _instance.config = [[LFBubbleViewConfig alloc] init];
    });
    return _instance;
}

@end


@implementation LFBubbleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.config = [[LFBubbleViewDefaultConfig sharedInstance].config copy];
        
        self.backgroundColor = [UIColor clearColor];
        _contentView = [[UIView alloc] init];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.contentView];
        
        self.lbTitle = [[UILabel alloc] init];
        self.lbTitle.backgroundColor = [UIColor clearColor];
        self.lbTitle.font = self.config.font;
        self.lbTitle.textColor = self.config.textColor;
        self.lbTitle.textAlignment = NSTextAlignmentCenter;
        self.lbTitle.numberOfLines = 0;
        [_contentView addSubview:self.lbTitle];
    }
    return self;
}

//数据配置
- (void)initData {
    
    if (self.triangleXY < 1) {
        if (self.triangleXYScale == 0) {
            self.triangleXYScale = 0.5;
        }
        if (self.direction == LFTriangleDirection_Down || self.direction == LFTriangleDirection_Up) {
            self.triangleXY = self.triangleXYScale * self.frame.size.width;
        } else {
            self.triangleXY = self.triangleXYScale * self.frame.size.height;
        }
        
    }
}

- (void)drawRect:(CGRect)rect {

    [self initData];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    rect.origin.x = rect.origin.x + self.config.borderWidth;
    rect.origin.y = rect.origin.y + self.config.borderWidth;
    rect.size.width = rect.size.width - 2*self.config.borderWidth;
    rect.size.height = rect.size.height - 2*self.config.borderWidth;
    
    switch (self.direction) {
        case LFTriangleDirection_Down:
        {
            CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + self.config.cornerRadius);
            CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height - self.config.triangleH - self.config.cornerRadius);
            CGPathAddArc(path, NULL, rect.origin.x + self.config.cornerRadius, rect.origin.y + rect.size.height - self.config.triangleH - self.config.cornerRadius,
                         self.config.cornerRadius, M_PI, M_PI / 2, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleXY - self.config.triangleW/2,
                                 rect.origin.y + rect.size.height - self.config.triangleH);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleXY,
                                 rect.origin.y + rect.size.height);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleXY + self.config.triangleW/2,
                                 rect.origin.y + rect.size.height - self.config.triangleH);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - self.config.cornerRadius,
                                 rect.origin.y + rect.size.height - self.config.triangleH);
            CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - self.config.cornerRadius,
                         rect.origin.y + rect.size.height - self.config.triangleH - self.config.cornerRadius, self.config.cornerRadius, M_PI / 2, 0.0f, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + self.config.cornerRadius);
            CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - self.config.cornerRadius, rect.origin.y + self.config.cornerRadius,
                         self.config.cornerRadius, 0.0f, -M_PI / 2, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.config.cornerRadius, rect.origin.y);
            CGPathAddArc(path, NULL, rect.origin.x + self.config.cornerRadius, rect.origin.y + self.config.cornerRadius, self.config.cornerRadius,
                         -M_PI / 2, M_PI, 1);
        }
            break;
        case LFTriangleDirection_Up:
        {
            CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + self.config.cornerRadius + self.config.triangleH);
            CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height - self.config.cornerRadius);
            CGPathAddArc(path, NULL, rect.origin.x + self.config.cornerRadius, rect.origin.y + rect.size.height - self.config.cornerRadius,
                         self.config.cornerRadius, M_PI, M_PI / 2, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - self.config.cornerRadius,
                                 rect.origin.y + rect.size.height);
            CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - self.config.cornerRadius,
                         rect.origin.y + rect.size.height - self.config.cornerRadius, self.config.cornerRadius, M_PI / 2, 0.0f, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + self.config.triangleH + self.config.cornerRadius);
            CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - self.config.cornerRadius, rect.origin.y + self.config.triangleH + self.config.cornerRadius,
                         self.config.cornerRadius, 0.0f, -M_PI / 2, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleXY + self.config.triangleW/2,
                                 rect.origin.y + self.config.triangleH);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleXY,
                                 rect.origin.y);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleXY - self.config.triangleW/2,
                                 rect.origin.y + self.config.triangleH);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.config.cornerRadius, rect.origin.y + self.config.triangleH);
            CGPathAddArc(path, NULL, rect.origin.x + self.config.cornerRadius, rect.origin.y + self.config.triangleH + self.config.cornerRadius, self.config.cornerRadius,
                         -M_PI / 2, M_PI, 1);
            
        }
            break;
        case LFTriangleDirection_Left:
        {
            CGPathMoveToPoint(path, NULL, rect.origin.x + self.config.triangleH, rect.origin.y + self.config.cornerRadius);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.config.triangleH, rect.origin.y + self.triangleXY - self.config.triangleW/2);
            CGPathAddLineToPoint(path, NULL, rect.origin.x,
                                 rect.origin.y + self.triangleXY);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.config.triangleH,
                                 rect.origin.y + self.triangleXY + self.config.triangleW/2);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.config.triangleH,
                                 rect.origin.y + rect.size.height - self.config.cornerRadius);
            
            CGPathAddArc(path, NULL, rect.origin.x + self.config.triangleH + self.config.cornerRadius, rect.origin.y + rect.size.height - self.config.cornerRadius,
                         self.config.cornerRadius, M_PI, M_PI / 2, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - self.config.cornerRadius,
                                 rect.origin.y + rect.size.height);
            CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - self.config.cornerRadius,
                         rect.origin.y + rect.size.height - self.config.cornerRadius, self.config.cornerRadius, M_PI / 2, 0.0f, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width,
                                 rect.origin.y + self.config.cornerRadius);
            CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - self.config.cornerRadius, rect.origin.y + self.config.cornerRadius,
                         self.config.cornerRadius, 0.0f, -M_PI / 2, 1);
            
            
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.config.triangleH + self.config.cornerRadius, rect.origin.y);
            CGPathAddArc(path, NULL, rect.origin.x + self.config.triangleH + self.config.cornerRadius, rect.origin.y + self.config.cornerRadius, self.config.cornerRadius,
                         -M_PI / 2, M_PI, 1);
            
        }
            break;
        case LFTriangleDirection_Right:
        {
            CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + self.config.cornerRadius);
            CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height - self.config.cornerRadius);
            CGPathAddArc(path, NULL, rect.origin.x + self.config.cornerRadius, rect.origin.y + rect.size.height - self.config.cornerRadius,
                         self.config.cornerRadius, M_PI, M_PI / 2, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - self.config.triangleH - self.config.cornerRadius,
                                 rect.origin.y + rect.size.height);
            CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - self.config.triangleH - self.config.cornerRadius,
                         rect.origin.y + rect.size.height - self.config.cornerRadius, self.config.cornerRadius, M_PI / 2, 0.0f, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - self.config.triangleH,
                                 rect.origin.y + self.triangleXY + self.config.triangleW/2);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width,
                                 rect.origin.y + self.triangleXY);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - self.config.triangleH,
                                 rect.origin.y + self.triangleXY - self.config.triangleW/2);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - self.config.triangleH,
                                 rect.origin.y + self.config.cornerRadius);
            CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - self.config.triangleH - self.config.cornerRadius, rect.origin.y + self.config.cornerRadius,
                         self.config.cornerRadius, 0.0f, -M_PI / 2, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.config.cornerRadius,
                                 rect.origin.y);
            CGPathAddArc(path, NULL, rect.origin.x + self.config.cornerRadius, rect.origin.y + self.config.cornerRadius, self.config.cornerRadius,
                         -M_PI / 2, M_PI, 1);
            
            
        }
            break;
        default:
            break;
    }
    
    
    CGPathCloseSubpath(path);
    
    //填充气泡
    [self.config.color setFill];
    CGContextAddPath(context, path);
    CGContextSaveGState(context);
    //    CGContextSetShadowWithColor(context, CGSizeMake (0, self.yShadowOffset), 6, [UIColor colorWithWhite:0 alpha:.5].CGColor);
    CGContextFillPath(context);
    CGContextRestoreGState(context);
    
    // 边缘线
    if (self.config.borderColor && self.config.borderWidth > 0) {
        [self.config.borderColor setStroke];
        CGContextSetLineWidth(context, self.config.borderWidth);
        CGContextSetLineCap(context, kCGLineCapSquare);
        CGContextAddPath(context, path);
        CGContextStrokePath(context);
    }
    
    CGPathRelease(path);
    CGColorSpaceRelease(space);
  
}

#pragma mark - 公有方法

-(void)setDismissAfterSecond:(CGFloat)dismissAfterSecond {
    _dismissAfterSecond = dismissAfterSecond;
    if (_dismissAfterSecond > 0) {
        __block LFBubbleView *blockTips = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_dismissAfterSecond * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [blockTips removeFromSuperview];
        });
    }
}

-(void)showInPoint:(CGPoint)point {
    
    if (self.showOnceKey) {
        BOOL hasShow  = [[NSUserDefaults standardUserDefaults] boolForKey:self.showOnceKey];
        if (hasShow) {
            self.hidden = YES;
            [self removeFromSuperview];
            return;
        }
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:self.showOnceKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    //数据配置
    [self initData];
    //contentView与self的边距
    CGFloat padding = self.config.cornerRadius - self.config.cornerRadius/M_SQRT2 + self.config.borderWidth;
    switch (self.direction) {
        case LFTriangleDirection_Down:
        {
            self.frame = CGRectMake(point.x - self.triangleXY, point.y - self.frame.size.height, self.frame.size.width, self.frame.size.height);
            self.contentView.frame = CGRectMake(padding, padding, self.frame.size.width - 2 * padding, self.frame.size.height - 2 * padding - self.config.triangleH);
            
        }
            break;
        case LFTriangleDirection_Up:
        {
            self.frame = CGRectMake(point.x - self.triangleXY, point.y, self.frame.size.width, self.frame.size.height);
            self.contentView.frame = CGRectMake(padding, padding + self.config.triangleH, self.frame.size.width - 2 * padding, self.frame.size.height - 2 * padding - self.config.triangleH);
        }
            break;
        case LFTriangleDirection_Left:
        {
            self.frame = CGRectMake(point.x, point.y - self.triangleXY, self.frame.size.width, self.frame.size.height);
            self.contentView.frame = CGRectMake(self.config.triangleH + padding, padding, self.frame.size.width - 2 * padding - self.config.triangleH, self.frame.size.height - 2 * padding);
        }
            break;
        case LFTriangleDirection_Right:
        {
            self.frame = CGRectMake(point.x - self.frame.size.width, point.y - self.triangleXY, self.frame.size.width, self.frame.size.height);
            self.contentView.frame = CGRectMake(padding, padding, self.frame.size.width - 2 * padding - self.config.triangleH, self.frame.size.height - 2 * padding);
        }
            break;
        default:
            break;
    }
    
    CGFloat top = self.config.edgeInsets.top;
    CGFloat left = self.config.edgeInsets.left;
    CGFloat right = self.config.edgeInsets.right;
    CGFloat bottom = self.config.edgeInsets.bottom;
    self.lbTitle.frame = CGRectMake(left - padding, top - padding, self.frame.size.width - left - right, self.frame.size.height - top - bottom);
}

/**来回平移动画*/
- (void)doTranslationAnimate{
    CGFloat animateGap = 0.35;
    CGFloat timeInterval = animateGap * 2;
    CGFloat offsetX = 0;
    CGFloat offsetY = 0;
    if (self.direction == LFTriangleDirection_Down) {
        offsetY = -5;
    } else if (self.direction == LFTriangleDirection_Up) {
        offsetY = 5;
    } else if (self.direction == LFTriangleDirection_Left) {
        offsetX = 5;
    } else if (self.direction == LFTriangleDirection_Right) {
        offsetX = -5;
    }
    
    [UIView animateKeyframesWithDuration:timeInterval delay:0 options:UIViewKeyframeAnimationOptionRepeat animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:animateGap animations:^{
            self.center = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
        }];
        [UIView addKeyframeWithRelativeStartTime:animateGap relativeDuration:animateGap animations:^{
            self.center = CGPointMake(self.center.x - offsetX, self.center.y - offsetY);
        }];
        
    } completion:^(BOOL finished) {
        //
    }];
}

- (void)doSpringAnimate {
    CGFloat offsetX = 0;
    CGFloat offsetY = 0;
    if (self.direction == LFTriangleDirection_Down) {
        offsetY = -5;
    } else if (self.direction == LFTriangleDirection_Up) {
        offsetY = 5;
    } else if (self.direction == LFTriangleDirection_Left) {
        offsetX = 5;
    } else if (self.direction == LFTriangleDirection_Right) {
        offsetX = -5;
    }
    [UIView animateWithDuration:3 delay:0 usingSpringWithDamping:0.1 initialSpringVelocity:2 options:UIViewAnimationOptionRepeat animations:^{
        self.center = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
    } completion:^(BOOL finished) {
        
    }];
}


@end
