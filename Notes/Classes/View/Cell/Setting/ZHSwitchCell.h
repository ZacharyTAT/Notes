//
//  ZHSwitchCell.h
//  Notes
//
//  Created by apple on 3/26/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//  带有开关的cell,不可点击

#import <UIKit/UIKit.h>

#import "ZHSettingCell.h"

@interface ZHSwitchCell : ZHSettingCell

/** 开关值修改后句柄 */
@property (nonatomic, strong)void (^switchValueChangedHander)(BOOL);

/**
 *  快速创建一个带有开关的cell
 */
+ (instancetype)switchCellWithTableView:(UITableView *)tableView;

/** 设置开关状态 */
- (void)setSwitchOn:(BOOL)on;

@end
