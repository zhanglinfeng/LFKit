//
//  LFEncryptDecryptUtil.m
//  RechargeHand
//
//  Created by 张林峰 on 16/5/11.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import "LFEncryptDecryptUtil.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation LFEncryptDecryptUtil

#pragma mark - NSData的AES加密解密
//NSData AES加密
+ (NSData *)AES256EncryptPlainData:(NSData *)plainData Key:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSASCIIStringEncoding];
    NSUInteger dataLength = [plainData length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    //相比原文件，修改了kCCAlgorithmAES，kCCKeySizeAES256两个参数
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES,
                                          kCCOptionECBMode | kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL,
                                          [plainData bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}

//NSData AES解密
+ (NSData *)AES256DecryptCipherData:(NSData*)cipherData Key:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSASCIIStringEncoding];
    NSUInteger dataLength = [cipherData length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL,
                                          [cipherData bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}

//NSData DES加密
+ (NSData *)DESEncryptPlainData:(NSData *)plainData Key:(NSString *)key
{
    size_t numBytesEncrypted = 0;
    
    size_t bufferSize = [plainData length] + kCCBlockSizeDES;
    void *buffer = malloc(bufferSize);
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          [key UTF8String],
                                          [plainData bytes],
                                          [plainData length],
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    
    NSData *dataTemp = nil;
    if (cryptStatus == kCCSuccess) {
        dataTemp = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
    }else{
        NSLog(@"DES加密失败");
    }
    return dataTemp;
}
//NSData DES解密
+ (NSData *)DESDecryptCipherData:(NSData*)cipherData Key:(NSString *)key
{
    size_t numBytesDecrypted = 0;
    
    size_t bufferSize = [cipherData length] + kCCBlockSizeDES;
    void *buffer = malloc(bufferSize);
    // IV 偏移量不需使用
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          [key UTF8String],
                                          [cipherData bytes],
                                          [cipherData length],
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    NSData *dataTemp = nil;
    if (cryptStatus == kCCSuccess) {
        dataTemp = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
    }else{
        NSLog(@"DES解密失败");
    }
    return dataTemp;
}

#pragma mark - 字符串的AES加密解密

//NSString AES加密
+ (NSString *)AES256EncryptPlainText:(NSString *)plainText Key:(NSString *)key {
    //将字符串密码转为NSData用于AES加密
    NSData *data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    //AES加密
    data = [self AES256EncryptPlainData:data Key:key];//[plainText AES256EncryptWithKey:key];
    
    NSString *result = nil;
    
    //转换为2进制字符串
    if (data && data.length > 0) {
        
        Byte *datas = (Byte*)[data bytes];
        NSMutableString *output = [NSMutableString stringWithCapacity:data.length * 2];
        for(int i = 0; i < data.length; i++){
            [output appendFormat:@"%02x", datas[i]];
        }
        result = output;
    }
    return result;
}


//NSString AES解密
+ (NSString *)AES256DecryptCipherText:(NSString*)cipherText Key:(NSString *)key {
    //将字符串转为NSMutableData再解密
    NSMutableData *data = [NSMutableData dataWithCapacity:cipherText.length / 2];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [cipherText length] / 2; i++) {
        byte_chars[0] = [cipherText characterAtIndex:i*2];
        byte_chars[1] = [cipherText characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    
    //解密后的Data
    NSData *decData = [self AES256DecryptCipherData:data Key:key];
    NSString *result = [[NSString alloc]initWithData:decData encoding:NSUTF8StringEncoding];
    return result;
}

#pragma mark - 字符串的DES加密解密

//字符串DES加密
+ (NSString *)DESEncryptPlainText:(NSString *)plainText key:(NSString *)key {
    NSString *ciphertext = nil;
    NSData *textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [textData length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void * buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String], kCCBlockSizeDES,
                                          NULL,
                                          [textData bytes]  , dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSLog(@"DES加密成功");
        
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [self stringWithHexBytes:data];
        
    }else{
        NSLog(@"DES加密失败");
    }
    
    free(buffer);
    return ciphertext;
}

//字符串DES解密
+ (NSString *)DESDecryptCipherText:(NSString*)cipherText key:(NSString*)key {
    NSString *plainText = nil;
    NSData *textData = [self parseHexToByteArray:cipherText];
    NSUInteger dataLength = [textData length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String], kCCKeySizeDES,
                                          NULL,
                                          [textData bytes]  , dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSLog(@"DES解密成功");
        
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }else{
        NSLog(@"DES解密失败");
    }
    
    free(buffer);
    return plainText;
}


