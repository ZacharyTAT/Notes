//
//  ZHSwitchCell.m
//  Notes
//
//  Created by apple on 3/26/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "ZHSwitchCell.h"

@implementation ZHSwitchCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    
    return self;
}

+ (instancetype)switchCellWithTableView:(UITableView *)tableView
{
    NSString static *switchCellID = @"SWITCHCELLID";
    
    ZHSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:switchCellID];
    
    if (cell == nil) {
        cell = [[ZHSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:switchCellID];
    }
    
    return cell;
}

/**
 *  初始化
 */
- (void)setup
{
    UISwitch *swc = [[UISwitch alloc] init];
    [swc addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.accessoryView = swc;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)switchValueChanged:(UISwitch *)swc
{
    NSLog(@"%d",swc.isOn);
}


@end
