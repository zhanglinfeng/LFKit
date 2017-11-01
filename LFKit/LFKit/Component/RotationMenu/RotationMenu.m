//
//  RotationMenu.m
//  BaseAPP
//
//  Created by 张林峰 on 15/12/23.
//  Copyright © 2015年 张林峰. All rights reserved.
//

#import "RotationMenu.h"

//x为数学中的角度，如sinf(kCovertAngelToRadian(45))就是数学中的sin 45°
#define kCovertAngelToRadian(x) ((x)*M_PI)/180

//偏移角度
#define kAugularOffset 0

@interface RotationMenu ()

@property (nonatomic) NSInteger buttonCount;
@property (nonatomic) CGFloat menuCenterX;
@property (nonatomic) CGFloat menuCenterY;
@property (nonatomic) CGFloat menuRadius;
@property (strong, nonatomic) UIButton *centerButton;
@property (strong, nonatomic) NSMutableArray *buttons;
@property (nonatomic) BOOL isExpanded;

@end

@implementation RotationMenu

-(id)initWithMenuRadius:(CGFloat)menuRadius
           centerRadius:(NSInteger)centerRadius
              subRadius:(CGFloat)subRadius
            centerImage:(NSString *)centerImageName
       centerBackground:(NSString *)centerBackgroundName
          subImagesName:(NSArray *)arraySubImgs
            MenuCenterX:(CGFloat)x MenuCenterY:(CGFloat)y
           toParentView:(UIView *)parentView {
    self.menuCenterX = x;
    self.menuCenterY = y;
    self.buttonCount = arraySubImgs.count;
    self.menuRadius = menuRadius;
    self = [super initWithFrame:parentView.bounds];
    if (self) {
        [self configureCenterButton:centerRadius image:centerImageName backgroundImage:centerBackgroundName];
        [self configureSubButtonsWithRadius:subRadius ImgsName:arraySubImgs];
        [parentView addSubview:self];
    }
    return self;
}

- (void)configureCenterButton:(CGFloat)centerRadius image:(NSString *)imageName backgroundImage:(NSString *)backgroundImageName{
    self.centerButton = [[UIButton alloc]init];
    self.centerButton.frame = CGRectMake(0, 0, centerRadius * 2, centerRadius * 2);
    self.centerButton.center = CGPointMake(self.menuCenterX, self.menuCenterY);
    [self.centerButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self.centerButton setBackgroundImage:[UIImage imageNamed:backgroundImageName] forState:UIControlStateNormal];
    [self.centerButton addTarget:self action:@selector(centerButtonPress) forControlEvents:UIControlEventTouchUpInside];
    self.centerButton.layer.zPosition = 1;
    [self addSubview:self.centerButton];
}

- (void)centerButtonPress{
    float du = 360 / _buttonCount;
    if (![self isExpanded]) {
        for (NSInteger i = 0; i < _buttonCount; i++) {
            CGPoint p = CGPointMake(_menuCenterX + _menuRadius * sinf(kCovertAngelToRadian(kAugularOffset + du * i)), _menuCenterY - _menuRadius * cosf(kCovertAngelToRadian(kAugularOffset + du * i)));
            [self button:[self.buttons objectAtIndex:i] appearAt:p withDalay:0.5 + i * 0.05 duration:0.35 + i*0.05];
        }
        self.isExpanded = YES;
    }
    else{
        for (NSInteger i = 0; i < _buttonCount; i++) {
            CGPoint p = CGPointMake(_menuCenterX + _menuRadius * sinf(kCovertAngelToRadian(kAugularOffset + du * i)), _menuCenterY - _menuRadius * cosf(kCovertAngelToRadian(kAugularOffset + du * i)));
            float axisY = 0;
            float axisX = 0;
            if (fabs(p.x - self.frame.size.width / 2) < 0.001) {
                axisX = 0;
            } else if (p.x < self.frame.size.width / 2) {
                axisX = -20;
            } else {
                axisX = 20;
            }
            
            if (fabs(p.y - self.frame.size.height / 2) < 0.001) {
                axisY = 0;
            } else if (p.y < self.frame.size.height / 2) {
                axisY = -20;
            } else {
                axisY = 20;
            }
            
            [self button:[self.buttons objectAtIndex:i]
                shrinkAt:p
             offsetAxisX:axisX
             offSEtAxisY:axisY
               withDelay:0.4 + 0.1 * i
       animationDuration:1 + 0.2 * i];
        }
        [self centerButtonAnimation];
        self.isExpanded = NO;
    }
}


- (void)configureSubButtonsWithRadius:(CGFloat)subRadius ImgsName:(NSArray *)arrayImgName{
    
    //  Configure out the sub button's location parameter
    self.buttons = [NSMutableArray array];
    for (NSInteger i = 0; i<arrayImgName.count; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = i;
        btn.frame = CGRectMake(0, 0, subRadius * 2, subRadius * 2);
        btn.center = CGPointMake(-self.frame.size.width/2, -self.frame.size.height/2);;
        NSString *imageFormat = arrayImgName[i];
        [btn setBackgroundImage:[UIImage imageNamed:imageFormat] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.buttons addObject:btn];
    }
}

- (void)buttonAction:(UIButton *)btn {
    _btnBlock(btn);
}

#pragma mark - The center button and the sub button's animations

- (void)button:(UIButton *)button appearAt:(CGPoint)location withDalay:(CGFloat)delay duration:(CGFloat)duration{
    button.center = location;
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.duration = duration;
    scaleAnimation.values =  [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 1)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)], nil];
    scaleAnimation.calculationMode = kCAAnimationLinear;
    scaleAnimation.keyTimes =[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:delay],[NSNumber numberWithFloat:1.0f], nil];;
    
    button.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
    [button.layer addAnimation:scaleAnimation forKey:@"buttonAppear"];
}

- (void)button:(UIButton *)button shrinkAt:(CGPoint)location offsetAxisX:(CGFloat)axisX offSEtAxisY:(CGFloat)axisY withDelay:(CGFloat)delay animationDuration:(CGFloat)duration{
    CAKeyframeAnimation *rotation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotation.duration = duration * delay;
    rotation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:M_PI*2],[NSNumber numberWithFloat:0.0f], nil];;
    rotation.keyTimes =[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:delay],[NSNumber numberWithFloat:1.0f], nil];;
    
    CAKeyframeAnimation *shrink = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    shrink.duration = duration * (1 - delay);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, location.x, location.y);
    CGPathAddLineToPoint(path, NULL, location.x + axisX, location.y + axisY);
    CGPathAddLineToPoint(path, NULL, _menuCenterX, _menuCenterY);
    shrink.path = path;
    
    CGPathRelease(path);
    
    CAAnimationGroup *totalAnimation = [CAAnimationGroup animation];
    totalAnimation.duration = 1.0f;
    totalAnimation.animations=[NSArray arrayWithObjects:rotation,shrink, nil];
    totalAnimation.fillMode = kCAFillModeForwards;
    totalAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//    totalAnimation.delegate = self;
    
    button.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
    button.center = CGPointMake(- self.frame.size.width / 2, - self.frame.size.height / 2);
    [button.layer addAnimation:totalAnimation forKey:@"buttonDismiss"];
}



- (void)centerButtonAnimation{
    CAKeyframeAnimation *centerZoom = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    centerZoom.duration = 1.0f;
    centerZoom.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)], nil];
    centerZoom.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_centerButton.layer addAnimation:centerZoom forKey:@"buttonScale"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
