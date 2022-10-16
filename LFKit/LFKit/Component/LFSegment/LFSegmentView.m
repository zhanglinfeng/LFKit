//
//  LFSegmentView.m
//  LFKit
//
//  Created by 张林峰 on 2018/1/21.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import "LFSegmentView.h"


@interface LFSegmentView ()

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIImageView *ivbackground;
@property (nonatomic, assign) CGFloat textMargin;

@end

@implementation LFSegmentView

- (__nullable instancetype)initWithFrame:(CGRect)frame titles:(NSArray <NSString *>*_Nonnull)titles {
    self = [super initWithFrame:frame];
    if (!titles.count || !self) {
        return nil;
    }
    self.duration = 0.3;
    
    _selectedColor = [UIColor redColor];
    _normalColor = [UIColor grayColor];
    self.indicateHeight = 2;
    self.minItemSpace = 20;
    self.font = [UIFont systemFontOfSize:16];
        
    _titles = titles;
    _buttons = [NSMutableArray array];
    self.textMargin = [self calculateSpace];
    
    [self initUI];
    return self;
}

- (void)initUI {
    _ivbackground = [[UIImageView alloc] initWithFrame:self.bounds];
    _ivbackground.contentMode = UIViewContentModeScaleAspectFill;
    _ivbackground.clipsToBounds = YES;
    [self addSubview:_ivbackground];
    
    _contentView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.showsHorizontalScrollIndicator = NO;
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.scrollEnabled = YES;
    
    CGFloat lineHeight = 1/[UIScreen mainScreen].scale;
    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - lineHeight, self.frame.size.width, lineHeight)];
    _bottomLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_bottomLine];
    
    _indicateView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height -self.indicateHeight, 0, self.indicateHeight)];
    _indicateView.backgroundColor = self.indicateColor ? self.indicateColor : self.selectedColor;
    _indicateView.clipsToBounds = YES;
    _indicateView.layer.cornerRadius = 1;
    [_contentView addSubview:_indicateView];
    CGFloat item_x = 0;
    for (int i = 0; i < _titles.count; i++) {
        NSString *title = _titles[i];
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName: self.font}];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(item_x, 0, self.textMargin * 2 + titleSize.width, self.frame.size.height);
        [button setTag:i];
        [button.titleLabel setFont:self.font];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:self.normalColor forState:UIControlStateNormal];
        [button setTitleColor:self.selectedColor forState:UIControlStateSelected];
        button.layer.shadowColor = [UIColor blackColor].CGColor;
        button.layer.shadowOffset =  CGSizeMake(1, 1);
        button.layer.shadowOpacity = 0; // 要设置为1.因为默认是0表示透明
        
        [button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:button];
        
        [_buttons addObject:button];
        item_x += self.textMargin * 2 + titleSize.width;
        
        if (i == 0) {
            button.selected = YES;
            _selectedButton = button;
        }
    }
    self.contentView.contentSize = CGSizeMake(item_x, self.frame.size.height);
    [self addSubview:_contentView];
    [self scrollIndicateView];
}

#pragma mark - 按钮点击

- (void)didClickButton:(UIButton *)button {
    if (button != _selectedButton) {
        button.selected = YES;
        _selectedButton.selected = NO;
        _selectedButton.titleLabel.font = self.font;
        button.titleLabel.font = self.selectedFont;
        _selectedButton = button;
        _currentIndex = _selectedButton.tag;
        [self scrollIndicateView];
        [self scrollSegementView];
    }
    
    if (self.selectedBlock) {
        self.selectedBlock(_selectedButton.tag, button);
    }
}

#pragma mark - 公有方法

- (void)adjustLinePosition:(CGFloat)offsetX containerWidth:(CGFloat)cWidth {
    NSInteger currentIndex = _selectedButton.tag;
    NSInteger targetIndex = currentIndex;
    //偏移量
    CGFloat offset = offsetX - _selectedButton.tag * cWidth;
    if (offset >= 0) {
        targetIndex += 1;
        
    } else {
        targetIndex -= 1;
    }
    
    //指示线原始X
    CGFloat originX = self.indicateStyle == LFSegmentIndicateStyleAlignText? (CGRectGetMinX(_selectedButton.frame) + self.textMargin) : CGRectGetMinX(_selectedButton.frame);
    
    //需要移动的距离
    CGFloat targetMovedWidth = 0;
    if (offset >= 0) {
        targetMovedWidth = [self widthAtIndex:currentIndex];
    } else {
        targetMovedWidth = [self widthAtIndex:targetIndex];
    }
    
    //指示线目标宽度
    CGFloat targetWidth = self.indicateStyle == LFSegmentIndicateStyleAlignText? ([self widthAtIndex:targetIndex] - 2 * self.textMargin) : [self widthAtIndex:targetIndex];
    
    //指示线原始宽度
    CGFloat originWidth = self.indicateStyle == LFSegmentIndicateStyleAlignText? ([self widthAtIndex:_selectedButton.tag] - 2 * self.textMargin) : [self widthAtIndex:_selectedButton.tag];
    
    _indicateView.frame = CGRectMake(originX + targetMovedWidth / self.frame.size.width * offset, _indicateView.frame.origin.y,  originWidth + (targetWidth - originWidth) / self.frame.size.width * fabs(offset), _indicateView.frame.size.height);
}


