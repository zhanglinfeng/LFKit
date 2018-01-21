//
//  LFSegmentView.m
//  LFKit
//
//  Created by 张林峰 on 2018/1/21.
//  Copyright © 2018年 张林峰. All rights reserved.
//

#import "LFSegmentView.h"
#import <objc/runtime.h>

@implementation LFSegmentConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectedColor = [UIColor redColor];
        self.normalColor = [UIColor grayColor];
        self.indicateColor = self.selectedColor;
        self.indicateHeight = 2;
        self.minItemSpace = 20;
        self.font = [UIFont systemFontOfSize:16];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    id obj = [[[self class] allocWithZone:zone] init];
    
    Class class = [self class];
    unsigned int count = 0;
    //获取类中所有成员变量名
    Ivar *ivar = class_copyIvarList(class, &count);
    for (int i = 0; i < count; i++) {
        Ivar iva = ivar[i];
        const char *name = ivar_getName(iva);
        NSString *strName = [NSString stringWithUTF8String:name];
        //进行解档取值
        //            id value = [decoder decodeObjectForKey:strName];
        id value = [self valueForKey:strName];
        //利用KVC对属性赋值
        [obj setValue:value forKey:strName];
    }
    free(ivar);
    
    return obj;
}

@end

@implementation LFSegmentDefaultConfig

+ (instancetype)sharedInstance {
    static LFSegmentDefaultConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.config = [[LFSegmentConfig alloc] init];
        
    });
    return instance;
}

@end


@interface LFSegmentView ()

@property (nonatomic, strong) LFSegmentConfig * _Nonnull config;//默认使用LFSegmentDefaultConfig
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
    self.config = [[LFSegmentDefaultConfig sharedInstance].config copy];
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
    _bottomLine.backgroundColor = [UIColor grayColor];
    [self addSubview:_bottomLine];
    
    _indicateView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height -self.config.indicateHeight, 0, self.config.indicateHeight)];
    _indicateView.backgroundColor = self.config.indicateColor;
    [_contentView addSubview:_indicateView];
    CGFloat item_x = 0;
    for (int i = 0; i < _titles.count; i++) {
        NSString *title = _titles[i];
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName: self.config.font}];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(item_x, 0, self.textMargin * 2 + titleSize.width, self.frame.size.height);
        [button setTag:i];
        [button.titleLabel setFont:self.config.font];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:self.config.normalColor forState:UIControlStateNormal];
        [button setTitleColor:self.config.selectedColor forState:UIControlStateSelected];
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
}


#pragma mark - 按钮点击

- (void)didClickButton:(UIButton *)button {
    if (button != _selectedButton) {
        button.selected = YES;
        _selectedButton.selected = NO;
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

- (void)adjustLinePosition:(CGFloat)offsetX {
    NSInteger currentIndex = _selectedButton.tag;
    
    // 当当前的偏移量大于被选中index的偏移量的时候，就是在右侧
    CGFloat offset; // 在同一侧的偏移量
    NSInteger buttonIndex = currentIndex;
    if (offsetX >= _selectedButton.tag * self.frame.size.width) {
        offset = offsetX - _selectedButton.tag * self.frame.size.width;
        buttonIndex += 1;
    } else {
        offset = _selectedButton.tag * self.frame.size.width - offsetX;
        buttonIndex -= 1;
        currentIndex -= 1;
    }
    
    CGFloat originMovedX = self.config.indicateStyle == LFSegmentIndicateStyleAlignText? (CGRectGetMinX(_selectedButton.frame) + self.textMargin) : CGRectGetMinX(_selectedButton.frame);
    CGFloat targetMovedWidth = [self widthAtIndex:currentIndex];//需要移动的距离
    
    CGFloat targetButtonWidth = self.config.indicateStyle == LFSegmentIndicateStyleAlignText? ([self widthAtIndex:buttonIndex] - 2 * self.textMargin) : [self widthAtIndex:buttonIndex]; // 这个会影响width
    CGFloat originButtonWidth = self.config.indicateStyle == LFSegmentIndicateStyleAlignText? ([self widthAtIndex:_selectedButton.tag] - 2 * self.textMargin) : [self widthAtIndex:_selectedButton.tag];
    
    
    CGFloat moved; // 移动的距离
    moved = offsetX - _selectedButton.tag * self.frame.size.width;
    _indicateView.frame = CGRectMake(originMovedX + targetMovedWidth / self.frame.size.width * moved, _indicateView.frame.origin.y,  originButtonWidth + (targetButtonWidth - originButtonWidth) / self.frame.size.width * offset, _indicateView.frame.size.height);
}


#pragma mark - 私有方法

//计算item间距
- (CGFloat)calculateSpace {
    CGFloat space = 0;
    CGFloat totalWidth = 0;
    
    for (NSString *title in _titles) {
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName : self.config.font}];
        totalWidth += titleSize.width;
    }
    
    space = (self.frame.size.width - totalWidth) / _titles.count / 2;
    if (space > self.config.minItemSpace / 2) {
        return space;
    } else {
        return self.config.minItemSpace / 2;
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
    CGSize titleSize = [_selectedButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.config.font}];
    [UIView animateWithDuration:self.duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (self.config.indicateStyle == LFSegmentIndicateStyleAlignText) {
            _indicateView.frame = CGRectMake(CGRectGetMinX(_selectedButton.frame) + _textMargin, CGRectGetMinY(_indicateView.frame), titleSize.width, self.config.indicateHeight);
        } else {
            _indicateView.frame = CGRectMake(CGRectGetMinX(_selectedButton.frame), CGRectGetMinY(_indicateView.frame), CGRectGetWidth(_selectedButton.frame), self.config.indicateHeight);
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


- (void)setConfig:(LFSegmentConfig *)config {
    _config = config;
    if (_config.indicateStyle == LFSegmentIndicateStyleAlignFull) {
        _indicateView.frame = CGRectMake(_selectedButton.frame.origin.x, self.frame.size.height - _config.indicateHeight, CGRectGetWidth(_selectedButton.frame), _config.indicateHeight);
    } else {
        _indicateView.frame = CGRectMake(CGRectGetMinX(_selectedButton.frame) + _textMargin, CGRectGetMinY(_indicateView.frame), CGRectGetWidth(_selectedButton.frame) - self.textMargin*2, self.config.indicateHeight);
    }
    
    CGFloat item_x = 0;
    for (NSInteger i = 0; i < _buttons.count; i++) {
        NSString *title = _titles[i];
        UIButton *button = _buttons[i];
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName: self.config.font}];
        [button setTitleColor:_config.selectedColor
                     forState:UIControlStateSelected];
        [button setTitleColor:_config.normalColor
                     forState:UIControlStateNormal];
        button.frame = CGRectMake(item_x, 0, self.textMargin * 2 + titleSize.width, self.frame.size.height);
        item_x += self.textMargin * 2 + titleSize.width;
    }
    
    
    _indicateView.backgroundColor = _config.indicateColor;
    self.textMargin = [self calculateSpace];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    
    if (backgroundImage) {
        self.ivbackground.image = backgroundImage;
        self.contentView.backgroundColor = [UIColor clearColor];
    }
}

@end
