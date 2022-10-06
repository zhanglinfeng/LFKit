//
//  NSString+LF.m
//  APPBaseSDK
//
//  Created by 张林峰 on 16/6/4.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import "NSString+LF.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (LF)

#pragma mark - size相关
/**根据文字数获取高度*/
- (CGFloat)getHeightWithFont:(UIFont*)font width:(CGFloat)width {
    
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:@{NSFontAttributeName : font}
                                     context:nil].size;
    return size.height;
}

/**根据文字数获取宽度*/
- (CGFloat)getWidthWithFont:(UIFont*)font {
    return [self sizeWithAttributes:@{NSFontAttributeName : font}].width;
}


#pragma mark - 字符串处理

-(NSMutableArray *)stringBetweenString:(NSString *)string {
    NSMutableArray *resultArray = [NSMutableArray array];
    
    NSString *strSource = self;
    
    //    NSString *regulaStr = @"#";
    
    //找出第一个字符的位置
    NSRange firstRange = [strSource rangeOfString:string];
    //下一个字符的位置
    NSRange nextRange;
    //找到有一个字符
    while (firstRange.location != NSNotFound) {
        
        nextRange = [strSource rangeOfString:string options:NSCaseInsensitiveSearch range:NSMakeRange(firstRange.location + firstRange.length, strSource.length - firstRange.location - firstRange.length)];
        
        //如果找到了下一个字符的位置
        if (nextRange.location != NSNotFound) {
            
            //如果不要#号，在这里变化下
            NSString *resultString = [strSource substringWithRange:NSMakeRange(firstRange.location , nextRange.location - firstRange.location + firstRange.length)];
            
            [resultArray addObject:resultString];
            
            //字符串切割
            strSource = [strSource substringFromIndex:nextRange.location + nextRange.length];
            firstRange = [strSource rangeOfString:string];
        }
        
        else{
            return resultArray;
        }
    }
    
    
    return resultArray;
}

/**获取拼音*/
- (NSString *)getPinyin {
    NSMutableString *mString = [NSMutableString stringWithFormat:@"%@", self];
    CFStringTransform((CFMutableStringRef) mString, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef) mString, NULL, kCFStringTransformStripDiacritics, NO);
    // mString 为汉语拼音
    return mString;
}

/**获取拼音首字母*/
- (NSString *)getInitial {
    NSMutableString *mString = [NSMutableString stringWithFormat:@"%@", self];
    CFStringTransform((CFMutableStringRef) mString, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef) mString, NULL, kCFStringTransformStripDiacritics, NO);
    if (mString.length < 1) {
        return @"";
    }
    // mString 为汉语拼音
    NSString *firstChar = [mString substringToIndex:1];
    if (mString.length > 4 && [[mString substringToIndex:5] isEqualToString:@"zhang"]) {
        firstChar = @"c";
    }
    NSString *upperString = [firstChar uppercaseString];
    return upperString;
}

