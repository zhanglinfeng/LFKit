//
//  LFDeviceInfo.h
//  APPBaseSDK
//
//  Created by 张林峰 on 16/8/17.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LFDeviceInfo : NSObject

@property (nonatomic, copy) NSString *deviceToken;/** 获取应用的推送token */
@property (nonatomic, copy) NSString *mac;/** 获取设备的mac地址 */
@property (nonatomic, copy) NSString *clientOS;/** 获取本地设备的操作系统及版本 */
@property (nonatomic, copy) NSString *clientMachine;/** 获取设备的类型 */
@property (nonatomic, assign) BOOL isJailBreak;/** 设备是否越狱 */

+(instancetype)shareInstance;

//运营商
+ (NSString *)telephonyNetworkInfo;

@end
