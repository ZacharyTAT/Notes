//
//  ZHNewViewController.h
//  Notes
//
//  Created by apple on 12/6/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import "ZHScanEditViewController.h"

@class ZHNewViewController,ZHNote;

@protocol ZHNewViewControllerDelegate <NSObject,ZHScanEditViewControllerDelegate>

@optional

/**
 *  点击了返回按钮
 *  @param note     新建的note模型，应该添加到数据源中
 */
- (void)newViewController:(ZHNewViewController *)newViewController didClickBackBtnWithNewNote:(ZHNote *)note;

@end

@interface ZHNewViewController : ZHScanEditViewController

/** 代理 */
@property(nonatomic, weak)id<ZHNewViewControllerDelegate> delegate;

@end
