//
//  ZHDetailViewController.h
//  Notes
//
//  Created by apple on 12/4/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHNote;

@interface ZHDetailViewController : UIViewController

/** 存储传递过来的文字 */
//@property (nonatomic, copy)NSString *content; // 作废，传模型，不能只是简单的字符串

/** 存储一条笔记各种信息的模型 */
@property (nonatomic,strong)ZHNote *note;

@end
