//
//  LFPhotoAlbumCell.m
//  LFKit
//
//  Created by 张林峰 on 2018/6/4.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import "LFPhotoAlbumCell.h"

@implementation LFPhotoAlbumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.headImageView];
        [self.contentView addSubview:self.labTitle];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat height = CGRectGetHeight(self.contentView.bounds);
    CGFloat gap = 5;
    CGFloat imghHight = height - gap*2;
    self.headImageView.frame = CGRectMake(15, gap, imghHight, imghHight);
    self.labTitle.frame = CGRectMake(CGRectGetMaxX(self.headImageView.frame)+10, (height - 20)/2, 200, 20);
}

#pragma mark - Getter

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.backgroundColor = [UIColor whiteColor];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.clipsToBounds = YES;
    }
    return _headImageView;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.textColor = [UIColor blackColor];
        _labTitle.textAlignment = NSTextAlignmentLeft;
        _labTitle.font = [UIFont systemFontOfSize:16];
    }
    return _labTitle;
}
@end
