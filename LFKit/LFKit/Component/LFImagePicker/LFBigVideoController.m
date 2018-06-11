//
//  LFBigVideoController.m
//  LFKit
//
//  Created by 张林峰 on 2018/6/10.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import "LFBigVideoController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "LFPhotoNavController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface LFBigVideoController ()

@property (nonatomic, strong) AVPlayerViewController *avplayer;
@property (nonatomic, strong) UIImageView *maskView;

@property (nonatomic, copy) NSString *playUrl;
@property (nonatomic, assign) BOOL isPlaying;

@end

@implementation LFBigVideoController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.avplayer.view.frame = self.view.bounds;
    self.maskView.frame = self.view.bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigation];
    
    [self addChildViewController:self.avplayer];
    [self.view addSubview:self.avplayer.view];
    [self.view addSubview:self.maskView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
    [self.maskView addGestureRecognizer:tap];
    
    [self showMask:YES];
    [self fetchPlayUrl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.navigationController isKindOfClass:[LFPhotoNavController class]]) {
        ((LFPhotoNavController *)self.navigationController).navbarStyle = LFPhotoNavBarStyleBlack;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController isKindOfClass:[LFPhotoNavController class]]) {
        ((LFPhotoNavController *)self.navigationController).navbarStyle = LFPhotoNavBarStyleLightContent;
    }
}

#pragma mark - Private

//初始化导航
- (void)initNavigation {
    UIBarButtonItem *itemClose = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStyleDone target:self action:@selector(select_Click)];
    self.navigationItem.rightBarButtonItems = @[itemClose];
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)showMask:(BOOL)showIcon {
    self.maskView.image = showIcon ? [UIImage imageNamed:@"photo_video_play_normal"] : nil;
    //处理navbar的显示
    [self.navigationController setNavigationBarHidden:!showIcon animated:YES];
}

- (void)fetchPlayUrl {
    PHVideoRequestOptions *options2 = [[PHVideoRequestOptions alloc] init];
    [[PHImageManager defaultManager] requestAVAssetForVideo:self.videoModel.asset options:options2 resultHandler:^(AVAsset*_Nullable asset, AVAudioMix*_Nullable audioMix,NSDictionary*_Nullable info) {
        
        if (asset && [asset isKindOfClass:[AVURLAsset class]] && [NSString stringWithFormat:@"%@",((AVURLAsset *)asset).URL].length > 0) {
            NSString *url = [NSString stringWithFormat:@"%@",((AVURLAsset *)asset).URL];
            if (url.length > 0) {
                self.playUrl = url; //记录播放地址
                AVPlayer *av = [AVPlayer playerWithURL:[NSURL URLWithString:url]];
                self.avplayer.player = av;
                //给AVPlayerItem添加播放完成通知
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.avplayer.player.currentItem];
            }
        }
    }];
}

- (void)doTap:(id)sender {
    if (self.playUrl.length == 0 || !self.playUrl) {
        return;
    }
    
    if (self.isPlaying) {
        [self pause];
    } else {
        [self resumePlay];
    }
}

#pragma mark - Actions
- (void)select_Click {
    
    if (self.playUrl.length == 0 || self.playUrl == nil) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"不支持该视频格式";
        [hud hideAnimated:YES afterDelay:3];
        return;
    }
    
    if (self.selectVideoBlock) {
        self.selectVideoBlock(self.videoModel);
    }
}

#pragma mark - AVPlayer
- (void)pause {
    [self showMask:YES];
    [self.avplayer.player pause];
    self.isPlaying = NO;
}

- (void)resumePlay {
    [self showMask:NO];
    [self.avplayer.player play];
    self.isPlaying = YES;
}

//播放完毕
- (void)playbackFinished:(NSNotification *)notification{
    [self.avplayer.player seekToTime:CMTimeMake(0, 1)]; //把视频进度还原
    
    [self showMask:YES];
    self.isPlaying = NO;
}

#pragma mark - Getter
- (UIImageView *)maskView {
    if (!_maskView) {
        _maskView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo_video_play_normal"]];
        _maskView.backgroundColor = [UIColor clearColor];
        _maskView.contentMode = UIViewContentModeCenter;
        _maskView.userInteractionEnabled = YES;
    }
    return _maskView;
}

- (AVPlayerViewController *)avplayer {
    if (!_avplayer) {
        _avplayer = [[AVPlayerViewController alloc] init];
        _avplayer.showsPlaybackControls = NO;
        _avplayer.videoGravity = AVLayerVideoGravityResizeAspect;
    }
    return _avplayer;
}

@end