/**字符串提取数字*/
- (NSString *)getNumberString {
    NSString *result = [[self componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
    return result;
}

/**字符串关键字部分变高亮色*/
- (NSMutableAttributedString *)getAttributeStringWithKeywords:(NSString *)keywords keyColor:(UIColor *)color{
    NSMutableAttributedString * attributedString =[[NSMutableAttributedString alloc] initWithString:self];
    NSRange range = NSMakeRange(0, attributedString.length);
    NSString *pattern = keywords;
    NSRegularExpression *regx = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [regx matchesInString:self options:0 range:range];
    for (NSTextCheckingResult *match in matches) {
        NSRange matchRange = match.range;
        [attributedString setAttributes:@{NSForegroundColorAttributeName:color} range:matchRange];
    }
    return attributedString;
}

/**URL编码*/
- (NSString *)URLEncoded {
    
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *unencodedString = self;
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

/**URL解码*/
-(NSString *)URLDecoded {
    
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    
    NSString *encodedString = self;
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

- (NSString *)getMD5 {
    if(self == nil || [self length] == 0){
        return nil;
    }
    
    const char *src = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(src, (unsigned int)strlen(src), result);
    
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
}

/**拼接前缀（防重复拼接）*/
- (NSString *)lf_addPrefix:(NSString *)prefix {
    if ([self hasPrefix:prefix]) {
        return  self;
    }
    return [NSString stringWithFormat:@"%@%@", prefix, self];
}

/**拼接后缀（防重复拼接）*/
- (NSString *)lf_addSuffix:(NSString *)suffix {
    if ([self hasSuffix:suffix]) {
        return self;
    }
    return [NSString stringWithFormat:@"%@%@", self, suffix];
}

/**去掉前缀*/
- (NSString *)lf_deletePrefix:(NSString *)prefix {
    if ([self hasPrefix:prefix] && self.length > prefix.length) {
        return [self substringFromIndex:prefix.length];
    } else {
        return self;
    }
}

/**去掉后缀*/
- (NSString *)lf_deleteSuffix:(NSString *)suffix {
    if ([self hasSuffix:suffix] && self.length > suffix.length) {
        return [self substringWithRange:NSMakeRange(0, self.length - suffix.length)];
    } else {
        return self;
    }
}

#pragma mark - 数字相关

/**保留count位小数(高保真)*/
- (NSString *)lf_keepDecimalCount:(NSInteger)count {
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                                                      scale:count
                                                                                           raiseOnExactness:NO
                                                                                            raiseOnOverflow:NO
                                                                                           raiseOnUnderflow:NO
                                                                                        raiseOnDivideByZero:NO];
    
    NSDecimalNumber *tmp = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *value = [tmp decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setMinimumFractionDigits:count];
    
    return [formatter stringFromNumber:value];
}

/**保留小数位数，一般的位数(高保真)*/
- (NSString *)lf_keepDecimalNormal {
    return [self lf_keepDecimalCount:2];
}

/**浮点型转化为万*/
- (NSString *)lf_flotToWanFormat {
    CGFloat value = self.floatValue;
    if (value > 9999) {
        CGFloat f = self.floatValue/10000;
        return [[@(f).stringValue lf_keepDecimalCount:2] stringByAppendingString:@"万"];
    } else {
        return [self lf_keepDecimalCount:2];
    }
}

/**整型转化为万*/
- (NSString *)lf_intToWanFormat {
    CGFloat value = self.floatValue;
    if (value > 9999) {
        CGFloat f = self.floatValue/10000;
        return [[@(f).stringValue lf_keepDecimalCount:1] stringByAppendingString:@"万"];
    } else {
        return self;
    }
}

/** 字节转KB或M或G */
+ (NSString *)lf_sizeWithByte:(long long)byte {
    if (byte >= 1024*1024*1024) {
        CGFloat f = byte/(1024.0*1024.0*1024.0);
        return [NSString stringWithFormat:@"%@G",[@(f).stringValue lf_keepDecimalCount:1]];
    } else if (byte >= 1024*1024) {
        CGFloat f = byte/(1024.0*1024.0);
        return [NSString stringWithFormat:@"%@M",[@(f).stringValue lf_keepDecimalCount:1]];
    } else if (byte > 999) {
        CGFloat f = byte/1024.0;
        return [NSString stringWithFormat:@"%@KB",[@(f).stringValue lf_keepDecimalCount:1]];
    } else {
        return [NSString stringWithFormat:@"%lldB",byte];
    }
}

#pragma mark - 校验相关

/**身份证号*/
- (BOOL)isIdentityCard
{
    if (self.length <= 0) {
        return NO;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:self];
}

/**邮箱*/
- (BOOL)isEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}


/**手机号码验证*/
- (BOOL)isMobile
{
    //第一位为1第二位为3、4、5、7、8
    NSString *phoneRegex = @"^1[34578]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

//判断是不是纯数字
- (BOOL)isInt {
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
- (BOOL)isFloat {
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

//判断是否为数字
- (BOOL)isNumber {
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return ([scan scanInt:&val] || [scan scanInt:&val]) && [scan isAtEnd];
}

/**判断是否含中文*/
- (BOOL)containsChinese {
    for(int i=0; i< [self length];i++){
        int a = [self characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}

@end
