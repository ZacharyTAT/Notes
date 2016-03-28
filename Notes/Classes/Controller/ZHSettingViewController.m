//
//  ZHSettingViewController.m
//  Notes
//
//  Created by apple on 3/26/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "ZHSettingViewController.h"

#import "ZHSwitchCell.h"
#import "ZHLabelCell.h"

@interface ZHSettingViewController ()

@end

@implementation ZHSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setup];
}


- (void)setup
{
    [self setupNavItem];
}

#pragma mark - 初始化导航栏按钮
/**
 *  初始化导航栏按钮
 */
- (void)setupNavItem
{
    //01.左侧，关闭按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    
    //02.标题
    self.title = @"设置";
}

#pragma mark - 关闭按钮点击
/**
 *  关闭按钮点击
 */
- (void)close
{
    NSLog(@"close");
    //通知代理
    
    if ([self.delegate respondsToSelector:@selector(settingViewControllerDidClickClose:)]) {
        [self.delegate settingViewControllerDidClickClose:self];
    }
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        //        cell = [ZHSwitchCell switchCellWithTableView:tableView];
        cell = [ZHLabelCell labelCellWithTableView:tableView];
        ZHLabelCell *lblCell = (ZHLabelCell *)cell;
        lblCell.label.text = @"未登录";
        cell.textLabel.text = @"账号";
    }else{
        cell = [ZHLabelCell labelCellWithTableView:tableView];
        ZHLabelCell *lblCell = (ZHLabelCell *)cell;
        lblCell.label.text = @"未开启";
        cell.textLabel.text = @"手势密码";
        
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[ZHSwitchCell class]]) return;
    NSLog(@"%@ seleted",indexPath);
}


#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%@ dealloc....",[self class]);
}

@end



