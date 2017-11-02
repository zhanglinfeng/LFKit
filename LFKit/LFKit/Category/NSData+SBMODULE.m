/*
#####################################################################
# File    : NSDataCagegory.m
# Project : 
# Created : 2013-03-30
# DevTeam : Thomas Develop
# Author  : 
# Notes   :
#####################################################################
### Change Logs   ###################################################
#####################################################################
---------------------------------------------------------------------
# Date  :
# Author:
# Notes :
#
#####################################################################
*/

#import "NSData+SBMODULE.h"

#import <CommonCrypto/CommonCryptor.h>

//#import <>

@implementation NSData (sbmodule)

/** 把一个 NSData 转成十六进制字符串 */
- (NSString *)sb_toHexString {
    NSMutableString *str = [NSMutableString stringWithCapacity:0];
    const unsigned char *data = [self bytes];
    NSUInteger len = [self length];

    for(NSUInteger i=0; i<len; i++){
        [str appendFormat:@"%02x", data[i]];
    }

    return str;
}

/** 从一个十六进制字符串创建一个 NSData 对象 */
+ (NSData *)sb_dataWithHexString:(NSString *)string {
    NSUInteger str_len = [string length];

    if (str_len < 1 || str_len % 2 != 0) {
        return nil;
    }

    NSMutableData *data = [NSMutableData dataWithCapacity:0];
    NSRange range;
    unsigned int hex_val;
    unsigned char hex_char;

    range.length = 2;

    for (NSUInteger i=0; i<str_len; i += 2) {
        range.location = i;

        if(![[NSScanner scannerWithString:[string substringWithRange:range]] scanHexInt:&hex_val]){
            return nil;
        }

        hex_char = (unsigned char)hex_val;
        [data appendBytes:&hex_char length:sizeof(hex_char)];
    }

    return data;
}

