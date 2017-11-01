//
//  LFPickerView.h
//  LFPickerView
//
//  Created by 张林峰 on 17/1/11.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LFPickerViewHeight 216


/**
 功能：将PickerView，DatePicker封装得更加简单易用，并可搭配UITextField使用（可选)
 */
@interface LFPickerView : UIView

@property (strong, nonatomic) UIView *maskView;//黑色半透明背景，hidden属性可控制该背景是否显示
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIButton *btnLeft;
@property (strong, nonatomic) UIButton *btnRight;
@property (nonatomic, strong) UITextField *receiverField;////接收数据的TextField（可不设置，如果使用者连回调都懒得处理了，设置他自动帮你处理receiverField的数据）
@property (strong, nonatomic) NSString *strAppending;//有多列时receiverField显示文案的连接符，比如显示男-25岁，则strAppending是“-”

/**一般picker正在滚动的回调(数组中存放选中的行，多列则有多个值,strResult是拼接好的结果)*/
@property (copy, nonatomic) void(^valueChanged)(LFPickerView * picker, NSArray *values, NSString *strResult);

/**一般picker确定按钮回调(数组中存放选中的行，多列则有多个值,strResult是拼接好的结果)*/
@property (copy, nonatomic) void(^valueComplete)(LFPickerView * picker, NSArray *values, NSString *strResult);

/**时间滚动的回调*/
@property (copy, nonatomic) void(^dateChanged)(LFPickerView * picker, NSString *strDate);

/**时间确定按钮回调*/
@property (copy, nonatomic) void(^dateComplete)(LFPickerView * picker, NSString *strDate);

/**取消回调*/
@property (copy, nonatomic) void(^cancelBlock)();

/**
 *  一般picker
 *
 *  @param component 列数
 *  @param array     当有多列时为包含多个小数组的大数组，当只有一列时是包含字符串的数组
 *
 *  @return ELPickerView
 */
-(id)initWithComponents:(NSInteger)component dataSource:(NSArray *)array height:(CGFloat)height;

/**
 时间picker
 @param format 时间格式
 @param height 高度
 @return 时间
 */
- (id)initWithFormat:(NSString *)format height:(CGFloat)height;

/**
 设置选中行、列
 
 @param row 选中列
 @param component 选中列
 @param animated 是否动画
 */
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;

/**显示*/
- (void)show;

/**消失*/
- (void)dismiss;

@end
