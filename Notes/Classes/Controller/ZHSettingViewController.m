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
#import "UIAlertView+Block.h"

#import "ZHUserTool.h"
#import "ZHUser.h"
#import "ZHDataUtil.h"
#import "ZHSynchronizeTool.h"

#import "ZHNetwork.h"
#import "MBProgressHUD+MJ.h"

//本地化字符串

//手势已开启
#define SETTING_VIEW_CONTROLLER_PSD_ON NSLocalizedStringFromTable(@"SETTING_VIEW_CONTROLLER_PSD_ON", @"ZHSettingViewController", @"已开启(手势已开启)")
//手势未开启
#define SETTING_VIEW_CONTROLLER_PSD_OFF NSLocalizedStringFromTable(@"SETTING_VIEW_CONTROLLER_PSD_OFF", @"ZHSettingViewController", @"未开启(手势未开启)")
//手势字符串
#define SETTING_VIEW_CONTROLLER_PSD_STR NSLocalizedStringFromTable(@"SETTING_VIEW_CONTROLLER_PSD_STR", @"ZHSettingViewController", @"手势密码")

//导航栏上的关闭按钮
#define SETTING_VIEW_CONTROLLER_NAV_CLOSE NSLocalizedStringFromTable(@"SETTING_VIEW_CONTROLLER_NAV_CLOSE", @"ZHSettingViewController", @"关闭(导航栏上的关闭按钮)")
//导航栏上的标题
#define SETTING_VIEW_CONTROLLER_NAV_TITLE NSLocalizedStringFromTable(@"SETTING_VIEW_CONTROLLER_NAV_TITLE", @"ZHSettingViewController", @"设置(导航栏上的标题)")

//未登录状态
#define SETTING_VIEW_CONTROLLER_ACCOUNT_LOGIN_YET NSLocalizedStringFromTable(@"SETTING_VIEW_CONTROLLER_ACCOUNT_LOGIN_YET", @"ZHSettingViewController", @"未登录(未登录状态)")
//已登录状态
#define SETTING_VIEW_CONTROLLER_ACCOUNT_LOGIN_ALREADY NSLocalizedStringFromTable(@"SETTING_VIEW_CONTROLLER_ACCOUNT_LOGIN_ALREADY", @"ZHSettingViewController", @"已登录(已登录状态)")
//账号字符串
#define SETTING_VIEW_CONTROLLER_ACCOUNT_STR NSLocalizedStringFromTable(@"SETTING_VIEW_CONTROLLER_ACCOUNT_STR", @"ZHSettingViewController", @"账号")

//actionsheet中的提示文字
#define SETTING_VIEW_CONTROLLER_ACTIONSHEET_MSG NSLocalizedStringFromTable(@"SETTING_VIEW_CONTROLLER_ACTIONSHEET_MSG", @"ZHSettingViewController", @"选择您要进行的操作(actionsheet中的提示文字)")
//actionsheet,取消
#define SETTING_VIEW_CONTROLLER_ACTIONSHEET_CANCEL NSLocalizedStringFromTable(@"SETTING_VIEW_CONTROLLER_ACTIONSHEET_CANCEL", @"ZHSettingViewController", @"取消(actionsheet,取消)")
//actionsheet,备份
#define SETTING_VIEW_CONTROLLER_ACTIONSHEET_BACKUP NSLocalizedStringFromTable(@"SETTING_VIEW_CONTROLLER_ACTIONSHEET_BACKUP", @"ZHSettingViewController", @"备份笔记(actionsheet,备份)")
//actionsheet,注销
#define SETTING_VIEW_CONTROLLER_ACTIONSHEET_LOGOUT NSLocalizedStringFromTable(@"SETTING_VIEW_CONTROLLER_ACTIONSHEET_LOGOUT", @"ZHSettingViewController", @"注销(actionsheet,注销)")

