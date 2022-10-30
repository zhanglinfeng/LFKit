//
//  LFPicCollectionCell.m
//  QingShe
//
//  Created by 张林峰 on 2022/9/23.
//

#import "LFPicCollectionCell.h"
#import <Masonry/Masonry.h>
#import <YYWebImage/YYWebImage.h>

@interface LFPicCollectionCell ()

@end

@implementation LFPicCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = NO;
        self.contentView.clipsToBounds = NO;
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.deleteButton];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(-7);
            make.right.equalTo(self.contentView.mas_right).offset(7);
            make.width.height.mas_equalTo(14);
        }];
    }
    return self;
}

- (void)setImageUrl:(NSString *)imageUrl {
    if (!imageUrl) {
        return;;
    }
    if (imageUrl.length < 1) {
        return;;
    }
    _imageUrl = imageUrl;
    if ([imageUrl containsString:@"http"]) {
        [self.imageView yy_setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:nil];
    } else if ([imageUrl containsString:@"/"]) {
        // 本地图
        self.imageView.image = [UIImage imageWithContentsOfFile:imageUrl];
    } else {
        // 图片名称
        self.imageView.image = [UIImage imageNamed:imageUrl];
    }
    
}

- (void)deleteImage:(id)sender {
    if (self.deleteBlock) {
        self.deleteBlock(self.index);
    }
}

// 让超出父视图的子视图也可以点击
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        //将坐标由当前视图发送到 指定视图 fromView是无法响应的范围小父视图
        CGPoint stationPoint = [_deleteButton convertPoint:point fromView:self];
        if (CGRectContainsPoint(_deleteButton.bounds, stationPoint))
        {
            view = _deleteButton;
        }
    }
    return view;
}


- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        _imageView.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1];;
        _imageView.clipsToBounds=YES;
//        _imageView.layer.cornerRadius = 1.5;
    }
    return _imageView;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.backgroundColor = [UIColor clearColor];
        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"lf_close"] forState:UIControlStateNormal];
        _deleteButton.hidden = YES;
        [_deleteButton addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

@end
