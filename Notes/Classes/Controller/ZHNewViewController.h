//
//  ZHNewViewController.h
//  Notes
//
//  Created by apple on 12/6/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import "ZHDetailNoteViewController.h"

@class ZHNewViewController,ZHNote;

@protocol ZHNewViewControllerDelegate <NSObject,ZHDetailNoteViewControllerDelegate>

@optional

/**
 *  点击了返回按钮
 *  @param note     新建的note模型，应该添加到数据源中
 */
- (void)newViewController:(ZHNewViewController *)newViewController didClickBackBtnWithNewNote:(ZHNote *)note;

/**
 *  点击了删除按钮
 *  @param latestNote   最新的模型，应该删除
 */
- (void)newViewController:(ZHNewViewController *)newViewController didClickDeleteItemWithLatestNote:(ZHNote *)latestNote;

@end

@interface ZHNewViewController : ZHDetailNoteViewController

/** 代理 */
@property(nonatomic, weak)id<ZHNewViewControllerDelegate> delegate;

@end
