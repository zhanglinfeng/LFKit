//
//  LFLogListController.h
//  BaseAPP
//
//  Created by 张林峰 on 2017/11/1.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>
/**日志列表*/
@interface LFLogListController : UIViewController

/**给每个Section加个按钮，点击返回该Section日志路径。使用者可以在该回调实现其他功能，比如将该日志分享出去*/
- (void)addButtonTitle:(NSString *)title callBackData:(void(^)(NSString *dataPath))callBack;

@end
