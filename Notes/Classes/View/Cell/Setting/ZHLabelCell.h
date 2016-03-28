//
//  ZHLabelCell.h
//  Notes
//
//  Created by apple on 3/26/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//  带有特定label的cell，可点击

#import <UIKit/UIKit.h>

#import "ZHSettingCell.h"

#import "ZHLabel.h"

@interface ZHLabelCell : ZHSettingCell

/** 显示特定文字的标签 */
@property (nonatomic, weak)ZHLabel *label;

/** 点击事件 */
@property (nonatomic, strong)void (^selectHandler)();

/**
 *  快速创建一个cell
 */
+ (instancetype)labelCellWithTableView:(UITableView *)tableView;

@end
