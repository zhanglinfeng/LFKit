//
//  LFAlertView.h
//  LFKit
//
//  Created by 张林峰 on 2019/2/22.
//  Copyright © 2019 张林峰. All rights reserved.
//

#import "LFBaseCardView.h"

typedef NS_ENUM (NSInteger, LFAlertViewStyle) {
    LFAlertViewActionSheet = 0,
    LFAlertViewAlert
};

NS_ASSUME_NONNULL_BEGIN

@interface LFAlertView : LFBaseCardView

@property (nonatomic, strong) UILabel *lbTitle;
@property (nonatomic, strong) UITextView *tvMessage;

//textFieldArray和placeholderArray 二选一，设置placeholderArray的话则生成默认的textFieldArray，需要自定义输入框样式则设置buttonArray；placeholderArray可以是@[@"",@""]等空字符串的数组
@property (nonatomic, strong) NSArray<UITextField *>* textFieldArray;
@property (nonatomic, strong) NSArray<NSString *>* placeholderArray;

//buttonArray和buttonTitle 二选一，设置buttonTitle的话则生成默认的buttonArray，需要自定义按钮样式则设置buttonArray；取消按钮放在数组第一个位置。
@property (nonatomic, strong) NSArray<UIButton *>* buttonArray;
@property (nonatomic, strong) NSArray<NSString *>* buttonTitleArray;

@property (nonatomic, copy) void(^clickBlock)(UIButton *button);

NS_ASSUME_NONNULL_END

- (instancetype)initWithTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message style:(LFAlertViewStyle)style;

- (void)show;

@end


