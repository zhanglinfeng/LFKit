//
//  LFAlertView.m
//  LFKit
//
//  Created by 张林峰 on 2019/2/22.
//  Copyright © 2019 张林峰. All rights reserved.
//

#import "LFAlertView.h"
#import "Masonry.h"

@interface LFAlertView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) LFAlertViewStyle alertStyle;
@property (nonatomic, strong) NSString *alertTitle;
@property (nonatomic, strong) NSString *alertMessage;
@property (nonatomic, strong) UIView *viewLine;//横线
@property (nonatomic, strong) UIView *vLine;//竖线
@property (nonatomic, strong) UIView *whiteBG;//sheet时上半部分白背景
@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UIButton *btnOK;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LFAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message style:(LFAlertViewStyle)style {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.alertStyle = style;
        self.alertTitle = title;
        self.alertMessage = message;
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 10;
        
        [self initUI];
//        [self setNeedsLayout];
        
        CGFloat txtHeight = 0;
        if (self.alertMessage.length > 0) {
            [self layoutIfNeeded];
            [self.tvMessage sizeToFit];
            txtHeight = self.tvMessage.frame.size.height;
        }

        [self.tvMessage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(txtHeight).priorityLow();
        }];
    }
    return self;
}

- (void)initUI {
    self.lbTitle = [[UILabel alloc] init];
    self.lbTitle.textColor = [UIColor blackColor];
    self.lbTitle.backgroundColor = [UIColor clearColor];
    self.lbTitle.textAlignment = NSTextAlignmentCenter;
    self.lbTitle.numberOfLines = 0;
    self.lbTitle.font = [UIFont boldSystemFontOfSize:16];
    self.lbTitle.text = self.alertTitle;
    [self addSubview:self.lbTitle];
    [self.lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.width.mas_equalTo(260);
    }];
    
    self.tvMessage = [[UITextView alloc] init];
    self.tvMessage.textColor = [UIColor blackColor];
    self.tvMessage.backgroundColor = [UIColor clearColor];
    self.tvMessage.textAlignment = NSTextAlignmentCenter;
    self.tvMessage.font = [UIFont systemFontOfSize:13];
    self.tvMessage.text = self.alertMessage;
    self.tvMessage.editable = NO;
    self.tvMessage.bounces = NO;
    [self addSubview:self.tvMessage];
    [self.tvMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat top = (self.alertMessage.length > 0 && self.alertTitle.length > 0) ? 5 : 0;
        make.top.equalTo(self.lbTitle.mas_bottom).offset(top);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        
    }];
}

- (void)initButton {
    if (_buttonArray.count == 1) {
        //确定按钮
        self.btnOK = _buttonArray[0];
        [self addSubview:self.btnOK];
        [self.btnOK mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(0);
            make.right.equalTo(self).offset(-0);
            make.top.equalTo(self.viewLine.mas_bottom);
            make.height.equalTo(@40);
            make.bottom.equalTo(self).offset(-0);
        }];
        
        [self.btnOK addTarget:self action:@selector(clickOK) forControlEvents:UIControlEventTouchUpInside];
    } else if (_buttonArray.count == 2) {
        //取消按钮
        self.btnCancel = _buttonArray[0];
        [self.btnCancel addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnCancel];
        [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.viewLine.mas_bottom);
            make.height.equalTo(@40);
            make.bottom.equalTo(self);
        }];
        
        //确定按钮
        self.btnOK = _buttonArray[1];
        
        [self addSubview:self.btnOK];
        [self.btnOK mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.btnCancel.mas_right);
            make.right.equalTo(self);
            make.top.equalTo(self.btnCancel.mas_top);
            make.bottom.equalTo(self.btnCancel.mas_bottom);
            make.height.equalTo(self.btnCancel.mas_height);
            make.width.equalTo(self.btnCancel.mas_width);
        }];
        [self.btnOK addTarget:self action:@selector(clickOK) forControlEvents:UIControlEventTouchUpInside];
        
        //竖线
        self.vLine = [[UIView alloc] init];
        self.vLine.backgroundColor = [UIColor colorWithRed:0.783922 green:0.780392 blue:0.8 alpha:1];
        [self addSubview:self.vLine];
        [self.vLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.viewLine.mas_bottom);
            make.bottom.equalTo(self);
            make.width.equalTo(@(1/[UIScreen mainScreen].scale));
        }];
    }
}

