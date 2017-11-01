//
//  LFLocalMusicPicker.m
//  BaseAPP
//
//  Created by 张林峰 on 2017/5/18.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import "LFLocalMusicPicker.h"

@interface LFLocalMusicPicker ()<MPMediaPickerControllerDelegate>

@property (nonatomic, copy) void(^resultBlock)(MPMediaItemCollection *mediaItemCollection);

@end

@implementation LFLocalMusicPicker

- (void)pickMusicWithController:(UIViewController *)ctr resultBlock:(void(^)(MPMediaItemCollection *mediaItemCollection))resultBlock {
    self.resultBlock = resultBlock;
    
    [self requestAppleMusicAccessWithAuthorizedHandler:^{
        //创建播放器控制器
        MPMediaPickerController *mpc = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
        //设置代理
        mpc.delegate = self;
        [ctr presentViewController:mpc animated:YES completion:nil];
    } unAuthorizedHandler:^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请到设置-隐私中开启媒体与Apple Music权限" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) { }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"去开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [ctr presentViewController:alert animated:YES completion:nil];
    }];
    
}

#pragma mark - Delegate
//选中后调用
- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    if (self.resultBlock) {
        self.resultBlock(mediaItemCollection);
    }
    
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}
//点击取消时回调
- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 权限
//检查权限
- (void)requestAppleMusicAccessWithAuthorizedHandler:(void(^)(void))authorizedHandler
                                 unAuthorizedHandler:(void(^)(void))unAuthorizedHandler{
    if (@available(iOS 9.3, *)) {
        MPMediaLibraryAuthorizationStatus authStatus = [MPMediaLibrary authorizationStatus];
        if (authStatus == MPMediaLibraryAuthorizationStatusNotDetermined) {
            [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
                if (status == MPMediaLibraryAuthorizationStatusAuthorized) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        authorizedHandler ? authorizedHandler() : nil;
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        unAuthorizedHandler ? unAuthorizedHandler() : nil;
                    });
                }
            }];
        }else if (authStatus == MPMediaLibraryAuthorizationStatusAuthorized){
            authorizedHandler ? authorizedHandler() : nil;
        }else{
            unAuthorizedHandler ? unAuthorizedHandler() : nil;
        }
    } else {
        // Fallback on earlier versions
    }
}

@end
