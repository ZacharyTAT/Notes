//
//  ZHScanEditViewController.h
//  Notes
//
//  Created by apple on 12/6/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHNote,ZHScanEditViewController;

@protocol ZHScanEditViewControllerDelegate <NSObject>

@optional
/**
 *  点击了返回的按钮
 */
- (void)scanEditViewController:(ZHScanEditViewController *)sevc didClickBackBtnWithNote:(ZHNote *)note;

@end

@interface ZHScanEditViewController : UIViewController

/** 存储传递过来的文字 */
//@property (nonatomic, copy)NSString *content; // 作废，传模型，不能只是简单的字符串

/** 存储一条笔记各种信息的模型 */
@property(nonatomic, strong)ZHNote *note;

/** 查看和修改笔记控制器的代理 */
@property(nonatomic, weak)id<ZHScanEditViewControllerDelegate> delegate;

@end