- (void)initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.bounces = NO;
    self.tableView.separatorColor = [UIColor colorWithRed:0.783922 green:0.780392 blue:0.8 alpha:1];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"myCell"];
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if(self.alertTitle.length < 1 && self.alertMessage.length < 1) {
            make.top.equalTo(self);
        } else {
            make.top.equalTo(self.viewLine.mas_bottom);
        }
        make.left.right.bottom.equalTo(self).offset(0);
        make.height.equalTo(@(_buttonArray.count * 44));
    }];
}

- (void)setTextFieldArray:(NSArray<UITextField *> *)textFieldArray {
    _textFieldArray = textFieldArray;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            [view removeFromSuperview];
        }
    }
    
    for (NSInteger i = 0; i < _textFieldArray.count; i++) {
        UITextField *textField = _textFieldArray[i];
        [self addSubview:textField];
        if (i == 0) {
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.tvMessage.mas_bottom).offset(20);
                make.left.equalTo(self).offset(20);
                make.right.equalTo(self).offset(-20);
                make.height.equalTo(@25);
            }];
        } else {
            UITextField *tfLast = _textFieldArray[i - 1];
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(tfLast.mas_bottom).offset(-1/[UIScreen mainScreen].scale);
                make.left.equalTo(self).offset(20);
                make.right.equalTo(self).offset(-20);
                make.height.equalTo(@25);
            }];
        }
    }
}

- (void)setPlaceholderArray:(NSArray<NSString *> *)placeholderArray {
    NSMutableArray *mArray = [NSMutableArray new];
    for (NSString *str in placeholderArray) {
        UITextField *tf = [[UITextField alloc] init];
        tf.borderStyle = UITextBorderStyleNone;
        tf.layer.borderWidth = 1/[UIScreen mainScreen].scale;
        tf.layer.borderColor = [UIColor grayColor].CGColor;
        tf.textColor = [UIColor blackColor];
        tf.font = [UIFont systemFontOfSize:13];
        tf.backgroundColor = [UIColor whiteColor];
        tf.placeholder = str;
        tf.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 20)];
        tf.leftViewMode = UITextFieldViewModeAlways;
        [mArray addObject:tf];
    }
    self.textFieldArray = mArray;
}

- (void)setButtonArray:(NSArray<UIButton *> *)buttonArray {
    _buttonArray = buttonArray;
    
    //先移除原来的
    if (self.viewLine) {
        [self.viewLine removeFromSuperview];
    }
    
    if (self.tableView) {
        [self.tableView removeFromSuperview];
    }
    if (self.vLine) {
        [self.vLine removeFromSuperview];
    }
    if (self.whiteBG) {
        [self.whiteBG removeFromSuperview];
    }
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    //横线
    self.viewLine = [[UIView alloc] init];
    self.viewLine.backgroundColor = [UIColor colorWithRed:0.783922 green:0.780392 blue:0.8 alpha:1];
    [self addSubview:self.viewLine];
    [self.viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        if (_textFieldArray.count > 0) {
            UITextField *tfLast = _textFieldArray[_textFieldArray.count - 1];
            make.top.equalTo(tfLast.mas_bottom).offset(15);
        } else {
            make.top.equalTo(self.tvMessage.mas_bottom).offset(20);
        }
        make.height.equalTo(@(1/[UIScreen mainScreen].scale));
    }];
    
    if (self.alertStyle == LFAlertViewActionSheet) {
        if (_buttonArray.count < 1) {
            return;
        }
        self.backgroundColor = [UIColor clearColor];
        self.viewLine.hidden = _buttonArray.count < 2;
        self.whiteBG = [[UIView alloc] init];
        self.whiteBG.backgroundColor = [UIColor whiteColor];
        self.whiteBG.clipsToBounds = YES;
        self.whiteBG.layer.cornerRadius = 10;
        [self insertSubview:self.whiteBG atIndex:0];
        
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.bounces = NO;
        self.tableView.clipsToBounds = YES;
        self.tableView.layer.cornerRadius = 10;
        self.tableView.separatorColor = [UIColor colorWithRed:0.783922 green:0.780392 blue:0.8 alpha:1];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"myCell"];
        [self addSubview:self.tableView];
        
        [self.whiteBG mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.equalTo(self);
            make.bottom.equalTo(self.tableView.mas_bottom);
        }];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            if(self.alertTitle.length < 1 && self.alertMessage.length < 1) {
                make.top.equalTo(self);
            } else {
                make.top.equalTo(self.viewLine.mas_bottom);
            }
            make.left.right.equalTo(self).offset(0);
            make.height.equalTo(@((_buttonArray.count - 1) * 56));
        }];
        
        //取消按钮
        self.btnCancel = [_buttonArray firstObject];
        self.btnCancel.layer.cornerRadius = 10;
        self.btnCancel.clipsToBounds = YES;
        [self.btnCancel addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnCancel];
        [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.whiteBG.mas_bottom).offset(10);
            make.height.equalTo(@56);
            make.bottom.equalTo(self).offset(-10);
        }];
        
    } else if (self.alertStyle == LFAlertViewAlert) {
        self.backgroundColor = [UIColor whiteColor];
        if (_buttonArray.count < 3) {
            [self initButton];
        } else {
            [self initTableView];
        }
    }
}

