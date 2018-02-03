//
//  LFDeviceInfo.m
//  APPBaseSDK
//
//  Created by 张林峰 on 16/8/17.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import "LFDeviceInfo.h"
#include <sys/utsname.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
//for mac
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
//#import "SFHFKeychainUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>


@implementation LFDeviceInfo

+(instancetype)shareInstance {
    static id shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[[self class] alloc]init];
    });
    return shareInstance;
}

- (id)init {
    self = [super init];
    
    self.mac = [self macString];/** 获取设备的mac地址 */

    self.clientOS = [self getOS];/** 获取本地设备的操作系统及版本 */
    self.clientMachine = [self getMachine];/** 获取设备的类型 */

    //是否越狱
    self.isJailBreak = [LFDeviceInfo isJailed];
    
    return self;
}

- (NSString * )macString{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *macString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return macString;
}

- (NSString *)idfvString {
    if([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        return [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    return @"";
}

/** 获取本地设备的操作系统及版本 */
- (NSString *)getOS {
    UIDevice *device = [UIDevice currentDevice];
    return [NSString stringWithFormat:@"%@ %@", device.systemName, device.systemVersion];
}

/** 获取设备的类型 */
- (NSString *)getMachine {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = @(systemInfo.machine);
    //直接返回厂商给的字符串
    return deviceString;
}

//判断是否越狱
+ (BOOL)isJailed {
    BOOL jailbroken = NO;
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath] || [[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
        jailbroken = YES;
    }
    
    return jailbroken;
}

//运营商
+ (NSString *)telephonyNetworkInfo {
    //设置运营商信息
    CTTelephonyNetworkInfo	* telInfo = [[CTTelephonyNetworkInfo alloc] init];
    NSString  * carrierName = nil;
    if (telInfo.subscriberCellularProvider) {
        carrierName = telInfo.subscriberCellularProvider.carrierName;
    }
    if (carrierName.length == 0) {
        carrierName = @"无";
    }
    
    return carrierName;
}

#pragma mark - 私有方法
- (NSString *)getMD5WithString:(NSString *)string {
    if(self == nil || [string length] == 0){
        return nil;
    }
    
    const char *src = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(src, (unsigned int)strlen(src), result);
    
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
}

@end
