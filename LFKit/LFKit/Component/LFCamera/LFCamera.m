//
//  LFCamera.m
//  LFCamera
//
//  Created by 张林峰 on 2017/4/25.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import "LFCamera.h"
#import <AVFoundation/AVFoundation.h>

@interface LFCamera () <UIGestureRecognizerDelegate>

//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic)AVCaptureDevice *device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property(nonatomic)AVCaptureDeviceInput *input;

//当启动摄像头开始捕获输入
@property(nonatomic)AVCaptureMetadataOutput *output;

@property (nonatomic)AVCaptureStillImageOutput *ImageOutPut;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property(nonatomic)AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;

/**记录开始的缩放比例*/
@property(nonatomic,assign) CGFloat beginGestureScale;

/** 最后的缩放比例*/
@property(nonatomic,assign) CGFloat effectiveScale;

@property (nonatomic, strong) CAShapeLayer * maskLayer;//半透明黑色遮罩
@property (nonatomic, strong) CAShapeLayer * effectiveRectLayer;//有效区域框
@property (nonatomic) BOOL isAuthorized;
@property (nonatomic) BOOL isFront;//是否前摄像头

@end

@implementation LFCamera

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.isAuthorized = [self canUseCamear];
        if (self.isAuthorized) {
            [self configCamera];
        }
        self.effectiveRectBorderColor = [UIColor orangeColor];
        self.maskColor = [UIColor colorWithWhite: 0 alpha: 0.75];
        //聚焦视图
        [self addSubview:self.focusView];
        
        //缩放手势
        self.effectiveScale = self.beginGestureScale = 1.0f;
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
        pinch.delegate = self;
        [self addGestureRecognizer:pinch];
    }
    return self;
}

- (void)dealloc {
    [self.session stopRunning];
}

- (void)layoutSubviews {
    self.maskLayer.path = [self getMaskPathWithRect:self.bounds exceptRect:self.effectiveRect].CGPath;
    self.previewLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)setEffectiveRect:(CGRect)effectiveRect {
    _effectiveRect = effectiveRect;
    if (_effectiveRect.size.width > 0) {
        [self setupEffectiveRect];
    }
}

- (void)configCamera{
    
    //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //使用设备初始化输入
    self.input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    
    //生成输出对象
    self.output = [[AVCaptureMetadataOutput alloc]init];
    self.ImageOutPut = [[AVCaptureStillImageOutput alloc] init];
    
    //生成会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc]init];
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1920x1080]) {
        self.session.sessionPreset = AVCaptureSessionPreset1920x1080;
    }
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.ImageOutPut]) {
        [self.session addOutput:self.ImageOutPut];
    }
    
    //使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.layer addSublayer:self.previewLayer];
    [self.layer insertSublayer:self.previewLayer atIndex:0];
    
    //开始启动
    [self.session startRunning];
    if ([_device lockForConfiguration:nil]) {
        if ([_device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [_device setFlashMode:AVCaptureFlashModeAuto];
        }
        //自动白平衡
        if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        [_device unlockForConfiguration];
    }
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [self addGestureRecognizer:tapGesture];
}

#pragma mark - Action

//聚焦手势
- (void)focusGesture:(UITapGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:gesture.view];
    
    CGSize size = gesture.view.bounds.size;
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1-point.x/size.width );
    NSError *error;
    if ([self.device lockForConfiguration:&error]) {
        
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.device setExposurePointOfInterest:focusPoint];
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.device unlockForConfiguration];
        _focusView.center = point;
        _focusView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                _focusView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                _focusView.hidden = YES;
            }];
        }];
    }
}

/**切换闪光灯*/
- (void)switchLight:(LFCaptureFlashMode)flashMode {
    //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
    if ([self.device hasFlash]) {
        if ((AVCaptureFlashMode)flashMode == self.device.flashMode) {
            return;
        }
        //修改前必须先锁定
        [self.device lockForConfiguration:nil];
        self.device.flashMode = (AVCaptureFlashMode)flashMode;
        self.device.torchMode = (AVCaptureTorchMode)flashMode;
        [self.device unlockForConfiguration];
        [self.session commitConfiguration];
    }
}

