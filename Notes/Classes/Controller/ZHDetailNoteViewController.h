//
//  ZHDetailNoteViewController.h
//  Notes
//
//  Created by apple on 12/24/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHNote;

@protocol ZHDetailNoteViewControllerDelegate <NSObject>

@end

@interface ZHDetailNoteViewController : UIViewController

/** 存储一条笔记各种信息的模型 */
@property(nonatomic, strong)ZHNote *note;

/** 代理 */
@property(nonatomic, weak)id<ZHDetailNoteViewControllerDelegate> delegate;

/**
 *  保存数据
 */
- (void)saveWithTitle:(NSString *)title;


@end