//弹框，标题
#define SETTING_VIEW_CONTROLLER_ALERT_TITLE NSLocalizedStringFromTable(@"SETTING_VIEW_CONTROLLER_ALERT_TITLE", @"ZHSettingViewController", @"提示(弹框，标题)")
//弹框，提示信息
#define SETTING_VIEW_CONTROLLER_ALERT_MSG NSLocalizedStringFromTable(@"SETTING_VIEW_CONTROLLER_ALERT_MSG", @"ZHSettingViewController", @"还未登录，要是忘记手势密码怎么办？(弹框，提示信息)")
//弹框，登录
#define SETTING_VIEW_CONTROLLER_ALERT_LOGON NSLocalizedStringFromTable(@"SETTING_VIEW_CONTROLLER_ALERT_LOGON", @"ZHSettingViewController", @"去登录(弹框，登录)")
//弹框，不会忘记手势
#define SETTING_VIEW_CONTROLLER_ALERT_WONT_FORGET NSLocalizedStringFromTable(@"SETTING_VIEW_CONTROLLER_ALERT_WONT_FORGET", @"ZHSettingViewController", @"打死都不会忘记的(弹框，不会忘记手势)")

//退出弹框，标题
#define SETTING_VIEW_CONTROLLER_LOGOUT_SUCCESS_ALERT_TITLE NSLocalizedStringFromTable(@"SETTING_VIEW_CONTROLLER_LOGOUT_SUCCESS_ALERT_TITLE", @"ZHSettingViewController", @"退出(退出弹框，标题)")
//退出弹框，提示信息
#define SETTING_VIEW_CONTROLLER_LOGOUT_SUCCESS_ALERT_MSG NSLocalizedStringFromTable(@"SETTING_VIEW_CONTROLLER_LOGOUT_SUCCESS_ALERT_MSG", @"ZHSettingViewController", @"退出成功，是否保留手势密码(退出弹框，提示信息)")
//退出弹框，保留密码
#define SETTING_VIEW_CONTROLLER_LOGOUT_SUCCESS_ALERT_KEEP NSLocalizedStringFromTable(@"SETTING_VIEW_CONTROLLER_LOGOUT_SUCCESS_ALERT_KEEP", @"ZHSettingViewController", @"保留(退出弹框，保留密码)")
//退出弹框，不保留密码
#define SETTING_VIEW_CONTROLLER_LOGOUT_SUCCESS_ALERT_THROWAWAY NSLocalizedStringFromTable(@"SETTING_VIEW_CONTROLLER_LOGOUT_SUCCESS_ALERT_THROWAWAY", @"ZHSettingViewController", @"不用了(退出弹框，不保留密码)")
//退出成功
#define SETTING_VIEW_CONTROLLER_LOGOUT_SUCCESS NSLocalizedStringFromTable(@"SETTING_VIEW_CONTROLLER_LOGOUT_SUCCESS", @"ZHSettingViewController", @"退出成功")
//退出失败
#define SETTING_VIEW_CONTROLLER_LOGOUT_FAILED NSLocalizedStringFromTable(@"SETTING_VIEW_CONTROLLER_LOGOUT_FAILED", @"ZHSettingViewController", @"退出失败")
//用于提示还未备份笔记弹框
#define SETTING_VIEW_CONTROLLER_LOGOUT_ALERT_TITLE NSLocalizedStringFromTable(@"SETTING_VIEW_CONTROLLER_LOGOUT_ALERT_TITLE", @"ZHSettingViewController", @"注销(用于提示还未备份笔记弹框)")
#define SETTING_VIEW_CONTROLLER_LOGOUT_ALERT_MSG NSLocalizedStringFromTable(@"SETTING_VIEW_CONTROLLER_LOGOUT_ALERT_MSG", @"ZHSettingViewController", @"您还有笔记未备份，是否先备份后退出(用于提示还未备份笔记弹框)")
#define SETTING_VIEW_CONTROLLER_LOGOUT_ALERT_BACKUP_LOGOUT NSLocalizedStringFromTable(@"SETTING_VIEW_CONTROLLER_LOGOUT_ALERT_BACKUP_LOGOUT", @"ZHSettingViewController", @"先备份再退出(用于提示还未备份笔记弹框)")
#define SETTING_VIEW_CONTROLLER_LOGOUT_ALERT_LOGOUT_DIRECTLY NSLocalizedStringFromTable(@"SETTING_VIEW_CONTROLLER_LOGOUT_ALERT_LOGOUT_DIRECTLY", @"ZHSettingViewController", @"直接退出(用于提示还未备份笔记弹框)")