/**切换摄像头*/
- (void)switchCamera:(BOOL)isFront {
    //前后摄像头像素不一样，所以这里要处理下
    if (isFront) {
        if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
            self.session.sessionPreset = AVCaptureSessionPreset1280x720;
        }
    } else {
        if ([self.session canSetSessionPreset:AVCaptureSessionPreset1920x1080]) {
            self.session.sessionPreset = AVCaptureSessionPreset1920x1080;
        }
    }
    
    NSArray *inputs = self.session.inputs;
    for (AVCaptureDeviceInput *input in inputs ) {
        AVCaptureDevice *device = input.device;
        if ( [device hasMediaType:AVMediaTypeVideo] ) {
            AVCaptureDevicePosition position = isFront ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
            AVCaptureDevice *newCamera = [self cameraWithPosition:position];
            AVCaptureDeviceInput *newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
            // beginConfiguration ensures that pending changes are not applied immediately
            [self.session beginConfiguration];
            
            [self.session removeInput:input];
            [self.session addInput:newInput];
            
            // Changes take effect once the outermost commitConfiguration is invoked.
            [self.session commitConfiguration];
            self.isFront = isFront;
            break;
        }
    }
}

- (void)takePhoto:(void (^)(UIImage *img))resultBlock {
    AVCaptureConnection * videoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }
    
    [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *img = [UIImage imageWithData:imageData];
        [self.session stopRunning];
        if (self.effectiveRect.size.width > 0) {
            img = [self cutImage:img];
        }
        if (resultBlock) {
            resultBlock(img);
        }
        
    }];
}

#pragma mark - 方法

//相机是否可用
- (BOOL)canUseCamear{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        return NO;
    }
    else{
        return YES;
    }
    return YES;
}

/**配置拍摄范围*/
- (void)setupEffectiveRect{
    [self.layer addSublayer: self.maskLayer];
    [self.layer addSublayer: self.effectiveRectLayer];
}

/**生成空缺部分rect的layer*/
- (UIBezierPath *)getMaskPathWithRect: (CGRect)rect exceptRect: (CGRect)exceptRect
{
    if (!CGRectContainsRect(rect, exceptRect)) {
        return nil;
    }
    else if (CGRectEqualToRect(rect, CGRectZero)) {
        return nil;
    }
    
    CGFloat boundsInitX = CGRectGetMinX(rect);
    CGFloat boundsInitY = CGRectGetMinY(rect);
    CGFloat boundsWidth = CGRectGetWidth(rect);
    CGFloat boundsHeight = CGRectGetHeight(rect);
    
    CGFloat minX = CGRectGetMinX(exceptRect);
    CGFloat maxX = CGRectGetMaxX(exceptRect);
    CGFloat minY = CGRectGetMinY(exceptRect);
    CGFloat maxY = CGRectGetMaxY(exceptRect);
    CGFloat width = CGRectGetWidth(exceptRect);
    
    /** 添加路径*/
    UIBezierPath * path = [UIBezierPath bezierPathWithRect: CGRectMake(boundsInitX, boundsInitY, minX, boundsHeight)];
    [path appendPath: [UIBezierPath bezierPathWithRect: CGRectMake(minX, boundsInitY, width, minY)]];
    [path appendPath: [UIBezierPath bezierPathWithRect: CGRectMake(maxX, boundsInitY, boundsWidth - maxX, boundsHeight)]];
    [path appendPath: [UIBezierPath bezierPathWithRect: CGRectMake(minX, maxY, width, boundsHeight - maxY)]];
    
    return path;
}

//生成相应方向的摄像头设备
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices )
        if ( device.position == position )
            return device;
    return nil;
}

/**获取摄像头方向*/
- (BOOL)isCameraFront {
    return self.isFront;
}

/**获取闪光灯模式*/
- (LFCaptureFlashMode)getCaptureFlashMode {
    return (LFCaptureFlashMode)self.device.torchMode;
}

