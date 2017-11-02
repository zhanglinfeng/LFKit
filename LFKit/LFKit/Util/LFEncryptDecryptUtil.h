//
//  LFEncryptDecryptUtil.h
//  RechargeHand
//
//  Created by 张林峰 on 16/5/11.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonCryptor.h>

@interface LFEncryptDecryptUtil : NSObject

#pragma mark - NSData的AES加密解密

/**NSData AES加密*/
+ (NSData *)AES256EncryptPlainData:(NSData *)plainData Key:(NSString *)key;
/**NSData AES解密*/
+ (NSData *)AES256DecryptCipherData:(NSData*)cipherData Key:(NSString *)key;

#pragma mark - NSData的 DES加密解密
/**NSData DES加密*/
+ (NSData *)DESEncryptPlainData:(NSData *)plainData Key:(NSString *)key;
/**NSData DES解密*/
+ (NSData *)DESDecryptCipherData:(NSData*)cipherData Key:(NSString *)key;
#pragma mark - 字符串的AES加密解密

/**NSString AES加密*/
+ (NSString *)AES256EncryptPlainText:(NSString *)plainText Key:(NSString *)key;
/**NSString AES解密*/
+ (NSString *)AES256DecryptCipherText:(NSString*)cipherText Key:(NSString *)key;

#pragma mark - 字符串的DES加密解密
/**字符串DES加密*/
+ (NSString *)DESEncryptPlainText:(NSString *)plainText key:(NSString *)key;
/**字符串DES解密*/
+ (NSString *)DESDecryptCipherText:(NSString*)cipherText key:(NSString*)key;

/**字符串DES加密用到Base64*/
+ (NSString *)DESEncryptBase64PlainText:(NSString *)plainText key:(NSString *)key;
/**字符串DES解密用到Base64*/
+ (NSString *)DESDecryptBase64CipherText:(NSString*)cipherText key:(NSString*)key;


/**
 *  字符串DES加密、解密  C#/iOS/Android通用DES加密解密方法,有base64
 *
 *  @param content 需要加密解密内容
 *  @param type    kCCEncrypt 加密,kCCDecrypt 解密
 *  @param aKey    密钥
 *
 *  @return 结果
 */
+(NSString*)encryptWithContent:(NSString*)content type:(CCOperation)type key:(NSString*)aKey;

/**
 *  字符串DES加密、解密
 *
 *  @param sText            需要加密解密内容
 *  @param encryptOperation kCCEncrypt 加密,kCCDecrypt 解密
 
 *  @param key              密钥
 *
 *  @return 结果
 */
+ (NSString *)encrypt:(NSString *)sText encryptOrDecrypt:(CCOperation)encryptOperation key:(NSString *)key;



@end
