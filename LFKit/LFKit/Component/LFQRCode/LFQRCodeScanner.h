//
//  LFQRCodeScanner.h
//  LFQRCode
//
//  Created by 张林峰 on 2017/4/26.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface LFQRCodeScanner : UIView

@property (nonatomic, strong) UIImageView *imgLine;//扫描线
@property (nonatomic, copy) void (^scanFilishBlock)(AVMetadataMachineReadableCodeObject *result);



/**
 初始化扫描view
 @param frame 注意：frame要传准确的
 @param rect 扫描有效区，即中间空缺部分
 */
- (instancetype)initWithFrame:(CGRect)frame rectOfInterest:(CGRect)rect;

/**开始扫描*/
- (void)start;
/**结束扫描*/
- (void)stop;

@end
