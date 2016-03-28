//
//  ZHSettingCell.m
//  Notes
//
//  Created by apple on 3/28/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "ZHSettingCell.h"

@implementation ZHSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSettingCell];
    }
    return self;
}

#warning 子类setup会将父类setup覆盖，需要不同命名
- (void)setupSettingCell
{
    self.textLabel.font = [UIFont systemFontOfSize:16.0];
}

@end
