//
//  ZHSwitchCell.m
//  Notes
//
//  Created by apple on 3/26/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "ZHSwitchCell.h"

@interface ZHSwitchCell()

@property (nonatomic, weak)UISwitch *swt;

@end

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
    UISwitch *swt = [[UISwitch alloc] init];
    self.swt = swt;
    [swt addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.accessoryView = swt;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - 设置开关状态

- (void)setSwitchOn:(BOOL)on
{
    [self.swt setOn:on animated:NO];
}

#pragma mark - 开关状态修改事件
- (void)switchValueChanged:(UISwitch *)swc
{
    NSLog(@"%d",swc.isOn);
    if (self.switchValueChangedHander) self.switchValueChangedHander(swc.isOn);
}


@end
