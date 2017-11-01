//
//  LFOptionTableView.h
//  BaseAPP
//
//  Created by 张林峰 on 15/12/31.
//  Copyright © 2015年 张林峰. All rights reserved.
//
//功能：输入框下面提供选项的列表

#define kCellHeigth 30

#import <UIKit/UIKit.h>
@class LFOptionTableView;
@protocol LFOptionTableViewDelegate <NSObject>

@optional
- (void)LFOptionTableView:(LFOptionTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface LFOptionTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<LFOptionTableViewDelegate>myDelegate;

/**
 *  初始化与TextField等宽并紧贴在TextField下方的提供选项的列表
 *
 *  @param maxHeight  最大高度，self高度＝行数*行高>maxHeight时，self高度＝maxHeight,
 *  @param tf         需要下拉框的TextField
 *  @param parentView 用来add self，可以是TextField的父视图，祖父视图...祖祖视图，当然越大越好
 *  @param array      数据源（可选），如果不传则通过key查找NSUserDefaults里的数据
 *  @param key        通过key查找、存储NSUserDefaults里的数据（可选），key和array至少传一个
 *  @param autoSave   是否自动保存输入纪录
 *
 *  @return LFOptionTableView
 */
- (UITableView *)initWithMaxHeigth:(CGFloat)maxHeight TextField:(UITextField *)tf ParentView:(UIView *)parentView DataSource:(NSMutableArray *)array SaveKey:(NSString *)key IsAutoSave:(BOOL)autoSave;

@end