//去掉转义符号
- (NSString *)sb_removeEscapes {
    NSString *_dataStr = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    
	_dataStr = [_dataStr stringByReplacingOccurrencesOfString:@"\t" withString:@"    "];    //  \t - 水平制表符
	_dataStr = [_dataStr stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\\\\\\\"];   //    \\ - 反斜杠
	_dataStr = [_dataStr stringByReplacingOccurrencesOfString:@"\'" withString:@"'"];   //    \' - 单引号
	_dataStr = [_dataStr stringByReplacingOccurrencesOfString:@"\a" withString:@""];   //    \a - Sound alert
	_dataStr = [_dataStr stringByReplacingOccurrencesOfString:@"\b" withString:@""];   //    \b - 退格
	_dataStr = [_dataStr stringByReplacingOccurrencesOfString:@"\f" withString:@""];   //    \f - Form feed
	_dataStr = [_dataStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];   //    \n - 换行
	_dataStr = [_dataStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];   //    \r - 回车
	_dataStr = [_dataStr stringByReplacingOccurrencesOfString:@"\v" withString:@""];   //    \v - 垂直制表符
    
    
    return _dataStr;
}

@end

@implementation NSData (Base64)
+ (NSData *)sb_dataWithBase64EncodedString:(NSString *)string
{
    const char lookup[] =
    {
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 62, 99, 99, 99, 63,
        52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 99, 99, 99, 99, 99, 99,
        99,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
        15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 99, 99, 99, 99, 99,
        99, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
        41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 99, 99, 99, 99, 99
    };
    
    NSData *inputData = [string dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    long long inputLength = [inputData length];
    const unsigned char *inputBytes = [inputData bytes];
    
    long long maxOutputLength = (inputLength / 4 + 1) * 3;
    NSMutableData *outputData = [NSMutableData dataWithLength:(NSUInteger)maxOutputLength];
    unsigned char *outputBytes = (unsigned char *)[outputData mutableBytes];
    
    int accumulator = 0;
    long long outputLength = 0;
    unsigned char accumulated[] = {0, 0, 0, 0};
    for (long long i = 0; i < inputLength; i++)
    {
        unsigned char decoded = lookup[inputBytes[i] & 0x7F];
        if (decoded != 99)
        {
            accumulated[accumulator] = decoded;
            if (accumulator == 3)
            {
                outputBytes[outputLength++] = (accumulated[0] << 2) | (accumulated[1] >> 4);
                outputBytes[outputLength++] = (accumulated[1] << 4) | (accumulated[2] >> 2);
                outputBytes[outputLength++] = (accumulated[2] << 6) | accumulated[3];
            }
            accumulator = (accumulator + 1) % 4;
        }
    }
    
    //handle left-over data
    if (accumulator > 0) outputBytes[outputLength] = (accumulated[0] << 2) | (accumulated[1] >> 4);
    if (accumulator > 1) outputBytes[++outputLength] = (accumulated[1] << 4) | (accumulated[2] >> 2);
    if (accumulator > 2) outputLength++;
    
    //truncate data to match actual output length
    outputData.length = (NSUInteger)outputLength;
    return outputLength? outputData: nil;
}

- (NSString *)sb_base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth
{
    //ensure wrapWidth is a multiple of 4
    wrapWidth = (wrapWidth / 4) * 4;
    
    const char lookup[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    long long inputLength = [self length];
    const unsigned char *inputBytes = [self bytes];
    
    long long maxOutputLength = (inputLength / 3 + 1) * 4;
    maxOutputLength += wrapWidth? (maxOutputLength / wrapWidth) * 2: 0;
    unsigned char *outputBytes = (unsigned char *)malloc((NSUInteger)maxOutputLength);
    
    long long i;
    long long outputLength = 0;
    for (i = 0; i < inputLength - 2; i += 3)
    {
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[((inputBytes[i] & 0x03) << 4) | ((inputBytes[i + 1] & 0xF0) >> 4)];
        outputBytes[outputLength++] = lookup[((inputBytes[i + 1] & 0x0F) << 2) | ((inputBytes[i + 2] & 0xC0) >> 6)];
        outputBytes[outputLength++] = lookup[inputBytes[i + 2] & 0x3F];
        
        //add line break
        if (wrapWidth && (outputLength + 2) % (wrapWidth + 2) == 0)
        {
            outputBytes[outputLength++] = '\r';
            outputBytes[outputLength++] = '\n';
        }
    }
    
    //handle left-over data
    if (i == inputLength - 2)
    {
        // = terminator
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[((inputBytes[i] & 0x03) << 4) | ((inputBytes[i + 1] & 0xF0) >> 4)];
        outputBytes[outputLength++] = lookup[(inputBytes[i + 1] & 0x0F) << 2];
        outputBytes[outputLength++] =   '=';
    }
    else if (i == inputLength - 1)
    {
        // == terminator
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0x03) << 4];
        outputBytes[outputLength++] = '=';
        outputBytes[outputLength++] = '=';
    }
    
    //truncate data to match actual output length
    outputBytes = realloc(outputBytes, (NSUInteger)outputLength);
    NSString *result = [[NSString alloc] initWithBytesNoCopy:outputBytes length:(NSUInteger)outputLength encoding:NSASCIIStringEncoding freeWhenDone:YES];
    
#if !__has_feature(objc_arc)
    [result autorelease];
#endif
    
    return (outputLength >= 4)? result: nil;
}

- (NSString *)base64EncodedString
{
    return [self sb_base64EncodedStringWithWrapWidth:0];
}


- (NSData*)sb_encryptAES:(NSString *) key {
    char keyPtr[kCCKeySizeAES256+1];
    bzero( keyPtr, sizeof(keyPtr) );
    
    [key getCString: keyPtr maxLength: sizeof(keyPtr) encoding: NSUTF16StringEncoding];
    size_t numBytesEncrypted = 0;
    
    NSUInteger dataLength = [self length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    CCCryptorStatus result = CCCrypt( kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                     keyPtr, kCCKeySizeAES256,
                                     NULL,
                                     [self bytes], [self length],
                                     buffer, bufferSize,
                                     &numBytesEncrypted );
    
    if( result == kCCSuccess )
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    free(buffer);
    return nil;
}

- (NSData *)sb_decryptAES:(NSString *) key {
    char  keyPtr[kCCKeySizeAES256+1];
    bzero( keyPtr, sizeof(keyPtr) );
    
    [key getCString: keyPtr maxLength: sizeof(keyPtr) encoding: NSUTF16StringEncoding];
    
    size_t numBytesEncrypted = 0;
    
    NSUInteger dataLength = [self length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer_decrypt = malloc(bufferSize);
    
    CCCryptorStatus result = CCCrypt( kCCDecrypt , kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                     keyPtr, kCCKeySizeAES256,
                                     NULL,
                                     [self bytes], [self length],
                                     buffer_decrypt, bufferSize,
                                     &numBytesEncrypted );
    
    if( result == kCCSuccess )
        return [NSData dataWithBytesNoCopy:buffer_decrypt length:numBytesEncrypted];
    free(buffer_decrypt);
    return nil;
}

@end
