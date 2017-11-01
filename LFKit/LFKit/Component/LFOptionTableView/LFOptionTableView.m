//
//  LFOptionTableView.m
//  BaseAPP
//
//  Created by 张林峰 on 15/12/31.
//  Copyright © 2015年 张林峰. All rights reserved.
//

#import "LFOptionTableView.h"

@interface LFOptionTableView ()

@property (nonatomic, assign) NSString *saveKey;
@property (nonatomic, assign) BOOL autoSave;
@property (nonatomic, strong) NSMutableArray *arraySource;//源数据
@property (nonatomic, strong) NSMutableArray *arrayShow;//搜索匹配展示的数据
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) float maxHeight;

@end

@implementation LFOptionTableView

- (UITableView *)initWithMaxHeigth:(CGFloat)maxHeight TextField:(UITextField *)tf ParentView:(UIView *)parentView DataSource:(NSMutableArray *)array SaveKey:(NSString *)key IsAutoSave:(BOOL)autoSave {
    
    _maxHeight = maxHeight;
    //计算tf相对于parentView的坐标
    CGPoint p = [tf.superview convertPoint:tf.frame.origin toView:parentView];
    self = [super initWithFrame:CGRectMake(p.x, p.y + tf.frame.size.height, tf.frame.size.width, maxHeight) style:UITableViewStylePlain];
    self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.separatorColor = [UIColor colorWithWhite:0.8 alpha:1];
    self.layer.borderWidth=1;
    self.layer.borderColor=[UIColor colorWithWhite:0.8 alpha:1].CGColor;
    self.delegate = self;
    self.dataSource = self;
    self.hidden = YES;
    [parentView addSubview:self];
    
    _textField = tf;
    [_textField addTarget:self action:@selector(textFieldBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [_textField addTarget:self action:@selector(textFieldEnd:) forControlEvents:UIControlEventEditingDidEnd];
    [_textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    _saveKey = key;
    if (array.count > 0) {
        _arraySource = array;
    } else {
        if (key) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSArray *arrayTemp = [userDefaults objectForKey:key];
            _arraySource = [[NSMutableArray alloc]initWithArray:arrayTemp];
        }
    }
    _arrayShow = [[NSMutableArray alloc]init];
    
    return self;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_arrayShow.count > 0) {
        return _arrayShow.count + 1;
    } else {
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
    }
    
    
    cell.textLabel.font = _textField.font;
    cell.textLabel.adjustsFontSizeToFitWidth = NO;
    if (indexPath.row < _arrayShow.count) {
        cell.textLabel.text = [_arrayShow objectAtIndex:indexPath.row];
    } else {
        cell.textLabel.text = @"手工输入";
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeigth;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _arrayShow.count) {
        [self.textField setText:[_arrayShow objectAtIndex:indexPath.row]];
    } else {
        [self.textField becomeFirstResponder];
    }
    self.hidden = YES;
    
    if (_myDelegate && [self.myDelegate respondsToSelector:@selector(LFOptionTableView:didSelectRowAtIndexPath:)]) {
        [self.myDelegate LFOptionTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark - UITextField delegate
- (void)textFieldBegin:(UITextField *)textField
{
    [self getMatchStrings:textField.text];
}

- (void)textFieldEnd:(UITextField *)textField
{
    if (!_autoSave) {
        return;
    }
    if (textField.text.length == 0) return;
    
    if ([_arraySource containsObject:_textField.text]) {
        return;
    }
    
    [_arraySource addObject:textField.text];
    if (_saveKey) {
        NSArray *array = [[NSArray alloc]initWithArray:_arraySource];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:array forKey:_saveKey];
        [userDefaults synchronize];
    }
}


- (void)textFieldChanged:(UITextField *)textField
{
    [self getMatchStrings:textField.text];
}

#pragma mark - 方法

- (void)show {
    if (_arrayShow.count > 0) {
        self.hidden = NO;
        float h = (_arrayShow.count + 1) * kCellHeigth > _maxHeight ? _maxHeight :(_arrayShow.count + 1) * kCellHeigth;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, h);
    } else {
        self.hidden = YES;
    }
    
}

- (NSMutableArray *)getMatchStrings:(NSString *)subString {
    [_arrayShow removeAllObjects];
    if (subString.length < 1) {
        _arrayShow = [NSMutableArray arrayWithArray:_arraySource];
    } else {
        NSRange range;
        for (NSString *tmpString in _arraySource)
        {
            range = [tmpString rangeOfString:subString];
            if (range.location != NSNotFound)
            {
                [_arrayShow addObject:tmpString];
            }
        }
    }
    
    [self show];
    [self reloadData];
    return _arrayShow;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
