//
//  LFPickerView.m
//  LFPickerView
//
//  Created by 张林峰 on 17/1/11.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import "LFPickerView.h"

@interface LFPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) NSArray *arrayData;
@property (assign, nonatomic) NSInteger component;
@property (strong, nonatomic) NSString *format;
@property (assign, nonatomic) CGFloat pickerHeight;
@property (nonatomic) BOOL isShow;

@end

@implementation LFPickerView

-(id)initWithComponents:(NSInteger)component dataSource:(NSArray *)array height:(CGFloat)height{
    CGRect frame;
    frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height);
    self.pickerHeight = height;
    self = [super initWithFrame:frame];
    
    [self initUI];
    _strAppending = @"";
    _component = component;
    _arrayData = array;
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    return self;
}

- (id)initWithFormat:(NSString *)format height:(CGFloat)height {
    CGRect frame;
    frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height);
    self = [super initWithFrame:frame];
    self.pickerHeight = height;
    _format = format;
    [self initUI];
    
    return self;
}

- (void)initUI {
    
    self.maskView = [[UIView alloc] initWithFrame:CGRectZero];
    self.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.btnLeft = [UIButton buttonWithType:UIButtonTypeSystem];
    self.btnLeft.frame = CGRectMake(8, 0, 40, 40);
    self.btnLeft.backgroundColor = [UIColor clearColor];
    self.btnLeft.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.btnLeft setTitle:@"取消" forState:UIControlStateNormal];
    [self.btnLeft addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnLeft];
    
    self.btnRight = [UIButton buttonWithType:UIButtonTypeSystem];
    self.btnRight.frame = CGRectMake(self.frame.size.width - 40 - 8, 0, 40, 40);
    self.btnRight.backgroundColor = [UIColor clearColor];
    self.btnRight.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.btnRight setTitle:@"确定" forState:UIControlStateNormal];
    [self.btnRight addTarget:self action:@selector(finished:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnRight];
    
    
    if (_format) {//日期picker
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width, self.frame.size.height - 40)];
        [self.datePicker addTarget:self action:@selector(datePickerDateChange:) forControlEvents:UIControlEventValueChanged];
        self.datePicker.backgroundColor =[UIColor whiteColor];
        [self addSubview:self.datePicker];
    } else {//其他picker
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width, self.frame.size.height - 40)];
        self.pickerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.pickerView];
        NSLog(@"self.frame.size.height = %f",self.frame.size.height);
        NSLog(@"self.pickerHeight = %f",self.pickerHeight);
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.btnLeft.frame = CGRectMake(8, 0, 40, 40);
    self.btnRight.frame = CGRectMake(self.frame.size.width - 40 - 8, 0, 40, 40);
    self.datePicker.frame = CGRectMake(0, 40, self.frame.size.width, self.frame.size.height - 40);
    self.pickerView.frame = CGRectMake(0, 40, self.frame.size.width, self.frame.size.height - 40 + 5);//系统会自动将高度强行变成162或180，为了不留白，多+5让系统把高度变为180
}

#pragma mark - 私有方法

-(void)datePickerDateChange:(UIDatePicker *)picker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:self.format];
    NSString *strDate = [dateFormatter stringFromDate:picker.date];
    if (_receiverField) {
        [_receiverField setText:strDate];
    }
    if (self.dateChanged) {
        self.dateChanged(self, strDate);
    }
}

#pragma mark - 公有方法

- (void)show {
    //如果已经显示了就return
    if (self.isShow) {
        return;
    }
    
    NSArray *windows = [UIApplication sharedApplication].windows;
    if (windows.count < 1) {
        return;
    }
    self.isShow = YES;
    UIWindow *window = windows[0];
    self.maskView.frame = window.bounds;
    [window addSubview:self.maskView];
    
    UITapGestureRecognizer *tapGestureRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.maskView addGestureRecognizer:tapGestureRecognizer];
    
    
    [window addSubview:self];
    self.frame = CGRectMake(0, self.window.frame.size.height, self.window.frame.size.width, self.pickerHeight);
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, self.window.frame.size.height - self.pickerHeight, self.window.frame.size.width, self.pickerHeight);
    }];
    
}

- (void)dismiss {
    self.isShow = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, self.window.frame.size.height, self.window.frame.size.width, self.pickerHeight);
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
    if (row > 0) {
        [_pickerView selectRow:row inComponent:component animated:animated];
    }
}

#pragma mark - UIPickerViewDelegate
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return _component;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (_component == 1) {
        return _arrayData.count;
    } else {
        return ((NSArray *)_arrayData[component]).count;
    }
    
    
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return pickerView.frame.size.width/2;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSString *s = nil;
    for (NSInteger i = 0; i < _component; i++) {
        NSInteger myRow = [_pickerView selectedRowInComponent:i];
        [array addObject:@(myRow)];
        
        if (_component == 1) {
            s = _arrayData[myRow];
        } else {
            if (s == nil) {
                s = ((NSArray *)_arrayData[i])[myRow];
            } else {
                s = [NSString stringWithFormat:@"%@%@%@", s, _strAppending,((NSArray *)_arrayData[i])[myRow]];
            }
        }
    }
    
    if (_receiverField) {
        _receiverField.text = s;
    }
    
    if (self.valueChanged) {
        self.valueChanged(self, array, s);
    }
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_component == 1) {
        return _arrayData[row];
    } else {
        return ((NSArray *)_arrayData[component])[row];
    }
}

#pragma mark - Action

- (IBAction)finished:(id)sender {
    if (_receiverField) {
        [_receiverField resignFirstResponder];
    }
    if (self.pickerView) {//其他picker
        NSMutableArray *array = [[NSMutableArray alloc]init];
        NSString *s = nil;
        for (NSInteger i = 0; i < _component; i++) {
            NSInteger myRow = [_pickerView selectedRowInComponent:i];
            [array addObject:@(myRow)];
            
            if (_component == 1) {
                s = _arrayData[myRow];
            } else {
                if (s == nil) {
                    s = ((NSArray *)_arrayData[i])[myRow];
                } else {
                    s = [NSString stringWithFormat:@"%@%@%@", s, _strAppending,((NSArray *)_arrayData[i])[myRow]];
                }
            }
        }
    
        if (_receiverField) {
            _receiverField.text = s;
        }
        if (self.valueComplete && array.count > 0) {
            self.valueComplete(self, array, s);
        }
    } else {//时间picker
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:self.format];
        NSString *strDate = [dateFormatter stringFromDate:self.datePicker.date];
        if (_receiverField) {
            [_receiverField setText:strDate];
        }
        if (self.dateComplete) {
            self.dateComplete(self, strDate);
        }
    }
    
    [self dismiss];
    
}

- (IBAction)cancel:(id)sender {
    _receiverField.text = @"";
    [_receiverField resignFirstResponder];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    
    [self dismiss];
}

@end
