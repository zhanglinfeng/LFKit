//
//  LFBigImageCell.m
//  LFKit
//
//  Created by 张林峰 on 2018/6/2.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import "LFBigImageCell.h"
#import "UIImageView+YYWebImage.h"
#import "MBProgressHUD.h"

@interface LFBigImageCell ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageBGView;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@end

@implementation LFBigImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageBGView];
        [self addSubview:self.indicator];
        [self resetSubviewSize];
    }
    return self;
}

-(void)layoutSubviews {
   [self resetSubviewSize];
}

- (void)setPhoto:(LFPhotoModel *)photo {
    _photo = photo;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat width = self.frame.size.width;
    CGSize size = CGSizeMake(width*scale, width*scale*photo.asset.pixelHeight/photo.asset.pixelWidth);
    
    if (photo.image) {
        self.imageBGView.image = photo.image;
        [self resetSubviewSize];
    } else if (photo.bigImageUrl.length > 0) {
        UIImage *cachedImgBig = [[YYImageCache sharedCache] getImageForKey:photo.bigImageUrl];
        
        if (cachedImgBig) {
            self.imageBGView.image = cachedImgBig;
            [self resetSubviewSize];
        } else {
            if (photo.smallImageUrl.length > 0) {
                UIImage *cachedImg = [[YYImageCache sharedCache] getImageForKey:photo.smallImageUrl];
                if (cachedImg) {
                    self.placeholder = cachedImg;
                }
            } else if (photo.smallImage){
                self.placeholder = photo.smallImage;
            }
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
            // Set the annular determinate mode to show task progress.
            hud.mode = MBProgressHUDModeDeterminate;
            __block MBProgressHUD *bHud = hud;
            __weak typeof(self) weakself = self;
            NSURL *URL = [NSURL URLWithString:photo.bigImageUrl];
            [self.imageBGView yy_setImageWithURL:URL placeholder:self.placeholder options:YYWebImageOptionProgressiveBlur | YYWebImageOptionProgressive progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    bHud.progress = (float)receivedSize/(float)expectedSize;
                });
            } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakself resetSubviewSize];
                    [bHud hideAnimated:YES];
                });
            }];
        }
        
    } else if (photo.asset) {
        
        // 如果有小图，先显示，防止拿相册图比较慢
        if (photo.smallImage) {
            self.imageBGView.image = photo.smallImage;
            [self resetSubviewSize];
        }
        
        [self.indicator startAnimating];
        [LFPhotoModel requestImageForAsset:photo.asset size:size resizeMode:PHImageRequestOptionsResizeModeFast needThumbnails:YES completion:^(UIImage *image, NSDictionary *info) {
            if ([NSThread currentThread] != [NSThread mainThread]) {
                NSLog(@"*********不在主线程3*********");
            }
            self.imageBGView.image = image;
            [self resetSubviewSize];
            if (![[info objectForKey:PHImageResultIsDegradedKey] boolValue]) {
                [self.indicator stopAnimating];
            }
        }];
        
        
    }
}

- (void)resetSubviewSize
{
    CGRect frame;
    frame.origin = CGPointZero;
//    NSLog(@"********resetSubviewSize Cell,w=%f,h=%f",self.frame.size.width,self.frame.size.height);
    UIImage *image = self.imageBGView.image;
    CGFloat imageH = image.size.height;
    CGFloat imageW = image.size.width;
    
//    NSLog(@"********resetSubviewSize UIImage,w=%f,h=%f",imageW,imageH);
    if (!image) {
        imageH = self.frame.size.height;
        imageW = self.frame.size.width;
    }
    CGFloat imageScale = imageH/imageW;
    
    if (self.frame.size.width > self.frame.size.height) {//横屏
        CGFloat displayW = self.frame.size.height/imageScale;
        if (displayW <= self.frame.size.width) {
            frame = CGRectMake((self.frame.size.width - displayW)*0.5, 0, displayW, self.frame.size.height);
        } else {
            frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        }
    } else {
        CGFloat displayH = imageScale * self.frame.size.width;
        if (displayH <= self.frame.size.height) {
            frame = CGRectMake(0, (self.frame.size.height - displayH) * 0.5 , self.frame.size.width, displayH);
        } else {
            frame = CGRectMake(0, 0, self.frame.size.width, displayH);
        }
    }
    
    
    if (isnan(frame.size.width) || isnan(frame.size.height) ) { //高度计算后做一次容错，frame异常的不做布局
        return;
    }
    self.scrollView.zoomScale = 1;
    self.scrollView.contentSize = frame.size;
    [self.scrollView scrollRectToVisible:self.bounds animated:NO];
    self.imageBGView.frame = frame;
//    self.imageBGView.center = self.scrollView.center;
}

#pragma mark - 手势点击事件

- (void)singleTapAction:(UITapGestureRecognizer *)singleTap
{
    if (self.singleTapCallBack) self.singleTapCallBack();
}

- (void)doubleTapAction:(UITapGestureRecognizer *)tap
{
    UIScrollView *scrollView = (UIScrollView *)tap.view;
    
    CGFloat scale = 1;
    if (scrollView.zoomScale != 3.0) {
        scale = 3;
    } else {
        scale = 1;
    }
    CGRect zoomRect = [self zoomRectForScale:scale withCenter:[tap locationInView:tap.view]];
    [scrollView zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.scrollView.frame.size.height / scale;
    zoomRect.size.width  = self.scrollView.frame.size.width  / scale;
    zoomRect.origin.x    = center.x - (zoomRect.size.width  /2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height /2.0);
    return zoomRect;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return scrollView.subviews[0];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
    
    [self.imageBGView setCenter:CGPointMake(xcenter, ycenter)];
}

- (UIImage *)getImage {
    return self.imageBGView.image;
}

#pragma mark - 懒加载

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = self.bounds;
        _scrollView.maximumZoomScale = 3.0;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        [_scrollView addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
        doubleTap.numberOfTapsRequired = 2;
        [_scrollView addGestureRecognizer:doubleTap];
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
    }
    return _scrollView;
}

- (UIImageView *)imageBGView
{
    if (!_imageBGView) {
        _imageBGView = [[UIImageView alloc] init];
        _imageBGView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageBGView;
}

- (UIActivityIndicatorView *)indicator
{
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicator.hidesWhenStopped = YES;
        _indicator.center = self.contentView.center;
    }
    return _indicator;
}

@end
