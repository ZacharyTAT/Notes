//
//  ZHNoteCell.h
//  Notes
//
//  Created by apple on 12/1/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHMultiButtonTableViewCell.h"

@class ZHNote;

@interface ZHNoteCell : ZHMultiButtonTableViewCell


/**
 *  快速创建cell的类方法
 *
 *  @param tableView cell所在tableview
 *
 *  @return 创建好的cell
 */
+ (instancetype)noteCellWithTableView:(UITableView *)tableView;

@end