#pragma mark - 私有方法

//计算item间距
- (CGFloat)calculateSpace {
    if (self.itemSpace > 0) {
        return self.itemSpace / 2;
    }
    CGFloat space = 0;
    CGFloat totalWidth = 0;
    
    for (NSString *title in _titles) {
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName : self.font}];
        totalWidth += titleSize.width;
    }
    
    space = (self.frame.size.width - totalWidth) / _titles.count / 2;
    if (space > self.minItemSpace / 2) {
        return space;
    } else {
        return self.minItemSpace / 2;
    }
}

/**
 根据选中调整segementView的offset
 */
- (void)scrollSegementView {
    CGFloat selectedWidth = _selectedButton.frame.size.width;
    CGFloat offsetX = (self.frame.size.width - selectedWidth) / 2;
    
    if (_selectedButton.frame.origin.x <= self.frame.size.width / 2) {
        [_contentView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else if (CGRectGetMaxX(_selectedButton.frame) >= (_contentView.contentSize.width - self.frame.size.width / 2)) {
        [_contentView setContentOffset:CGPointMake(_contentView.contentSize.width - self.frame.size.width, 0) animated:YES];
    } else {
        [_contentView setContentOffset:CGPointMake(CGRectGetMinX(_selectedButton.frame) - offsetX, 0) animated:YES];
    }
}

/**
 根据选中的按钮滑动指示杆
 */
- (void)scrollIndicateView {
    CGSize titleSize = [_selectedButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.font}];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:self.duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (weakSelf.indicateStyle == LFSegmentIndicateStyleAlignText) {
            weakSelf.indicateView.frame = CGRectMake(CGRectGetMinX(weakSelf.selectedButton.frame) + weakSelf.textMargin, CGRectGetMinY(weakSelf.indicateView.frame), titleSize.width, weakSelf.indicateHeight);
        } else {
            weakSelf.indicateView.frame = CGRectMake(CGRectGetMinX(weakSelf.selectedButton.frame), CGRectGetMinY(weakSelf.indicateView.frame), CGRectGetWidth(weakSelf.selectedButton.frame), weakSelf.indicateHeight);
        }
    } completion:nil];
}

- (CGFloat)widthAtIndex:(NSUInteger)index {
    if (index > _titles.count - 1) {
        return 0;
    }
    UIButton *button = [_buttons objectAtIndex:index];
    return CGRectGetWidth(button.frame);
}

#pragma mark - set

- (void)setSelectedIndex:(NSInteger)index {
    _currentIndex = index;
    if (index > -1 && index < _buttons.count) {
        UIButton *button = _buttons[index];
        [self didClickButton:button];
    }
}


- (void)setIndicateStyle:(LFSegmentIndicateStyle)indicateStyle {
    _indicateStyle = indicateStyle;
    if (indicateStyle == LFSegmentIndicateStyleAlignFull) {
        _indicateView.frame = CGRectMake(_selectedButton.frame.origin.x, self.frame.size.height - _indicateHeight, CGRectGetWidth(_selectedButton.frame), _indicateHeight);
    } else {
        _indicateView.frame = CGRectMake(CGRectGetMinX(_selectedButton.frame) + _textMargin, CGRectGetMinY(_indicateView.frame), CGRectGetWidth(_selectedButton.frame) - self.textMargin*2, self.indicateHeight);
    }
}

- (void)setFont:(UIFont *)font {
    _font = font;
    
    self.textMargin = [self calculateSpace];
    
    CGFloat item_x = 0;
    for (NSInteger i = 0; i < _buttons.count; i++) {
        NSString *title = _titles[i];
        UIButton *button = _buttons[i];
        if (i == self.currentIndex) {
            [button.titleLabel setFont:self.selectedFont];
        } else {
            [button.titleLabel setFont:self.font];
        }
        
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:_font}];
        button.frame = CGRectMake(item_x, 0, self.textMargin * 2 + titleSize.width, self.frame.size.height);
        item_x += self.textMargin * 2 + titleSize.width;
    }
}

