//
//  ZHPswdManageViewController.m
//  Notes
//
//  Created by apple on 3/28/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//  管理密码控制器

#import "ZHPswdManageViewController.h"

#import "ZHLabelCell.h"
#import "ZHSwitchCell.h"

@interface ZHPswdManageViewController ()

@end

@implementation ZHPswdManageViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"手势密码";
}


#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {//带开关
        ZHSwitchCell *switchCell = [ZHSwitchCell switchCellWithTableView:tableView];
        
        switchCell.textLabel.text = @"手势密码";
        
        [switchCell setSwitchOn:YES];
        
        [switchCell setSwitchValueChangedHander:^(BOOL on) {
            NSLog(@"开关的值改为%d",on);
        }];
        
        return switchCell;
    }else{ //可点击,修改手势密码
        ZHLabelCell *lblCell = [ZHLabelCell labelCellWithTableView:tableView];
        
        lblCell.textLabel.text = @"修改手势密码";
        
        [lblCell setSelectHandler:^{
            
        }];
        
        return lblCell;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}


@end