//备份
#define SETTING_VIEW_CONTROLLER_BACKUP_ING NSLocalizedStringFromTable(@"SETTING_VIEW_CONTROLLER_BACKUP_ING", @"ZHSettingViewController", @"正在备份")
//成功备份笔记条数
#define SETTING_VIEW_CONTROLLER_BACKUP_COUNT NSLocalizedStringFromTable(@"SETTING_VIEW_CONTROLLER_BACKUP_COUNT", @"ZHSettingViewController", @"成功备份了%d条数据(成功备份笔记条数)")

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
        self.passwordStatusLbl.text = SETTING_VIEW_CONTROLLER_PSD_ON; //@"已开启";
    else
        self.passwordStatusLbl.text = SETTING_VIEW_CONTROLLER_PSD_OFF; //@"未开启";
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
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:SETTING_VIEW_CONTROLLER_NAV_CLOSE//@"关闭"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(close)];
    
    //02.标题
    self.title = SETTING_VIEW_CONTROLLER_NAV_TITLE; //@"设置";
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

#pragma mark - 跳转到密码设置界面
/**
 *  跳转到密码设置界面
 */
- (void)toLockerSettingVc
{
    ZHLockerSettingViewController *lsvc = [[ZHLockerSettingViewController alloc] init];
    lsvc.delegate = self;
    [self.navigationController pushViewController:lsvc animated:YES];
}

#pragma mark - 跳转到登录界面
/**
 *  跳转到登录界面
 */
- (void)toLoginVc
{
    ZHLoginViewController *lvc = [[ZHLoginViewController alloc] init];
    lvc.delegate = self;
    [self.navigationController pushViewController:lvc animated:YES];
}

#pragma mark - 跳转到密码管理界面
/**
 *  跳转到密码管理界面
 */