- (void)setSelectedFont:(UIFont *)selectedFont {
    _selectedFont = selectedFont;
    self.textMargin = [self calculateSpace];
    
    CGFloat item_x = 0;
    for (NSInteger i = 0; i < _buttons.count; i++) {
        NSString *title = _titles[i];
        UIButton *button = _buttons[i];
        if (i == self.currentIndex) {
            [button.titleLabel setFont:self.selectedFont];
        } else {
            [button.titleLabel setFont:self.font];
        }
        
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:_font}];
        button.frame = CGRectMake(item_x, 0, self.textMargin * 2 + titleSize.width, self.frame.size.height);
        item_x += self.textMargin * 2 + titleSize.width;
    }
}

-(void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    if (!self.indicateColor) {
        self.indicateColor = selectedColor;
    }
    for (NSInteger i = 0; i < _buttons.count; i++) {
        UIButton *button = _buttons[i];
        [button setTitleColor:_selectedColor
                     forState:UIControlStateSelected];
    }
}

- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    for (NSInteger i = 0; i < _buttons.count; i++) {
        UIButton *button = _buttons[i];
        [button setTitleColor:_normalColor
                     forState:UIControlStateNormal];
    }
}

- (void)setIndicateColor:(UIColor *)indicateColor {
    _indicateColor = indicateColor;
    _indicateView.backgroundColor = _indicateColor;
}

- (void)setIndicateHeight:(CGFloat)indicateHeight {
    _indicateHeight = indicateHeight;
    if (_indicateStyle == LFSegmentIndicateStyleAlignFull) {
        _indicateView.frame = CGRectMake(_selectedButton.frame.origin.x, self.frame.size.height - _indicateHeight, CGRectGetWidth(_selectedButton.frame), _indicateHeight);
    } else {
        _indicateView.frame = CGRectMake(CGRectGetMinX(_selectedButton.frame) + _textMargin, self.frame.size.height - _indicateHeight, CGRectGetWidth(_selectedButton.frame) - self.textMargin*2, _indicateHeight);
    }
}

- (void)setMinItemSpace:(CGFloat)minItemSpace {
    _minItemSpace = minItemSpace;
    self.textMargin = [self calculateSpace];
    
    CGFloat item_x = 0;
    for (NSInteger i = 0; i < _buttons.count; i++) {
        NSString *title = _titles[i];
        UIButton *button = _buttons[i];
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName: self.font}];
        button.frame = CGRectMake(item_x, 0, self.textMargin * 2 + titleSize.width, self.frame.size.height);
        item_x += self.textMargin * 2 + titleSize.width;
    }
    
    if (_indicateStyle == LFSegmentIndicateStyleAlignFull) {
        _indicateView.frame = CGRectMake(_selectedButton.frame.origin.x, self.frame.size.height - _indicateHeight, CGRectGetWidth(_selectedButton.frame), _indicateHeight);
    } else {
        _indicateView.frame = CGRectMake(CGRectGetMinX(_selectedButton.frame) + _textMargin, CGRectGetMinY(_indicateView.frame), CGRectGetWidth(_selectedButton.frame) - self.textMargin*2, self.indicateHeight);
    }
}

- (void)setItemSpace:(CGFloat)itemSpace {
    _itemSpace = itemSpace;
    self.textMargin = [self calculateSpace];
    
    CGFloat item_x = 0;
    for (NSInteger i = 0; i < _buttons.count; i++) {
        NSString *title = _titles[i];
        UIButton *button = _buttons[i];
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName: self.font}];
        button.frame = CGRectMake(item_x, 0, self.textMargin * 2 + titleSize.width, self.frame.size.height);
        item_x += self.textMargin * 2 + titleSize.width;
    }
    
    if (_indicateStyle == LFSegmentIndicateStyleAlignFull) {
        _indicateView.frame = CGRectMake(_selectedButton.frame.origin.x, self.frame.size.height - _indicateHeight, CGRectGetWidth(_selectedButton.frame), _indicateHeight);
    } else {
        _indicateView.frame = CGRectMake(CGRectGetMinX(_selectedButton.frame) + _textMargin, CGRectGetMinY(_indicateView.frame), CGRectGetWidth(_selectedButton.frame) - self.textMargin*2, self.indicateHeight);
    }
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    if (backgroundImage) {
        self.ivbackground.image = backgroundImage;
        self.contentView.backgroundColor = [UIColor clearColor];
    }
}

- (void)setNeedShadow:(BOOL)needShadow {
    _needShadow = needShadow;
    
    for (NSInteger i = 0; i < _buttons.count; i++) {
        UIButton *button = _buttons[i];
        button.layer.shadowOpacity = needShadow ? 1 : 0;
    }
}

@end