//字符串DES加密用到Base64
+ (NSString *)DESEncryptBase64PlainText:(NSString *)plainText key:(NSString *)key
{
    NSString *ciphertext = nil;
    const char *textBytes = [plainText UTF8String];
    NSUInteger dataLength = [plainText length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    Byte iv[] = {1,2,3,4,5,6,7,8};
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          textBytes, dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        
        ciphertext = [[NSString alloc] initWithData:[data base64EncodedDataWithOptions:NSDataBase64Encoding76CharacterLineLength] encoding:NSUTF8StringEncoding];
    }
    return ciphertext;
}

//字符串DES解密用到Base64
+ (NSString *)DESDecryptBase64CipherText:(NSString*)cipherText key:(NSString*)key
{
    NSData* cipherData = [[NSData alloc]initWithBase64EncodedString:cipherText options:NSDataBase64DecodingIgnoreUnknownCharacters];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    Byte iv[] = {1,2,3,4,5,6,7,8};
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          iv,
                                          [cipherData bytes],
                                          [cipherData length],
                                          buffer,
                                          1024,
                                          &numBytesDecrypted);
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return plainText;
}




static const char* encryptWithKeyAndType(const char *text,CCOperation encryptOperation,char *key)
{
    NSString *textString=[[NSString alloc]initWithCString:text encoding:NSUTF8StringEncoding];
    //      NSLog(@”[[item.url description] UTF8String=%@”,textString);
    const void *dataIn;
    size_t dataInLength;
    
    if (encryptOperation == kCCDecrypt)//传递decrypt 解码
    {
        //解码 base64
        NSData *decryptData = [[NSData alloc]initWithBase64EncodedString:textString options:NSDataBase64DecodingIgnoreUnknownCharacters];;//转utf-8并decode
        dataInLength = [decryptData length];
        dataIn = [decryptData bytes];
    }
    else  //encrypt
    {
        NSData* encryptData = [textString dataUsingEncoding:NSUTF8StringEncoding];
        dataInLength = [encryptData length];
        dataIn = (const void *)[encryptData bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL; //理解位type/typedef 缩写（效维护代码比：用int用long用typedef定义）
    size_t dataOutAvailable = 0; //size_t  操作符sizeof返结类型
    size_t dataOutMoved = 0;
    
    dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 00, dataOutAvailable);//已辟内存空间buffer首 1 字节值设值 0
    
    //NSString *initIv = @”12345678″;
    const void *vkey = key;
    const void *iv = (const void *) key; //[initIv UTF8String];
    
    //CCCrypt函数 加密/解密
    ccStatus = CCCrypt(encryptOperation,//  加密/解密
                       kCCAlgorithmDES,//  加密根据哪标准（des3desaes）
                       kCCOptionPKCS7Padding,//  选项组密码算(des:每块组加密  3DES：每块组加三同密)
                       vkey,  //密钥    加密解密密钥必须致
                       kCCKeySizeDES,//  DES 密钥（kCCKeySizeDES=8）
                       iv, //  选初始矢量
                       dataIn, // 数据存储单元
                       dataInLength,// 数据
                       (void *)dataOut,// 用于返数据
                       dataOutAvailable,
                       &dataOutMoved);
    
    NSString *result = nil;
    
    if (encryptOperation == kCCDecrypt)//encryptOperation==1  解码
    {
        //解密data数据改变utf-8字符串
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved] encoding:NSUTF8StringEncoding];
    }
    else //encryptOperation==0  （加密程加密数据转base64）
    {
        //编码 base64
        NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
        result = [[NSString alloc] initWithData:[data base64EncodedDataWithOptions:NSDataBase64Encoding76CharacterLineLength] encoding:NSUTF8StringEncoding];
    }
    
    return [result UTF8String];
    
}

