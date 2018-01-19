//
//  UIImage+LF.m
//  APPBaseSDK
//
//  Created by 张林峰 on 16/5/29.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import "UIImage+LF.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (LF)

/**生成纯色图片*/
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    size = CGSizeMake(size.width*[UIScreen mainScreen].scale, size.height*[UIScreen mainScreen].scale);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *myImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return myImage;
}

/**生成渐变色图片*/
+ (UIImage *)imageWithRect:(CGSize)size StartColor:(UIColor *)startColor endColor:(UIColor *)endColor StartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    
    size = CGSizeMake(size.width*[UIScreen mainScreen].scale, size.height*[UIScreen mainScreen].scale);
    CIFilter *ciFilter = [CIFilter filterWithName:@"CILinearGradient"];
    
    /*
     * Note that the coordinate used by Core Image ((0, 0) at bottomleft)
     * is different from the one used by CGContext ((0, 0) at topleft).
     */
    CIVector *vector0 = [CIVector vectorWithX:size.width * startPoint.x Y:size.height * (1 - startPoint.y)];
    CIVector *vector1 = [CIVector vectorWithX:size.width * endPoint.x Y:size.height * (1 - endPoint.y)];
    [ciFilter setValue:vector0 forKey:@"inputPoint0"];
    [ciFilter setValue:vector1 forKey:@"inputPoint1"];
    [ciFilter setValue:[CIColor colorWithCGColor:startColor.CGColor] forKey:@"inputColor0"];
    [ciFilter setValue:[CIColor colorWithCGColor:endColor.CGColor] forKey:@"inputColor1"];
    
    CIImage *ciImage = ciFilter.outputImage;
    
    /*
     * Important: Some Core Image filters produce images of infinite extent,
     * such as those in the CICategoryTileEffect category.
     * Prior to rendering, infinite images must either be cropped (CICrop filter)
     * or you must specify a rectangle of finite dimensions for rendering the image.
     * https://developer.apple.com/library/mac/documentation/GraphicsImaging/Conceptual/CoreImaging/ci_tasks/ci_tasks.html
     * So directly init a UIImage with CIImage using imageWithCIImage is not going to work.
     */
    CIContext* con = [CIContext contextWithOptions:nil];
    CGImageRef resultCGImage = [con createCGImage:ciImage
                                         fromRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *resultUIImage = [UIImage imageWithCGImage:resultCGImage];
    return resultUIImage;
}

+ (UIImage *)imageWithRect:(CGSize)size color:(UIColor *)color direction:(TriangleDirection)direction {
    
    size = CGSizeMake(size.width*[UIScreen mainScreen].scale, size.height*[UIScreen mainScreen].scale);
    
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIImage *myImage = [UIImage imageWithColor:color size:size];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint sPoints[3];//坐标点
    if (direction == TriangleDirection_Down) {
        sPoints[0] =CGPointMake(0, 0);//坐标1
        sPoints[1] =CGPointMake(size.width, 0);//坐标2
        sPoints[2] =CGPointMake(size.width/2, size.height);//坐标3
    } else if (direction == TriangleDirection_Up) {
        sPoints[0] =CGPointMake(size.width/2, 0);//坐标1
        sPoints[1] =CGPointMake(0, size.height);//坐标2
        sPoints[2] =CGPointMake(size.width, size.height);//坐标3
    } else if (direction == TriangleDirection_Left) {
        sPoints[0] =CGPointMake(size.width, 0);//坐标1
        sPoints[1] =CGPointMake(0, size.height/2);//坐标2
        sPoints[2] =CGPointMake(size.width, size.height);//坐标3
    } else if (direction == TriangleDirection_Right) {
        sPoints[0] =CGPointMake(0, 0);//坐标1
        sPoints[1] =CGPointMake(0, size.height);//坐标2
        sPoints[2] =CGPointMake(size.width, size.height/2);//坐标3
    }
    
    CGContextAddLines(context, sPoints, 3);//添加线
    CGContextClosePath(context);//封起来
    CGContextClip(context);
    [myImage drawInRect:rect];
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
    
}

/**生成截屏图片*/
+ (UIImage *)captureWithView:(UIView *)view {
//    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
//    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return img;
    
    //这种可以截视频
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**获取图片某位置的颜色*/
- (UIColor *)colorAtPoint:(CGPoint)point {
    UIColor* color = nil;
    CGImageRef inImage =self.CGImage;
    // Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
    if (cgctx == NULL) {
        return nil; /* error */
    }
    
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(cgctx, rect, inImage);
    
    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    unsigned char* data = CGBitmapContextGetData (cgctx);
    if (data != NULL) {
        //offset locates the pixel in the data from x,y.
        //4 for 4 bytes of data per pixel, w is width of one row of data.
        int offset = 4*((w*round(point.y))+round(point.x));
        int alpha =  data[offset];
        int red = data[offset+1];
        int green = data[offset+2];
        int blue = data[offset+3];
        //NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
        color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
    }
    
    // When finished, release the context
    CGContextRelease(cgctx);
    // Free image data memory for the context
    if (data) { free(data); }
    return color;
}

- (CGContextRef)createARGBBitmapContextFromImage:(CGImageRef)inImage {
    
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    NSInteger       bitmapByteCount;
    NSInteger       bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    
    return context;
}

/**压缩图片到指定内存大小*/
- (UIImage *)compressToByte:(NSUInteger)maxLength {
    UIImage *resultImage = self;
    NSData *data = UIImageJPEGRepresentation(resultImage, 1);
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        resultImage = [resultImage compressToSize:size];
        data = UIImageJPEGRepresentation(resultImage, 1);
    }
    return resultImage;
}

