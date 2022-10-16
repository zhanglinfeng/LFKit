//
//  UITextView+LF.h
//  LFKit
//
//  Created by 张林峰 on 2019/9/2.
//  Copyright © 2019 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef  void(^TextDidChange)(NSString *text, BOOL isOut);

@interface UITextView (LF)

@property (nonatomic, strong) NSString *placeholder;//占位符
@property (nonatomic, strong) UIFont   *placeholderFont;//占位符字体，默认13号字体
@property (nonatomic, strong) UIColor  *placeholderColor;//占位符颜色，默认浅灰色

@property (nonatomic, strong) NSNumber *maxCount;//最大字数
@property (nonatomic, strong) UIFont   *countFont;//计数字体，默认13号字体
@property (nonatomic, strong) UIColor  *countColor;//计数颜色，默认浅灰色
@property (nonatomic, strong) NSNumber *isLimit;//超过最大字数，是否截取，0否，1是

//默认 @{@"top":@(6),@"left":@(5),@"bottom":@(5),@"right":@(5)} top、left控制占位符边距。bottom、right控制计数边距
@property (nonatomic, strong) NSDictionary *insetDic;

@property (nonatomic, copy) TextDidChange textDidChangeBlock; //获取当前文字、是否超出字数(如果超出会回调2次，截取前一次截取后一次)

/**在持有本组件的控制器或者视图里调用，必须调用 */
- (void)lf_layoutSubviews;

@end

NS_ASSUME_NONNULL_END