- (void)toPswdManageVc
{
    ZHPswdManageViewController *pswdmvc = [[ZHPswdManageViewController alloc] init];
    
    [self.navigationController pushViewController:pswdmvc animated:YES];
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
        NSString *accountStatus = SETTING_VIEW_CONTROLLER_ACCOUNT_LOGIN_YET; //@"未登录";
        
        void (^selectHandler)() = ^{
            [weakSelf toLoginVc];
        };
        
        if ([ZHUserTool isUserExists]) {
            accountStatus = SETTING_VIEW_CONTROLLER_ACCOUNT_LOGIN_ALREADY; //@"已登录";
            
            selectHandler = ^{ //弹出Action sheet
                [[[UIActionSheet alloc] initWithTitle:SETTING_VIEW_CONTROLLER_ACTIONSHEET_MSG //@"选择您要进行的操作"
                                             delegate:weakSelf
                                    cancelButtonTitle:SETTING_VIEW_CONTROLLER_ACTIONSHEET_CANCEL //@"取消"
                               destructiveButtonTitle:SETTING_VIEW_CONTROLLER_ACTIONSHEET_LOGOUT //@"注销"
                                    otherButtonTitles:SETTING_VIEW_CONTROLLER_ACTIONSHEET_BACKUP /*@"备份笔记"*/, nil]
                 showInView:weakSelf.view];
            };
        }
        
        lblCell.label.text = accountStatus;
        cell.textLabel.text = SETTING_VIEW_CONTROLLER_ACCOUNT_STR; //@"账号";
        
        [lblCell setSelectHandler:selectHandler];
        
    }else{
        
        cell = [ZHLabelCell labelCellWithTableView:tableView];
        ZHLabelCell *lblCell = (ZHLabelCell *)cell;
        
        NSString *lblText = SETTING_VIEW_CONTROLLER_PSD_OFF; //@"未开启";
        if (kPasswordFromUserDefault) lblText = SETTING_VIEW_CONTROLLER_PSD_ON; //@"已开启";
        
        lblCell.label.text = lblText;
        
        self.passwordStatusLbl = lblCell.label;
        
        lblCell.textLabel.text = SETTING_VIEW_CONTROLLER_PSD_STR; //@"手势密码";
        
        [lblCell setSelectHandler:^{
            if (kPasswordFromUserDefault){//已经开启，则跳转到密码管理界面
                
                [weakSelf toPswdManageVc];
                
            }else{//没有开启密码，则直接跳转到密码设置界面
                
                if ([ZHUserTool isUserExists]) { //账号存在，则直接去密码设置界面
                    
                    [weakSelf toLockerSettingVc];
                    
                }else{ //账号不存在，弹框让用户选择
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: SETTING_VIEW_CONTROLLER_ALERT_TITLE //@"提示"
                                                                        message: SETTING_VIEW_CONTROLLER_ALERT_MSG //@"还未登录，要是忘记手势密码怎么办？"
                                                                       delegate:nil
                                                              cancelButtonTitle: SETTING_VIEW_CONTROLLER_ALERT_LOGON //@"去登录"
                                                              otherButtonTitles:SETTING_VIEW_CONTROLLER_ALERT_WONT_FORGET /*@"打死都不会忘记的"*/, nil];
                    
                    [alertView setClickHandler:^(UIAlertView *alertView, NSUInteger btnIdx) {
                        if (0 == btnIdx) { //去登录
                            [weakSelf toLoginVc];
                        }else{ //直接去密码设置界面
                            [weakSelf toLockerSettingVc];
                        }
                    }];
                    
                    [alertView show];
                }
                
                
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
    self.passwordStatusLbl.text = SETTING_VIEW_CONTROLLER_PSD_ON; //@"已开启";
    
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

#pragma mark - 登出
/**
 *  登出
 */
- (void)logout
{
    __weak typeof(self) weakSelf = self;
    
    if ([ZHUserTool deleteUser]) {
        //删除所有记录
        [ZHDataUtil clear];
        
        if ([self.delegate respondsToSelector:@selector(settingViewControllerDidLogout:)]) {
            [self.delegate settingViewControllerDidLogout:self];
        }
//        [MBProgressHUD showSuccess:@"退出成功" toView:self.view];
        
        //若之前设置了手势密码，让用户选择是否保留手势密码
        if (kPasswordFromUserDefault) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:SETTING_VIEW_CONTROLLER_LOGOUT_SUCCESS_ALERT_TITLE //@"退出"
                                                                message:SETTING_VIEW_CONTROLLER_LOGOUT_SUCCESS_ALERT_MSG //@"退出成功，是否保留手势密码"
                                                               delegate:nil
                                                      cancelButtonTitle:SETTING_VIEW_CONTROLLER_LOGOUT_SUCCESS_ALERT_KEEP //@"保留"
                                                      otherButtonTitles:SETTING_VIEW_CONTROLLER_LOGOUT_SUCCESS_ALERT_THROWAWAY /*@"不用了"*/, nil];
            
            [alertView setClickHandler:^(UIAlertView *alertView, NSUInteger btnIdx) {
                if (1 == btnIdx) { //不保留
                    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kPasswordKey];
                    
                    //这里还要再更新一遍UI
                    [weakSelf.tableView reloadData];
                }
            }];
            
            [alertView show];
            
        }else{ //没有设置手势密码，则直接退出
            
            [MBProgressHUD showSuccess:SETTING_VIEW_CONTROLLER_LOGOUT_SUCCESS/*@"退出成功"*/ toView:self.view];
        }
        
    }else{
        [MBProgressHUD showError:SETTING_VIEW_CONTROLLER_LOGOUT_FAILED/*@"退出失败"*/ toView:self.view];
    }
    
    //更新UI
    [self.tableView reloadData];
}

