//
//  LFErrorCell.m
//  LFKit
//
//  Created by 张林峰 on 2018/11/1.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import "LFErrorCell.h"
#import "LFErrorView.h"

@interface LFErrorCell ()

@property (nonatomic, strong) LFErrorView *errorView;

@end

@implementation LFErrorCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0);

        self.errorView = [[LFErrorView alloc] initWithFrame:self.contentView.bounds];
        self.errorView.ivIcon.image = [UIImage imageNamed:@"LFEmptyIcon"];
        self.errorView.lbText.text = @"暂无数据";
        [self.contentView addSubview:self.errorView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.errorView.frame = self.contentView.bounds;
}

- (void)setErrorImage:(UIImage *)errorImage {
    _errorImage = errorImage;
    self.errorView.ivIcon.image = errorImage;
}

- (void)setErrorMessage:(NSString *)errorMessage {
    _errorMessage = errorMessage;
    self.errorView.lbText.text = errorMessage;
}

- (void)setIconTop:(CGFloat)iconTop {
    _iconTop = iconTop;
    self.errorView.iconTop = _iconTop;
    [self.errorView layoutSubviews];
}

@end