/**压缩图片到指定尺寸*/
- (UIImage *)compressToSize:(CGSize)size {
    UIImage *resultImage = self;
    UIGraphicsBeginImageContext(size);
    // Use image to draw (drawInRect:), image is larger but more compression time
    // Use result image to draw, image is smaller but less compression time
    [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

-(UIImage*)applyLightEffect
{
    UIColor*tintColor =[UIColor colorWithWhite:1.0 alpha:0.3];
    return[self applyBlurWithRadius:30 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}
-(UIImage*)applyExtraLightEffect
{
    UIColor*tintColor =[UIColor colorWithWhite:0.97 alpha:0.82];
    return[self applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}
-(UIImage*)applyDarkEffect
{
    UIColor*tintColor =[UIColor colorWithWhite:0.11 alpha:0.73];
    return[self applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}
-(UIImage*)applyTintEffectWithColor:(UIColor*)tintColor
{
    const CGFloat EffectColorAlpha=0.6;
    UIColor*effectColor = tintColor;
    NSInteger componentCount =CGColorGetNumberOfComponents(tintColor.CGColor);
    if(componentCount ==2){
        CGFloat b;
        if([tintColor getWhite:&b alpha:NULL]){
            effectColor =[UIColor colorWithWhite:b alpha:EffectColorAlpha];
        }
    }
    else{
        CGFloat r, g, b;
        if([tintColor getRed:&r green:&g blue:&b alpha:NULL]){
            effectColor =[UIColor colorWithRed:r green:g blue:b alpha:EffectColorAlpha];
        }
    }
    return[self applyBlurWithRadius:10 tintColor:effectColor saturationDeltaFactor:-1.0 maskImage:nil];
}
-(UIImage*)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor*)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage*)maskImage
{
    // Check pre-conditions.
    if(self.size.width <1||self.size.height <1){
        NSLog(@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@",self.size.width,self.size.height,self);
        return nil;
    }
    if(!self.CGImage){
        NSLog(@"*** error: image must be backed by a CGImage: %@",self);
        return nil;
    }
    if(maskImage &&!maskImage.CGImage){
        NSLog(@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
    CGRect imageRect ={CGPointZero,self.size };
    UIImage*effectImage =self;
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor -1.)> __FLT_EPSILON__;
    if(hasBlur || hasSaturationChange){
        UIGraphicsBeginImageContextWithOptions(self.size, NO,[[UIScreen mainScreen] scale]);
        CGContextRef effectInContext =UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext,1.0,-1.0);
        CGContextTranslateCTM(effectInContext,0,-self.size.height);
        CGContextDrawImage(effectInContext, imageRect,self.CGImage);
        vImage_Buffer effectInBuffer;
        effectInBuffer.data =CGBitmapContextGetData(effectInContext);
        effectInBuffer.width =CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height =CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes =CGBitmapContextGetBytesPerRow(effectInContext);
        UIGraphicsBeginImageContextWithOptions(self.size, NO,[[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext =UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data =CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width =CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height =CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes =CGBitmapContextGetBytesPerRow(effectOutContext);
        if(hasBlur){
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius *[[UIScreen mainScreen] scale];
            NSUInteger radius = floor(inputRadius *3.* sqrt(2* M_PI)/4+0.5);
            if(radius %2!=1){
                radius +=1;// force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer,&effectOutBuffer, NULL,0,0, (uint32_t)radius, (uint32_t)radius,0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer,&effectInBuffer, NULL,0,0, (uint32_t)radius, (uint32_t)radius,0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer,&effectOutBuffer, NULL,0,0, (uint32_t)radius, (uint32_t)radius,0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if(hasSaturationChange){
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[]={
                0.0722+0.9278* s,0.0722-0.0722* s,0.0722-0.0722* s,0,
                0.7152-0.7152* s,0.7152+0.2848* s,0.7152-0.7152* s,0,
                0.2126-0.2126* s,0.2126-0.2126* s,0.2126+0.7873* s,0,
                0,0,0,1,
            };
            const int32_t divisor =256;
            NSUInteger matrixSize =sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for(NSUInteger i =0; i < matrixSize;++i){
                saturationMatrix[i]=(int16_t)roundf(floatingPointSaturationMatrix[i]* divisor);
            }
            if(hasBlur){
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer,&effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else{
                vImageMatrixMultiply_ARGB8888(&effectInBuffer,&effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if(!effectImageBuffersAreSwapped)
            effectImage =UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if(effectImageBuffersAreSwapped)
            effectImage =UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(self.size, NO,[[UIScreen mainScreen] scale]);
    CGContextRef outputContext =UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext,1.0,-1.0);
    CGContextTranslateCTM(outputContext,0,-self.size.height);
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect,self.CGImage);
    // Draw effect image.
    if(hasBlur){
        CGContextSaveGState(outputContext);
        if(maskImage){
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    // Add in color tint.
    if(tintColor){
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    // Output image is ready.
    UIImage*outputImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}

@end
