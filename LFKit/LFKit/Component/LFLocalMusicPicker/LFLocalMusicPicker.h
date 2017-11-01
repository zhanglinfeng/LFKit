//
//  LFLocalMusicPicker.h
//  BaseAPP
//
//  Created by 张林峰 on 2017/5/18.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface LFLocalMusicPicker : NSObject

- (void)pickMusicWithController:(UIViewController *)ctr resultBlock:(void(^)(MPMediaItemCollection *mediaItemCollection))resultBlock;

@end