#pragma mark - 备份
/**
 *  备份
 */
- (void)backupWithComplitionHandler:(void (^) ()) complitionHandler
{
    ZHUser *user = [ZHUserTool user];
    
    NSMutableDictionary *params = [@{} mutableCopy];
    
    params[@"uid"] = @(user.uid);
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[ZHSynchronizeTool noteDicts] options:0 error:NULL];
    //
    //
    params[@"notes"] = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    //        params[@"notes"] = [ZHSynchronizeTool noteDicts];
    
    
    [ZHNetwork post:[NSString stringWithFormat:@"%@/%@",ROOT ,@"upload.php"]
            message:SETTING_VIEW_CONTROLLER_BACKUP_ING //@"正在备份"
compoundResponseSerialize:YES
         parameters:params
            success:^(NSString *responseString, id responseObject) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    NSString *trimedStr = [responseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    NSInteger result = [trimedStr integerValue];
                    if (result == -1 || result == 0) { //没有接收到uid或出错
                        
                    }else{
                        [MBProgressHUD showSuccess:[NSString stringWithFormat:SETTING_VIEW_CONTROLLER_BACKUP_COUNT/*@"成功备份了%d条数据"*/,result]];
                        if (complitionHandler) complitionHandler();
                    }
                });
                
            } failure:^(NSString *responseString, NSError *error) {
                if (complitionHandler) complitionHandler();
            }];
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d",buttonIndex);
    
    if (0 == buttonIndex) { //注销,删除账号
        
        if (YES == kNotesTobeUpdatedFromUserDefault) { //还有未备份的笔记,弹框提示
            /*
            [[[UIAlertView alloc] initWithTitle:@"注销"
                                       message:@"您还有笔记未备份，是否先备份后退出"
                                      delegate:self
                             cancelButtonTitle:@"先备份再退出"
                             otherButtonTitles:@"直接退出", nil] show];
             */
            UIAlertView *alertView =
            [[UIAlertView alloc] initWithTitle:SETTING_VIEW_CONTROLLER_LOGOUT_ALERT_TITLE //@"注销"
                                       message:SETTING_VIEW_CONTROLLER_LOGOUT_ALERT_MSG //@"您还有笔记未备份，是否先备份后退出"
                                      delegate:nil
                             cancelButtonTitle:SETTING_VIEW_CONTROLLER_LOGOUT_ALERT_BACKUP_LOGOUT //@"先备份再退出"
                             otherButtonTitles:SETTING_VIEW_CONTROLLER_LOGOUT_ALERT_LOGOUT_DIRECTLY /*@"直接退出"*/, nil];
            
            __weak typeof(self) weakSelf = self;
            
            [alertView setClickHandler:^(UIAlertView *alertView, NSUInteger btnIdx) {
                [weakSelf alertView:alertView clickedButtonAtIndex:btnIdx];
            }];
            
            [alertView show];
            
        }else{ //直接退出
            [self logout];
        }
        
    }else if (1 == buttonIndex) { //备份
        [self backupWithComplitionHandler:NULL];
    }
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d",buttonIndex);
    
    if (0 == buttonIndex) { //先备份再退出
        
        __weak typeof(self) weakSelf = self;
        
        [self backupWithComplitionHandler:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf logout];
            });
            
        }];
        
    }else{ //直接退出
        [self logout];
    }
    
    
}

#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%@ dealloc....",[self class]);
}

@end



