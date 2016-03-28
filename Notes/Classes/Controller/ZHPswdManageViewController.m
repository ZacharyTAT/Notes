//
//  ZHPswdManageViewController.m
//  Notes
//
//  Created by apple on 3/28/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//  管理密码控制器

#import "ZHPswdManageViewController.h"
#import "ZHLockerSettingViewController.h"

#import "ZHLabelCell.h"
#import "ZHSwitchCell.h"

#import "ZHLocker.h"

@interface ZHPswdManageViewController ()<ZHLockerSettingViewControllerDelegate>

/** 表格行数 */
@property (nonatomic, assign)NSInteger rowCount;

@end

@implementation ZHPswdManageViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"手势密码";
    
    self.rowCount = 2;
}


#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    
    if (indexPath.row == 0) {//带开关
        ZHSwitchCell *switchCell = [ZHSwitchCell switchCellWithTableView:tableView];
        
        switchCell.textLabel.text = @"手势密码";
        
        BOOL on = NO;
        
        if (kPasswordFromUserDefault) on = YES;
        
        [switchCell setSwitchOn:on];
        
        [switchCell setSwitchValueChangedHander:^(BOOL on) {
            if (on) {//现在是开启状态，则之前是关闭，点击了之后，应该开启密码功能
                
                ZHLockerSettingViewController *lsvc = [[ZHLockerSettingViewController alloc] init];
                lsvc.delegate = weakSelf;
                [weakSelf.navigationController pushViewController:lsvc animated:YES];
                
            }else{//现在是关闭状态，之前是开启，点击之后应该关闭密码功能,需要弹出验证视图
                [ZHLocker verifyInViewControlloer:weakSelf
                                            title:@"验证手势密码"
                                              tip:@"请使用原手势密码验证"
                                completionHandler:
                 ^(ZHUnLockerViewController *ulvc, BOOL result) {
                     [weakSelf dismissViewControllerAnimated:YES
                                                  completion:NULL];
                     //在磁盘上清除密码
                     [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kPasswordKey];
                     if (result) weakSelf.rowCount = 1;
                     [weakSelf.tableView reloadData];
                }];
            }
        }];
        
        return switchCell;
        
    }else{ //可点击,修改手势密码
        ZHLabelCell *lblCell = [ZHLabelCell labelCellWithTableView:tableView];
        
        lblCell.textLabel.text = @"修改手势密码";
        
        [lblCell setSelectHandler:^{ //修改密码视图
            
            [ZHLocker verifyInViewControlloer:weakSelf
                                        title:@"验证手势密码"
                                          tip:@"请使用原手势密码验证"
                            completionHandler:
             ^(ZHUnLockerViewController *ulvc, BOOL result) {
                 [weakSelf dismissViewControllerAnimated:!result completion:NULL];
                 
                 if (result) {//验证通过,展示设置密码界面
                     ZHLockerSettingViewController *lsvc = [[ZHLockerSettingViewController alloc] init];
                     lsvc.delegate = weakSelf;
                     [weakSelf.navigationController pushViewController:lsvc animated:NO];
                 }
             }];
            
        }];
        
        return lblCell;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[ZHSwitchCell class]]) return;
    
    ZHLabelCell *lblCell = (ZHLabelCell *)cell;
    
    if (lblCell.selectHandler) lblCell.selectHandler();
}

#pragma mark - ZHLockerSettingViewController Delegate
- (void)lockerSettingViewController:(ZHLockerSettingViewController *)lsvc successToSetPassword:(NSString *)password
{
    //保存到NSUserDefault中
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:kPasswordKey];
    
    //弹出设置密码控制器
    [self.navigationController popViewControllerAnimated:YES];
    
    //更新表格
    self.rowCount = 2;
    [self.tableView reloadData];
}


@end