//裁剪
- (UIImage *)cutImage:(UIImage *)image {
    
    //起点x轴比例
    float orignXRate = self.effectiveRect.origin.x/self.frame.size.width;
    //起点y轴比例
    float orignYRate = self.effectiveRect.origin.y/self.frame.size.height;
    //图片缩放比例
    float imageZoomRate = self.frame.size.width/image.size.width;
    float orignX = image.size.width*orignXRate;
    float orignY = image.size.height*orignYRate;
    
    CGRect cutImageRect = CGRectZero;
    cutImageRect.origin.x = orignX;
    cutImageRect.origin.y = orignY;
    cutImageRect.size.width = self.effectiveRect.size.width/imageZoomRate;
    cutImageRect.size.height = self.effectiveRect.size.height/imageZoomRate;
    
    //下面代码百度的 不晓得什么意思。解决上面方法拍照会旋转90度
    CGFloat (^rad)(CGFloat) = ^CGFloat(CGFloat deg) {
        return deg / 180.0f * (CGFloat) M_PI;
    };
    
    CGAffineTransform rectTransform;
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(90)), 0, -image.size.height);
            break;
        case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-90)), -image.size.width, 0);
            break;
        case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-180)), -image.size.width, -image.size.height);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
    };
    
    // adjust the transformation scale based on the image scale
    rectTransform = CGAffineTransformScale(rectTransform, image.scale, image.scale);
    
    // apply the transformation to the rect to create a new, shifted rect
    CGRect transformedCropSquare = CGRectApplyAffineTransform(cutImageRect, rectTransform);
    
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, transformedCropSquare);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

- (void)restart {
    [self.session startRunning];
}

#pragma mark - 手势缩放焦距
//缩放手势 用于调整焦距
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer{
    
    BOOL allTouchesAreOnThePreviewLayer = YES;
    NSUInteger numTouches = [recognizer numberOfTouches];
    for (NSInteger i = 0; i < numTouches; ++i ) {
        CGPoint location = [recognizer locationOfTouch:i inView:self];
        CGPoint convertedLocation = [self.previewLayer convertPoint:location fromLayer:self.previewLayer.superlayer];
        if ( ! [self.previewLayer containsPoint:convertedLocation] ) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    
    if ( allTouchesAreOnThePreviewLayer ) {
        
        
        self.effectiveScale = self.beginGestureScale * recognizer.scale;
        if (self.effectiveScale < 1.0){
            self.effectiveScale = 1.0;
        }

        CGFloat maxScaleAndCropFactor = [[self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
        
        if (self.effectiveScale > maxScaleAndCropFactor) {
            self.effectiveScale = maxScaleAndCropFactor;
        }
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:.025];
        [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
        [CATransaction commit];
    }
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
}

#pragma mark - 懒加载

/** 有效区域框*/
- (CAShapeLayer *)effectiveRectLayer {
    if (!_effectiveRectLayer) {
        CGRect scanRect = self.effectiveRect;
        scanRect.origin.x -= 1;
        scanRect.origin.y -= 1;
        scanRect.size.width += 2;
        scanRect.size.height += 2;
        
        _effectiveRectLayer = [CAShapeLayer layer];
        _effectiveRectLayer.path = [UIBezierPath bezierPathWithRect:scanRect].CGPath;
        _effectiveRectLayer.fillColor = [UIColor clearColor].CGColor;
        _effectiveRectLayer.strokeColor = self.effectiveRectBorderColor.CGColor;
    }
    return _effectiveRectLayer;
}


/**黑色半透明遮掩层*/
- (CAShapeLayer *)maskLayer {
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer layer];
        _maskLayer.path = [self getMaskPathWithRect:self.bounds exceptRect:self.effectiveRect].CGPath;
        _maskLayer.fillColor = self.maskColor.CGColor;
    }
    return _maskLayer;
}

- (UIView *)focusView {
    if (!_focusView) {
        _focusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        _focusView.backgroundColor = [UIColor clearColor];
        _focusView.layer.borderColor = [UIColor greenColor].CGColor;
        _focusView.layer.borderWidth = 1;
        _focusView.hidden = YES;
    }
    return _focusView;
}


@end