//字符串DES加密  C#/iOS/Android通用DES加密解密方法
+(NSString*)encryptWithContent:(NSString*)content type:(uint32_t)type key:(NSString*)aKey
{
    const char * contentChar =[content UTF8String];
    char * keyChar =(char*)[aKey UTF8String];
    const char *miChar;
    miChar = encryptWithKeyAndType(contentChar, type, keyChar);
    return  [NSString stringWithCString:miChar encoding:NSUTF8StringEncoding];
}


+ (NSString *)encrypt:(NSString *)sText encryptOrDecrypt:(uint32_t)encryptOperation key:(NSString *)key
{
    const void *dataIn;
    size_t dataInLength;
    
    if (encryptOperation == kCCDecrypt)//传递过来的是decrypt 解码
    {
        //解码 base64
        NSData *decryptData = [[NSData alloc]initWithBase64EncodedString:sText options:NSDataBase64DecodingIgnoreUnknownCharacters];//转成utf-8并decode
        dataInLength = [decryptData length];
        dataIn = [decryptData bytes];
    }
    else  //encrypt
    {
        NSData* encryptData = [sText dataUsingEncoding:NSUTF8StringEncoding];
        dataInLength = [encryptData length];
        dataIn = (const void *)[encryptData bytes];
    }
    
    /*
     DES加密 ：用CCCrypt函数加密一下，然后用base64编码下，传过去
     DES解密 ：把收到的数据根据base64，decode一下，然后再用CCCrypt函数解密，得到原本的数据
     */
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL; //可以理解位type/typedef 的缩写（有效的维护了代码，比如：一个人用int，一个人用long。最好用typedef来定义）
    size_t dataOutAvailable = 0; //size_t  是操作符sizeof返回的结果类型
    size_t dataOutMoved = 0;
    
    dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);//将已开辟内存空间buffer的首 1 个字节的值设为值 0
    
    NSString *initIv = @"12345678";
    const void *vkey = (const void *) [key UTF8String];
    const void *iv = (const void *) [initIv UTF8String];
    
    //CCCrypt函数 加密/解密
    ccStatus = CCCrypt(encryptOperation,//  加密/解密
                       kCCAlgorithmDES,//  加密根据哪个标准（des，3des，aes。。。。）
                       kCCOptionPKCS7Padding,//  选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
                       vkey,  //密钥    加密和解密的密钥必须一致
                       kCCKeySizeDES,//   DES 密钥的大小（kCCKeySizeDES=8）
                       iv, //  可选的初始矢量
                       dataIn, // 数据的存储单元
                       dataInLength,// 数据的大小
                       (void *)dataOut,// 用于返回数据
                       dataOutAvailable,
                       &dataOutMoved);
    
    NSString *result = nil;
    
    if (encryptOperation == kCCDecrypt)//encryptOperation==1  解码
    {
        //得到解密出来的data数据，改变为utf-8的字符串
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved] encoding:NSUTF8StringEncoding];
    }
    else //encryptOperation==0  （加密过程中，把加好密的数据转成base64的）
    {
        //编码 base64
        NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
        result = [[NSString alloc] initWithData:[data base64EncodedDataWithOptions:NSDataBase64Encoding76CharacterLineLength] encoding:NSUTF8StringEncoding];
    }
    
    return result;
}



