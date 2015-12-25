//
//  ZHDetailNoteViewController.h
//  Notes
//
//  Created by apple on 12/24/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHNote,ZHDetailNoteViewController;

@protocol ZHDetailNoteViewControllerDelegate <NSObject>

/**
 *  点击了删除按钮
 *  传的两个note都应该删掉，若不为空的话
 */
- (void)detailNoteViewController:(ZHDetailNoteViewController *)dnvc DidClickDeleteItemWithNote:(ZHNote *)note latestNote:(ZHNote *)latestNote;

@end

@protocol ZHDetailNoteViewControllerDataSource <NSObject>

/**
 *  查询当前笔记的前一条笔记
 */
- (ZHNote *)detailNoteViewController:(ZHDetailNoteViewController *)dnvc previousNoteForNote:(ZHNote *)currentNote;
/**
 *  查询当前笔记的下一条笔记
 */
- (ZHNote *)detailNoteViewController:(ZHDetailNoteViewController *)dnvc nextNoteForNote:(ZHNote *)currentNote;
/**
 *  查询笔记是否最上面一条笔记
 *
 *  @param note 待查询的笔记
 */
- (BOOL)detailNoteViewController:(ZHDetailNoteViewController *)dnvc isNoteTopNote:(ZHNote *)note;
/**
 *  查询笔记是否最下面一条笔记
 *
 *  @param note 待查询的笔记
 */
- (BOOL)detailNoteViewController:(ZHDetailNoteViewController *)dnvc isNoteBottomNote:(ZHNote *)note;


@end


@interface ZHDetailNoteViewController : UIViewController

/** 存储一条笔记各种信息的模型 */
@property(nonatomic, strong)ZHNote *note;

/** 代理 */
@property(nonatomic, weak)id<ZHDetailNoteViewControllerDelegate> delegate;

/** 数据源 */
@property(nonatomic,weak)id<ZHDetailNoteViewControllerDataSource> dataSource;

/**
 *  保存数据
 */
- (void)saveWithTitle:(NSString *)title;


@end






