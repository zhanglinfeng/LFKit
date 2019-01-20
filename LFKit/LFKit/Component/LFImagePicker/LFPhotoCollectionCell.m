//
//  LFPhotoCollectionCell.m
//  LFKit
//
//  Created by 张林峰 on 2018/6/6.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import "LFPhotoCollectionCell.h"

@interface LFPhotoCollectionCell ()
@property (nonatomic, strong) UIImageView *videoIcon;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation LFPhotoCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.timeLabel.text = @"";
    self.imageView.image = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
    self.btnSelect.frame = CGRectMake(self.frame.size.width - 40, 0, 40, 40);
    self.videoIcon.frame = CGRectMake(6, self.frame.size.height - 9-8, 13, 9);
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.videoIcon.frame) + 2, CGRectGetMidY(self.videoIcon.frame) - 10, self.frame.size.width - CGRectGetMaxX(self.videoIcon.frame) - 2 - 2, 20);
    self.coverView.frame = self.contentView.bounds;
}

- (void)initUI {
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.videoIcon];
    [self.contentView addSubview:self.timeLabel];
    
    //click btn
    self.btnSelect = [[UIButton alloc] init];
    self.btnSelect.backgroundColor = [UIColor clearColor];
    [self.btnSelect setImage:[UIImage imageNamed:@"photo_radio_normal"] forState:UIControlStateNormal];
    [self.btnSelect setImage:[UIImage imageNamed:@"photo_radio_pressed"] forState:UIControlStateSelected];
    [self.btnSelect addTarget:self action:@selector(cell_btn_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnSelect];

    self.coverView = [[UIView alloc] init];
    self.coverView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    self.coverView.hidden = YES;
    [self.contentView addSubview:self.coverView];
}

- (void)setPhoto:(LFPhotoModel *)photo {
    _photo = photo;
    CGSize size = self.frame.size;
    size.width = size.width * [UIScreen mainScreen].scale * 2;
    size.height = size.height *[UIScreen mainScreen].scale * 2;
    [LFPhotoModel requestImageForAsset:photo.asset size:size resizeMode:PHImageRequestOptionsResizeModeExact needThumbnails:YES completion:^(UIImage *image, NSDictionary *info) {
        self.imageView.image = image;
        if ([NSThread currentThread] != [NSThread mainThread]) {
            NSLog(@"*********不在主线程2*********");
        }
    }];
    //区分照片、视频数据
    BOOL isVideo = [photo isVideo];
    self.videoIcon.hidden = !isVideo;
    self.timeLabel.hidden = !isVideo;
    self.coverView.hidden = YES;
    if (isVideo == NO) { //照片UI
        self.btnSelect.selected = photo.isSelected;
    } else { //视频UI
        self.timeLabel.text = [photo fetchVideoTimeString];
        
    }
}

- (void)cell_btn_Click:(UIButton *)button {
    if (self.selectBlock) {
        self.selectBlock(self.photo, button);
    }
}

#pragma mark - Getter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UIImageView *)videoIcon {
    if (!_videoIcon) {
        _videoIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Photo_video"]];
        _videoIcon.contentMode = UIViewContentModeScaleToFill;
        _videoIcon.clipsToBounds = YES;
        
    }
    return _videoIcon;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLabel;
}

@end
