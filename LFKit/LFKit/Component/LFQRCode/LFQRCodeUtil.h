//
//  LFQRCodeUtil.h
//  LFQRCode
//
//  Created by 张林峰 on 2017/4/26.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LFQRCodeUtil : NSObject

/**直接从图片读取二维码*/
+ (NSString *)readQRCodeFromImage:(UIImage *)image;


/**
 生成二维码
 @param QRString 二维码内容
 @param sizeWidth 尺寸
 @param color 二维码颜色，注意要是深色冷色，否则不易识别（默认是黑色，黑色最易识别）
 @param logo 不是必传参数
 @return 二维码
 */
+(UIImage *)createQRimageString:(NSString *)QRString sizeWidth:(CGFloat)sizeWidth fillColor:(UIColor *)color logo:(UIImage *)logo;

/**将模糊图变清晰*/
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size;

@end