- (void)setButtonTitleArray:(NSArray<NSString *> *)buttonTitleArray {
    _buttonTitleArray = buttonTitleArray;
    if (buttonTitleArray.count == 1) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor colorWithRed:0 green:122/255.0f blue:255/255.0f alpha:1] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor clearColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitle:buttonTitleArray[0] forState:UIControlStateNormal];
        self.buttonArray = @[btn];
    } else {
        NSMutableArray *mArray = [NSMutableArray new];
        for (NSInteger i = 0; i < buttonTitleArray.count; i++) {
            if (i == 0) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setTitleColor:[UIColor colorWithRed:0 green:122/255.0f blue:255/255.0f alpha:1] forState:UIControlStateNormal];
                btn.backgroundColor = [UIColor whiteColor];
                btn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
                [btn setTitle:buttonTitleArray[0] forState:UIControlStateNormal];
                [mArray addObject:btn];
            } else {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setTitleColor:[UIColor colorWithRed:0 green:122/255.0f blue:255/255.0f alpha:1] forState:UIControlStateNormal];
                btn.backgroundColor = [UIColor clearColor];
                btn.titleLabel.font = [UIFont systemFontOfSize:16];
                [btn setTitle:buttonTitleArray[i] forState:UIControlStateNormal];
                [mArray addObject:btn];
            }
        }
        self.buttonArray = mArray;
    }
}

- (void)show {
    if (self.alertStyle == LFAlertViewAlert) {
        [self showIn:nil animate:LFBaseCardAnimateNormal];
    } else if (self.alertStyle == LFAlertViewActionSheet) {
        [self showIn:nil animate:LFBaseCardAnimateFromBottom];
    }
}

#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.alertStyle == LFAlertViewAlert ? _buttonArray.count : _buttonArray.count - 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.alertStyle == LFAlertViewAlert ? 44 : 56;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    if (indexPath.row < _buttonArray.count - 1) {
        UIButton *btn = _buttonArray[indexPath.row + 1];
        NSString *title = btn.currentTitle;
        cell.textLabel.text = title;
        cell.textLabel.textColor = [btn titleColorForState:UIControlStateNormal];
    } else {
        if (self.alertStyle == LFAlertViewAlert) {
            UIButton *btn = _buttonArray[0];
            NSString *title = btn.currentTitle;
            cell.textLabel.text = title;
            cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
            cell.textLabel.textColor = [btn titleColorForState:UIControlStateNormal];
        }
        
    }
    
    //分割线顶头
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        cell.preservesSuperviewLayoutMargins = NO;
    }
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    NSInteger maxRow = self.alertStyle == LFAlertViewAlert ? _buttonArray.count : _buttonArray.count - 1;
    if (indexPath.row == maxRow - 1) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width)];
        }
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIButton *btn = nil;
    if (indexPath.row < _buttonArray.count - 1) {
        btn = _buttonArray[indexPath.row + 1];
    } else {
        if (self.alertStyle == LFAlertViewAlert) {
            btn = _buttonArray[0];
        }
    }
    
    if (btn) {
        self.clickBlock(btn);
    }
    [self dismiss];
}

#pragma mark - Action

- (void)clickOK {
    if (self.clickBlock) {
        self.clickBlock(self.btnOK);
    }
    [self dismiss];
}

- (void)clickCancel {
    if (self.clickBlock) {
        self.clickBlock(self.btnCancel);
    }
    [self dismiss];
}

@end
