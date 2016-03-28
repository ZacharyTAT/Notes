//
//  ZHSettingViewController.m
//  Notes
//
//  Created by apple on 3/26/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "ZHSettingViewController.h"
#import "ZHLockerSettingViewController.h"

#import "ZHSwitchCell.h"
#import "ZHLabelCell.h"

@interface ZHSettingViewController ()<ZHLockerSettingViewControllerDelegate>

/** 密码设置状态标签 */
@property (nonatomic, weak)ZHLabel *passwordStatusLbl;

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
        
        NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kPasswordKey];
        NSString *lblText = @"未开启";
        if (password) lblText = @"已开启";
        
        lblCell.label.text = lblText;
        
        self.passwordStatusLbl = lblCell.label;
        
        lblCell.textLabel.text = @"手势密码";
        
        __weak typeof(self) weakSelf = self;
        
        [lblCell setSelectHandler:^{
            ZHLockerSettingViewController *lsvc = [[ZHLockerSettingViewController alloc] init];
            lsvc.delegate = weakSelf;
            [weakSelf.navigationController pushViewController:lsvc animated:YES];
        }];
        
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
    
    ZHLabelCell *lblCell = (ZHLabelCell *)cell;
    lblCell.selectHandler();
}


#pragma mark - ZHLockerSettingViewController Delegate
- (void)lockerSettingViewController:(ZHLockerSettingViewController *)lsvc successToSetPassword:(NSString *)password
{
    //保存到NSUserDefault中
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:kPasswordKey];
    
    //更新状态标签
    self.passwordStatusLbl.text = @"已开启";
    
    //弹出设置密码控制器
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%@ dealloc....",[self class]);
}

@end



