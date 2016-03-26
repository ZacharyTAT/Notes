//
//  ZHSwitchCell.h
//  Notes
//
//  Created by apple on 3/26/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//  带有开关的cell,不可点击

#import <UIKit/UIKit.h>

@interface ZHSwitchCell : UITableViewCell

/**
 *  快速创建一个带有开关的cell
 */
+ (instancetype)switchCellWithTableView:(UITableView *)tableView;

@end
