//
//  LFQRCodeScanner.m
//  LFQRCode
//
//  Created by 张林峰 on 2017/4/26.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import "LFQRCodeScanner.h"

@interface LFQRCodeScanner ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession * session;
@property (nonatomic, strong) AVCaptureDeviceInput * input;
@property (nonatomic, strong) AVCaptureMetadataOutput * output;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * scanView;
@property (nonatomic, strong) CAShapeLayer * maskLayer;
@property (nonatomic, strong) CAShapeLayer * scanRectLayer;
@property (nonatomic, assign) CGRect scanRect;

@end

@implementation LFQRCodeScanner

- (instancetype)initWithFrame:(CGRect)frame rectOfInterest:(CGRect)rect {
    self = [super initWithFrame:frame];
    if (self) {
        self.scanRect = rect;
        [self initUI];
        self.layer.masksToBounds = YES;
    }
    return self;
}

/**
 *  释放前停止会话
 */
- (void)dealloc {
    [self stop];
}

/**
 初始化UI
 */
- (void)initUI {
    [self.layer addSublayer: self.scanView];
    [self setupScanRect];
    [self addSubview:self.imgLine];
    [self startAnimation];
}

/**配置扫描范围*/
- (void)setupScanRect {
    self.output.rectOfInterest = CGRectMake(self.scanRect.origin.y / self.frame.size.height, self.scanRect.origin.x / self.frame.size.width, self.scanRect.size.height / self.frame.size.height, self.scanRect.size.width / self.frame.size.width);
    
    [self.layer addSublayer: self.maskLayer];
    [self.layer addSublayer: self.scanRectLayer];
}

#pragma mark - 公有方法
/**
 *  开始捕捉画面
 */
- (void)start {
    [self.session startRunning];

   [self startAnimation];
}

/**
 *  停止捕捉画面
 */
- (void)stop {
    [self.session stopRunning];
    [self.imgLine.layer removeAllAnimations];
}

#pragma mark - 私有方法

/**
 *  生成空缺部分rect的layer
 */
- (CAShapeLayer *)generateMaskLayerWithRect: (CGRect)rect exceptRect: (CGRect)exceptRect
{
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    if (!CGRectContainsRect(rect, exceptRect)) {
        return nil;
    }
    else if (CGRectEqualToRect(rect, CGRectZero)) {
        maskLayer.path = [UIBezierPath bezierPathWithRect:rect].CGPath;
        return maskLayer;
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
    maskLayer.path = path.CGPath;
    
    return maskLayer;
}

/**
 扫描动画
 */
-(void)startAnimation {
    CABasicAnimation *translation = [CABasicAnimation animationWithKeyPath:@"position"];
    translation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.scanRect.origin.x + self.scanRect.size.width/2.0, self.scanRect.origin.y + 7)];
    translation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.scanRect.origin.x + self.scanRect.size.width/2.0, self.scanRect.origin.y + self.scanRect.size.height - 7)];
    translation.duration = 2;
    translation.repeatCount = HUGE_VALF;
    translation.autoreverses = YES;
    [self.imgLine.layer addAnimation:translation forKey:@"translation"];
}

#pragma mark - 懒加载

/**
 *  会话对象
 */
- (AVCaptureSession *)session
{
    if (!_session) {
        _session = [AVCaptureSession new];
        [_session setSessionPreset: AVCaptureSessionPresetHigh];    //高质量采集
        
        //配置输入输出设置
        if ([_session canAddInput: self.input]) {
            [_session addInput:self.input];
        }
        if ([_session canAddOutput: self.output]) {
            [_session addOutput:self.output];
            self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        }
    }
    return _session;
}

/**
 *  视频输入设备
 */
- (AVCaptureDeviceInput *)input
{
    if (!_input) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo];
        _input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    }
    return _input;
}

/**
 *  数据输出对象
 */
- (AVCaptureMetadataOutput *)output
{
    if (!_output) {
        _output = [AVCaptureMetadataOutput new];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    }
    return _output;
}

/**
 *  扫描视图
 */
- (AVCaptureVideoPreviewLayer *)scanView
{
    if (!_scanView) {
        _scanView = [AVCaptureVideoPreviewLayer layerWithSession: self.session];
        _scanView.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _scanView.frame = self.bounds;
    }
    return _scanView;
}

/**
 *  扫描框
 */
- (CAShapeLayer *)scanRectLayer
{
    if (!_scanRectLayer) {
        CGRect scanRect = self.scanRect;
        scanRect.origin.x -= 1;
        scanRect.origin.y -= 1;
        scanRect.size.width += 2;
        scanRect.size.height += 2;
        
        _scanRectLayer = [CAShapeLayer layer];
        _scanRectLayer.path = [UIBezierPath bezierPathWithRect:scanRect].CGPath;
        _scanRectLayer.fillColor = [UIColor clearColor].CGColor;
        _scanRectLayer.strokeColor = [UIColor orangeColor].CGColor;
    }
    return _scanRectLayer;
}


/**
 *  黑色半透明遮掩层
 */
- (CAShapeLayer *)maskLayer
{
    if (!_maskLayer) {
        _maskLayer = [self generateMaskLayerWithRect:self.bounds exceptRect:self.scanRect];
        _maskLayer.fillColor = [UIColor colorWithWhite: 0 alpha: 0.75].CGColor;
    }
    return _maskLayer;
}

- (UIImageView *)imgLine {
    if (!_imgLine) {
        _imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(self.scanRect.origin.x + 10, self.scanRect.origin.y + 5, self.scanRect.size.width - 20, 4)];
    }
    return _imgLine;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
/**
 *  二维码扫描数据返回
 */
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0) {
        [self stop];
        AVMetadataMachineReadableCodeObject * metadataObject = metadataObjects[0];
        if (self.scanFilishBlock) {
            self.scanFilishBlock(metadataObject);
        }
    }
}

@end