//nsdata转成16进制字符串
+ (NSString*)stringWithHexBytes:(NSData *)sender {
    static const char hexdigits[] = "0123456789ABCDEF";
    const size_t numBytes = [sender length];
    const unsigned char* bytes = [sender bytes];
    char *strbuf = (char *)malloc(numBytes * 2 + 1);
    char *hex = strbuf;
    NSString *hexBytes = nil;
    
    for (int i = 0; i<numBytes; ++i) {
        const unsigned char c = *bytes++;
        *hex++ = hexdigits[(c >> 4) & 0xF];
        *hex++ = hexdigits[(c ) & 0xF];
    }
    
    *hex = 0;
    hexBytes = [NSString stringWithUTF8String:strbuf];
    
    free(strbuf);
    return hexBytes;
}

/*
 将16进制数据转化成NSData 数组
 */
+(NSData*) parseHexToByteArray:(NSString*) hexString
{
    int j=0;
    Byte bytes[hexString.length];
    for(int i=0;i<[hexString length];i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
    }
    
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:hexString.length/2];
    return newData;
}










/*********************C#/iOS/Android通用DES加密解密方法**********************

C#代码

#region  跨平台加解密（c#）

/// <summary>
/// 对字符串进行DES加密
/// </summary>
/// <param name=”sourceString”>待加密的字符串</param>
/// <returns>加密后的BASE64编码的字符串</returns>
public string Encrypt(string sourceString, string sKey)
{
    byte[] btKey = Encoding.UTF8.GetBytes(sKey);
    byte[] btIV = Encoding.UTF8.GetBytes(sKey);
    DESCryptoServiceProvider des = new DESCryptoServiceProvider();
    using (MemoryStream ms = new MemoryStream())
    {
        byte[] inData = Encoding.UTF8.GetBytes(sourceString);
        try
        {
            using (CryptoStream cs = new CryptoStream(ms, des.CreateEncryptor(btKey, btIV), CryptoStreamMode.Write))
            {
                cs.Write(inData, 0, inData.Length);
                cs.FlushFinalBlock();
            }
            
            return Convert.ToBase64String(ms.ToArray());
        }
        catch
        {
            throw;
        }
    }
}
/// <summary>
/// 解密
/// </summary>
/// <param name=”pToDecrypt”>要解密的以Base64</param>
/// <param name=”sKey”>密钥，且必须为8位</param>
/// <returns>已解密的字符串</returns>
public string Decrypt(string pToDecrypt, string sKey)
{
    
    //转义特殊字符
    pToDecrypt = pToDecrypt.Replace(“-“, “+”);
    pToDecrypt = pToDecrypt.Replace(“_”, “/”);
    pToDecrypt = pToDecrypt.Replace(“~”, “=”);
    byte[] inputByteArray = Convert.FromBase64String(pToDecrypt);
    using (DESCryptoServiceProvider des = new DESCryptoServiceProvider())
    {
        des.Key = ASCIIEncoding.ASCII.GetBytes(sKey);
        des.IV = ASCIIEncoding.ASCII.GetBytes(sKey);
        System.IO.MemoryStream ms = new System.IO.MemoryStream();
        using (CryptoStream cs = new CryptoStream(ms, des.CreateDecryptor(), CryptoStreamMode.Write))
        {
            cs.Write(inputByteArray, 0, inputByteArray.Length);
            cs.FlushFinalBlock();
            cs.Close();
        }
        string str = Encoding.UTF8.GetString(ms.ToArray());
        ms.Close();
        return str;
    }
}

#endregion

IOS代码

static const char* encryptWithKeyAndType(const char *text,CCOperation encryptOperation,char *key)
{
    NSString *textString=[[NSString alloc]initWithCString:text encoding:NSUTF8StringEncoding];
    //      NSLog(@”[[item.url description] UTF8String=%@”,textString);
    const void *dataIn;
    size_t dataInLength;
    
    if (encryptOperation == kCCDecrypt)//传递decrypt 解码
    {
        //解码 base64
        NSData *decryptData = [GTMBase64 decodeData:[textString dataUsingEncoding:NSUTF8StringEncoding]];//转utf-8并decode
        dataInLength = [decryptData length];
        dataIn = [decryptData bytes];
    }
    else  //encrypt
    {
        NSData* encryptData = [textString dataUsingEncoding:NSUTF8StringEncoding];
        dataInLength = [encryptData length];
        dataIn = (const void *)[encryptData bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL; //理解位type/typedef 缩写（效维护代码比：用int用long用typedef定义）
    size_t dataOutAvailable = 0; //size_t  操作符sizeof返结类型
    size_t dataOutMoved = 0;
    
    dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 00, dataOutAvailable);//已辟内存空间buffer首 1 字节值设值 0
    
    //NSString *initIv = @”12345678″;
    const void *vkey = key;
    const void *iv = (const void *) key; //[initIv UTF8String];
    
    //CCCrypt函数 加密/解密
    ccStatus = CCCrypt(encryptOperation,//  加密/解密
                       kCCAlgorithmDES,//  加密根据哪标准（des3desaes）
                       kCCOptionPKCS7Padding,//  选项组密码算(des:每块组加密  3DES：每块组加三同密)
                       vkey,  //密钥    加密解密密钥必须致
                       kCCKeySizeDES,//  DES 密钥（kCCKeySizeDES=8）
                       iv, //  选初始矢量
                       dataIn, // 数据存储单元
                       dataInLength,// 数据
                       (void *)dataOut,// 用于返数据
                       dataOutAvailable,
                       &dataOutMoved);
    
    NSString *result = nil;
    
    if (encryptOperation == kCCDecrypt)//encryptOperation==1  解码
    {
        //解密data数据改变utf-8字符串
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved] encoding:NSUTF8StringEncoding];
    }
    else //encryptOperation==0  （加密程加密数据转base64）
    {
        //编码 base64
        NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
        result = [GTMBase64 stringByEncodingData:data];
    }
    
    return [result UTF8String];
    
}
+(NSString*)encryptWithContent:(NSString*)content type:(CCOperation)type key:(NSString*)aKey
{
    const char * contentChar =[content UTF8String];
    char * keyChar =(char*)[aKey UTF8String];
    const char *miChar;
    miChar = encryptWithKeyAndType(contentChar, type, keyChar);
    return  [NSString stringWithCString:miChar encoding:NSUTF8StringEncoding];
}



Android代码



//加密
public static String DecryptDoNet(String message, String key)
throws Exception {
    byte[] bytesrc = Base64.decode(message.getBytes(), Base64.DEFAULT);
    Cipher cipher = Cipher.getInstance(“DES/CBC/PKCS5Padding”);
    DESKeySpec desKeySpec = new DESKeySpec(key.getBytes(“UTF-8”));
    SecretKeyFactory keyFactory = SecretKeyFactory.getInstance(“DES”);
    SecretKey secretKey = keyFactory.generateSecret(desKeySpec);
    IvParameterSpec iv = new IvParameterSpec(key.getBytes(“UTF-8”));
    cipher.init(Cipher.DECRYPT_MODE, secretKey, iv);
    byte[] retByte = cipher.doFinal(bytesrc);
    return new String(retByte);
}

// 解密
public static String EncryptAsDoNet(String message, String key)
throws Exception {
    Cipher cipher = Cipher.getInstance(“DES/CBC/PKCS5Padding”);
    DESKeySpec desKeySpec = new DESKeySpec(key.getBytes(“UTF-8”));
    SecretKeyFactory keyFactory = SecretKeyFactory.getInstance(“DES”);
    SecretKey secretKey = keyFactory.generateSecret(desKeySpec);
    IvParameterSpec iv = new IvParameterSpec(key.getBytes(“UTF-8″));
    cipher.init(Cipher.ENCRYPT_MODE, secretKey, iv);
    byte[] encryptbyte = cipher.doFinal(message.getBytes());
    return new String(Base64.encode(encryptbyte, Base64.DEFAULT));
}

最后还要注意一下，一般在客户端调用接口时，请求的是URL地址，参数需要加密，比如token，如果token里含有+号，URL会转码为空格，这时在.net端接收到token时，需要把token中的空格替换为+号：token = Regex.Replace(token, @”\s”, “+”);这样接收到的token才能正常的解密。

*/

@end
