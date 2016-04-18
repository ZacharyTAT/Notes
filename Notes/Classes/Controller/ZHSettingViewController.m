//
//  ZHSettingViewController.m
//  Notes
//
//  Created by apple on 3/26/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "ZHSettingViewController.h"
#import "ZHLockerSettingViewController.h"
#import "ZHPswdManageViewController.h"
#import "ZHLoginViewController.h"

#import "ZHSwitchCell.h"
#import "ZHLabelCell.h"

#import "ZHUserTool.h"
#import "ZHUser.h"
#import "ZHDataUtil.h"
#import "ZHSynchronizeTool.h"

#import "ZHNetwork.h"
#import "MBProgressHUD+MJ.h"

@interface ZHSettingViewController ()<ZHLockerSettingViewControllerDelegate,ZHLoginViewControllerDelegate, UIActionSheetDelegate>

/** 密码设置状态标签 */
@property (nonatomic, weak)ZHLabel *passwordStatusLbl;

/** 登录状态标签 */
@property (nonatomic, weak)ZHLabel *loginStatusLbl;

@end

@implementation ZHSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (kPasswordFromUserDefault)
        self.passwordStatusLbl.text = @"已开启";
    else
        self.passwordStatusLbl.text = @"未开启";
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
    __weak typeof(self) weakSelf = self;
    
    if (indexPath.row == 0) {
        cell = [ZHLabelCell labelCellWithTableView:tableView];
        ZHLabelCell *lblCell = (ZHLabelCell *)cell;
        NSString *accountStatus = @"未登录";
        
        void (^selectHandler)() = ^{
            ZHLoginViewController *lvc = [[ZHLoginViewController alloc] init];
            lvc.delegate = weakSelf;
            [weakSelf.navigationController pushViewController:lvc animated:YES];
        };
        
        if ([ZHUserTool isUserExists]) {
            accountStatus = @"已登录";
            
            selectHandler = ^{ //弹出Action sheet
                [[[UIActionSheet alloc] initWithTitle:@"选择您要进行的操作" delegate:weakSelf cancelButtonTitle:@"取消" destructiveButtonTitle:@"注销" otherButtonTitles:@"备份笔记", nil] showInView:weakSelf.view];
            };
        }
        
        lblCell.label.text = accountStatus;
        cell.textLabel.text = @"账号";
        
        [lblCell setSelectHandler:selectHandler];
        
    }else{
        
        cell = [ZHLabelCell labelCellWithTableView:tableView];
        ZHLabelCell *lblCell = (ZHLabelCell *)cell;
        
        NSString *lblText = @"未开启";
        if (kPasswordFromUserDefault) lblText = @"已开启";
        
        lblCell.label.text = lblText;
        
        self.passwordStatusLbl = lblCell.label;
        
        lblCell.textLabel.text = @"手势密码";
        
        [lblCell setSelectHandler:^{
            if (kPasswordFromUserDefault){//已经开启，则跳转到密码管理界面
                
                ZHPswdManageViewController *pswdmvc = [[ZHPswdManageViewController alloc] init];
                
                [weakSelf.navigationController pushViewController:pswdmvc animated:YES];
                
            }else{//没有开启密码，则直接跳转到密码设置界面
                
                ZHLockerSettingViewController *lsvc = [[ZHLockerSettingViewController alloc] init];
                lsvc.delegate = weakSelf;
                [weakSelf.navigationController pushViewController:lsvc animated:YES];
            }
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    
    //更新状态标签
    self.passwordStatusLbl.text = @"已开启";
    
    //弹出设置密码控制器
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ZHLoginViewController Delegate
- (void)loginViewControllerDidSuccess:(ZHLoginViewController *)suvc
{
    [self.tableView reloadData];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    if ([self.delegate respondsToSelector:@selector(settingViewControllerDidSucceedLogin:)]) {
        [self.delegate settingViewControllerDidSucceedLogin:self];
    }
    
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d",buttonIndex);
    
    if (0 == buttonIndex) { //注销,删除账号
        
        if ([ZHUserTool deleteUser]) {
            [MBProgressHUD showSuccess:@"退出成功"];
            //删除所有记录
            [ZHDataUtil clear];
            
            if ([self.delegate respondsToSelector:@selector(settingViewControllerDidLogout:)]) {
                [self.delegate settingViewControllerDidLogout:self];
            }
            
        }else{
            [MBProgressHUD showError:@"退出失败"];
        }
        [self.tableView reloadData];
        
    }else if (1 == buttonIndex) { //备份
        
        ZHUser *user = [ZHUserTool user];
        
        NSMutableDictionary *params = [@{} mutableCopy];
        
        params[@"uid"] = @(user.uid);
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[ZHSynchronizeTool noteDicts] options:0 error:NULL];
//
//        
        params[@"notes"] = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
//        params[@"notes"] = [ZHSynchronizeTool noteDicts];
        
        
        [ZHNetwork post:[NSString stringWithFormat:@"%@/%@",ROOT ,@"upload.php"]
                message:@"正在备份"
compoundResponseSerialize:YES
             parameters:params
                success:^(NSString *responseString, id responseObject) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        NSString *trimedStr = [responseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        
                        NSInteger result = [trimedStr integerValue];
                        if (result == -1 || result == 0) { //没有接收到uid或出错
                            
                        }else{
                            [MBProgressHUD showSuccess:[NSString stringWithFormat:@"成功备份了%d条数据",result]];
                        }
                    });

                } failure:^(NSString *responseString, NSError *error) {
                    
                }];
    }
}

#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%@ dealloc....",[self class]);
}

@end



