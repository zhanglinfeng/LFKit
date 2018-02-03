//
//  LFBubbleView.m
//  LFBubbleViewDemo
//
//  Created by 张林峰 on 16/6/29.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import "LFBubbleView.h"
#import "LFBubbleViewDefaultConfig.h"


@implementation LFBubbleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.color = [LFBubbleViewDefaultConfig sharedInstance].color;
        self.textColor = [LFBubbleViewDefaultConfig sharedInstance].textColor;
        self.font = [LFBubbleViewDefaultConfig sharedInstance].font;
        self.borderWidth = [LFBubbleViewDefaultConfig sharedInstance].borderWidth;
        self.borderColor = [LFBubbleViewDefaultConfig sharedInstance].borderColor;
        self.cornerRadius = [LFBubbleViewDefaultConfig sharedInstance].cornerRadius;
        self.triangleH = [LFBubbleViewDefaultConfig sharedInstance].triangleH;
        self.triangleW = [LFBubbleViewDefaultConfig sharedInstance].triangleW;
        self.edgeInsets = [LFBubbleViewDefaultConfig sharedInstance].edgeInsets;
        
        self.backgroundColor = [UIColor clearColor];
        _contentView = [[UIView alloc] init];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.contentView];
        
        self.lbTitle = [[UILabel alloc] init];
        self.lbTitle.backgroundColor = [UIColor clearColor];
        self.lbTitle.font = self.font;
        self.lbTitle.textColor = self.textColor;
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
    
    rect.origin.x = rect.origin.x + self.borderWidth;
    rect.origin.y = rect.origin.y + self.borderWidth;
    rect.size.width = rect.size.width - 2*self.borderWidth;
    rect.size.height = rect.size.height - 2*self.borderWidth;
    
    switch (self.direction) {
        case LFTriangleDirection_Down:
        {
            CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + self.cornerRadius);
            CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height - self.triangleH - self.cornerRadius);
            CGPathAddArc(path, NULL, rect.origin.x + self.cornerRadius, rect.origin.y + rect.size.height - self.triangleH - self.cornerRadius,
                         self.cornerRadius, M_PI, M_PI / 2, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleXY - self.triangleW/2,
                                 rect.origin.y + rect.size.height - self.triangleH);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleXY,
                                 rect.origin.y + rect.size.height);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleXY + self.triangleW/2,
                                 rect.origin.y + rect.size.height - self.triangleH);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - self.cornerRadius,
                                 rect.origin.y + rect.size.height - self.triangleH);
            CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - self.cornerRadius,
                         rect.origin.y + rect.size.height - self.triangleH - self.cornerRadius, self.cornerRadius, M_PI / 2, 0.0f, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + self.cornerRadius);
            CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - self.cornerRadius, rect.origin.y + self.cornerRadius,
                         self.cornerRadius, 0.0f, -M_PI / 2, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.cornerRadius, rect.origin.y);
            CGPathAddArc(path, NULL, rect.origin.x + self.cornerRadius, rect.origin.y + self.cornerRadius, self.cornerRadius,
                         -M_PI / 2, M_PI, 1);
        }
            break;
        case LFTriangleDirection_Up:
        {
            CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + self.cornerRadius + self.triangleH);
            CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height - self.cornerRadius);
            CGPathAddArc(path, NULL, rect.origin.x + self.cornerRadius, rect.origin.y + rect.size.height - self.cornerRadius,
                         self.cornerRadius, M_PI, M_PI / 2, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - self.cornerRadius,
                                 rect.origin.y + rect.size.height);
            CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - self.cornerRadius,
                         rect.origin.y + rect.size.height - self.cornerRadius, self.cornerRadius, M_PI / 2, 0.0f, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + self.triangleH + self.cornerRadius);
            CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - self.cornerRadius, rect.origin.y + self.triangleH + self.cornerRadius,
                         self.cornerRadius, 0.0f, -M_PI / 2, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleXY + self.triangleW/2,
                                 rect.origin.y + self.triangleH);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleXY,
                                 rect.origin.y);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleXY - self.triangleW/2,
                                 rect.origin.y + self.triangleH);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.cornerRadius, rect.origin.y + self.triangleH);
            CGPathAddArc(path, NULL, rect.origin.x + self.cornerRadius, rect.origin.y + self.triangleH + self.cornerRadius, self.cornerRadius,
                         -M_PI / 2, M_PI, 1);
            
        }
            break;
        case LFTriangleDirection_Left:
        {
            CGPathMoveToPoint(path, NULL, rect.origin.x + self.triangleH, rect.origin.y + self.cornerRadius);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleH, rect.origin.y + self.triangleXY - self.triangleW/2);
            CGPathAddLineToPoint(path, NULL, rect.origin.x,
                                 rect.origin.y + self.triangleXY);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleH,
                                 rect.origin.y + self.triangleXY + self.triangleW/2);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleH,
                                 rect.origin.y + rect.size.height - self.cornerRadius);
            
            CGPathAddArc(path, NULL, rect.origin.x + self.triangleH + self.cornerRadius, rect.origin.y + rect.size.height - self.cornerRadius,
                         self.cornerRadius, M_PI, M_PI / 2, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - self.cornerRadius,
                                 rect.origin.y + rect.size.height);
            CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - self.cornerRadius,
                         rect.origin.y + rect.size.height - self.cornerRadius, self.cornerRadius, M_PI / 2, 0.0f, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width,
                                 rect.origin.y + self.cornerRadius);
            CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - self.cornerRadius, rect.origin.y + self.cornerRadius,
                         self.cornerRadius, 0.0f, -M_PI / 2, 1);
            
            
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleH + self.cornerRadius, rect.origin.y);
            CGPathAddArc(path, NULL, rect.origin.x + self.triangleH + self.cornerRadius, rect.origin.y + self.cornerRadius, self.cornerRadius,
                         -M_PI / 2, M_PI, 1);
            
        }
            break;
        case LFTriangleDirection_Right:
        {
            CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + self.cornerRadius);
            CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height - self.cornerRadius);
            CGPathAddArc(path, NULL, rect.origin.x + self.cornerRadius, rect.origin.y + rect.size.height - self.cornerRadius,
                         self.cornerRadius, M_PI, M_PI / 2, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - self.triangleH - self.cornerRadius,
                                 rect.origin.y + rect.size.height);
            CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - self.triangleH - self.cornerRadius,
                         rect.origin.y + rect.size.height - self.cornerRadius, self.cornerRadius, M_PI / 2, 0.0f, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - self.triangleH,
                                 rect.origin.y + self.triangleXY + self.triangleW/2);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width,
                                 rect.origin.y + self.triangleXY);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - self.triangleH,
                                 rect.origin.y + self.triangleXY - self.triangleW/2);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - self.triangleH,
                                 rect.origin.y + self.cornerRadius);
            CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - self.triangleH - self.cornerRadius, rect.origin.y + self.cornerRadius,
                         self.cornerRadius, 0.0f, -M_PI / 2, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.cornerRadius,
                                 rect.origin.y);
            CGPathAddArc(path, NULL, rect.origin.x + self.cornerRadius, rect.origin.y + self.cornerRadius, self.cornerRadius,
                         -M_PI / 2, M_PI, 1);
            
            
        }
            break;
        default:
            break;
    }
    
    
    CGPathCloseSubpath(path);
    
    //填充气泡
    [self.color setFill];
    CGContextAddPath(context, path);
    CGContextSaveGState(context);
    //    CGContextSetShadowWithColor(context, CGSizeMake (0, self.yShadowOffset), 6, [UIColor colorWithWhite:0 alpha:.5].CGColor);
    CGContextFillPath(context);
    CGContextRestoreGState(context);
    
    // 边缘线
    if (self.borderColor && self.borderWidth > 0) {
        [self.borderColor setStroke];
        CGContextSetLineWidth(context, self.borderWidth);
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
    CGFloat padding = self.cornerRadius - self.cornerRadius/M_SQRT2 + self.borderWidth;
    switch (self.direction) {
        case LFTriangleDirection_Down:
        {
            self.frame = CGRectMake(point.x - self.triangleXY, point.y - self.frame.size.height, self.frame.size.width, self.frame.size.height);
            self.contentView.frame = CGRectMake(padding, padding, self.frame.size.width - 2 * padding, self.frame.size.height - 2 * padding - self.triangleH);
            
        }
            break;
        case LFTriangleDirection_Up:
        {
            self.frame = CGRectMake(point.x - self.triangleXY, point.y, self.frame.size.width, self.frame.size.height);
            self.contentView.frame = CGRectMake(padding, padding + self.triangleH, self.frame.size.width - 2 * padding, self.frame.size.height - 2 * padding - self.triangleH);
        }
            break;
        case LFTriangleDirection_Left:
        {
            self.frame = CGRectMake(point.x, point.y - self.triangleXY, self.frame.size.width, self.frame.size.height);
            self.contentView.frame = CGRectMake(self.triangleH + padding, padding, self.frame.size.width - 2 * padding - self.triangleH, self.frame.size.height - 2 * padding);
        }
            break;
        case LFTriangleDirection_Right:
        {
            self.frame = CGRectMake(point.x - self.frame.size.width, point.y - self.triangleXY, self.frame.size.width, self.frame.size.height);
            self.contentView.frame = CGRectMake(padding, padding, self.frame.size.width - 2 * padding - self.triangleH, self.frame.size.height - 2 * padding);
        }
            break;
        default:
            break;
    }
    
    CGFloat top = self.edgeInsets.top;
    CGFloat left = self.edgeInsets.left;
    CGFloat right = self.edgeInsets.right;
    CGFloat bottom = self.edgeInsets.bottom;
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
