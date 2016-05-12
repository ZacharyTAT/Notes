//
//  ZHLoginViewController.m
//  Notes
//
//  Created by apple on 4/15/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "ZHLoginViewController.h"
#import "ZHSignupViewController.h"

#import "ZHLoginView.h"

#import "MBProgressHUD+MJ.h"
#import "ZHNetwork.h"

#import "ZHUserTool.h"
#import "ZHSynchronizeTool.h"
#import "ZHUser.h"

//导航栏标题
#define LOGIN_VIEW_CONTROLLER_NAV_TITLE NSLocalizedStringFromTable(@"LOGIN_VIEW_CONTROLLER_NAV_TITLE", @"ZHLoginViewController", @"登录")
//
#define LOGIN_VIEW_CONTROLLER_NO_SUCH_USER NSLocalizedStringFromTable(@"LOGIN_VIEW_CONTROLLER_NO_SUCH_USER", @"ZHLoginViewController", @"用户名不存在")

#define LOGIN_VIEW_CONTROLLER_TOBE_REVIEWED NSLocalizedStringFromTable(@"LOGIN_VIEW_CONTROLLER_TOBE_REVIEWED", @"ZHLoginViewController", @"用户未通过审核")
//
#define LOGIN_VIEW_CONTROLLER_INCORRECT_PSWD NSLocalizedStringFromTable(@"LOGIN_VIEW_CONTROLLER_INCORRECT_PSWD", @"ZHLoginViewController", @"密码错误")

#define LOGIN_VIEW_CONTROLLER_LOGIN_SUCCESS NSLocalizedStringFromTable(@"LOGIN_VIEW_CONTROLLER_LOGIN_SUCCESS", @"ZHLoginViewController", @"登录成功")

#define LOGIN_VIEW_CONTROLLER_VERIFYING NSLocalizedStringFromTable(@"LOGIN_VIEW_CONTROLLER_VERIFYING", @"ZHLoginViewController", @"正在验证")

#define LOGIN_VIEW_CONTROLLER_SIGNUP NSLocalizedStringFromTable(@"LOGIN_VIEW_CONTROLLER_SIGNUP", @"ZHLoginViewController", @"注册")


@interface ZHLoginViewController ()<ZHLoginViewDelegate,ZHSignupViewControllerDelegate>

@property (nonatomic, weak)ZHLoginView *loginView;

/** 注册按钮 */
@property (nonatomic, weak)UIButton *signupBtn;

@end

@implementation ZHLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = LOGIN_VIEW_CONTROLLER_NAV_TITLE; //@"登录";
    
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.signupBtn.hidden = self.hideSignupBtn;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //[self.loginView userTxtFieldBecomeFirstResponder];
}

- (void)setup
{
    //01.背景
    self.view.backgroundColor = ZHColor(230, 230, 230);
    
    //02.登录
    [self setupLoginView];
    
    //03.注册
    [self setupSignUpBtn];
}

#pragma mark - 初始化登录视图
/**
 *  初始化登录视图
 */
- (void)setupLoginView
{
    ZHLoginView *loginView = [[ZHLoginView alloc] init];
    self.loginView = loginView;
//    loginView.backgroundColor = [UIColor purpleColor];
    loginView.delegate = self;
    CGFloat loginViewX = 0;
    CGFloat loginViewY = 64 + 20;
    loginView.frame = CGRectMake(loginViewX, loginViewY, self.view.frame.size.width -  2 * loginViewX, 300);
    [self.view addSubview:loginView];
}

#pragma mark - ZHLoginView Delegate

#pragma mark - 登录
- (void)loginView:(ZHLoginView *)loginView didLoginWithUserName:(NSString *)username password:(NSString *)password
{
    NSLog(@"login");
    
    if ([ZHUserTool isUserExists]) {
        ZHUser *user = [ZHUserTool user];
        //若用户已存在，则不需要发请求再次登录
        //此种情况针对忘记手势密码
        
        if (![username isEqualToString:user.username]) {
            [MBProgressHUD showError:LOGIN_VIEW_CONTROLLER_NO_SUCH_USER/*@"用户名不正确"*/];
        }else if (![password isEqualToString:user.password]) {
            [MBProgressHUD showError:LOGIN_VIEW_CONTROLLER_INCORRECT_PSWD/*@"密码错误"*/];
        }else{
            [MBProgressHUD showSuccess:LOGIN_VIEW_CONTROLLER_LOGIN_SUCCESS/*@"登录成功"*/];
            //返回上一页面
            NSLog(@"登录成功");
            [self accountOKWithUsername:user.username password:user.password userId:user.uid];
        }
        
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
        //发请求给服务器
    
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        params[@"username"] = username;
        params[@"password"] = password;
        
        [ZHNetwork post:[NSString stringWithFormat:@"%@/%@",ROOT,@"login.php"]
                message:LOGIN_VIEW_CONTROLLER_VERIFYING //@"正在验证"
compoundResponseSerialize:YES
             parameters:params success:^(NSString *responseString, id responseObject) {
                 NSInteger result = [responseString intValue];
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         if (result == -2) {
                             [MBProgressHUD showError:LOGIN_VIEW_CONTROLLER_NO_SUCH_USER /*@"用户名不存在"*/];
                         }else if (result == -1) {
                             [MBProgressHUD showError:LOGIN_VIEW_CONTROLLER_TOBE_REVIEWED /*@"用户未通过审核"*/];
                         }else if (result == 0) {
                             [MBProgressHUD showError:LOGIN_VIEW_CONTROLLER_INCORRECT_PSWD /*@"密码错误"*/];
                         }else{
                             [MBProgressHUD showSuccess:LOGIN_VIEW_CONTROLLER_LOGIN_SUCCESS /*@"登录成功"*/];
                             //返回上一页面
                             NSLog(@"登录成功");
                             [weakSelf accountOKWithUsername:username password:password userId:result];
                         }
                 });
                 
                 
             }
                failure:^(NSString *responseString, NSError *error) {
                    
#warning 调试的时候要在这里显示错误信息，用AlertView
             }];

}

/**
 *  初始化注册按钮
 */
- (void)setupSignUpBtn
{
    UIButton *btn = [[UIButton alloc] init];
    self.signupBtn = btn;
    [self.view addSubview:btn];
    
    [btn setTitle:LOGIN_VIEW_CONTROLLER_SIGNUP /*@"注册"*/ forState:UIControlStateNormal];
    [btn setTitle:LOGIN_VIEW_CONTROLLER_SIGNUP /*@"注册"*/ forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    
    //http://blog.it985.com/11543.html
    [btn addTarget:self action:@selector(signupBtnDown:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(signupBtnCancel:) forControlEvents:UIControlEventTouchDragExit];
    [btn addTarget:self action:@selector(signupBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn setTitleColor:ZHColor(10, 96, 255) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    //http://blog.csdn.net/xiaoxuan415315/article/details/7787683
    
    [btn.layer setCornerRadius:3.0]; //设置矩形四个圆角半径
    
    [btn.layer setBorderWidth:1.0]; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 10/255.0, 96/255.0, 255/255.0, 1 });
    [btn.layer setBorderColor:colorref];//边框颜色
    
    CGFloat height = self.view.frame.size.height;
    
    CGFloat marginBottom = 20;
    CGFloat btnW = 120;
    CGFloat btnH = 30;
    CGFloat btnX = self.view.center.x - btnW * 0.5;
    CGFloat btnY = height - marginBottom - btnH;
    
    btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    
}
#pragma mark - 按钮事件
/**
 *  按钮按下
 */
- (void)signupBtnDown:(UIButton *)btn
{
    btn.backgroundColor = ZHColor(10, 96, 255);
    [btn.layer setBorderWidth:0.0];
}
/**
 *  取消
 */
- (void)signupBtnCancel:(UIButton *)btn
{
    NSLog(@"Cancel");
    btn.backgroundColor = [UIColor clearColor];
    [btn.layer setBorderWidth:1.0];
}
/**
 *  按钮抬起
 */
- (void)signupBtnClick:(UIButton *)btn
{
    [self signupBtnCancel:btn];
    
    NSLog(@"注册");
    
    //跳转到注册页面
    ZHSignupViewController *suvc = [[ZHSignupViewController alloc] init];
    suvc.delegate = self;
    [self.navigationController pushViewController:suvc animated:YES];
}

/**
 *  登录成功
 */
- (void)accountOKWithUsername:(NSString *)username password:(NSString *)password userId:(NSInteger)uid
{
    __weak typeof(self) weakSelf = self;
    
    void (^delegateImOK)() = ^{
        //03.告诉代理我完事儿了
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([weakSelf.delegate respondsToSelector:@selector(loginViewControllerDidSuccess:)]) {
                [weakSelf.delegate loginViewControllerDidSuccess:weakSelf];
            }
        });

    };
    
    if ([ZHUserTool isUserExists]) { //若用户已登录直接返回，不用发请求
        delegateImOK();
        return;
    }
    
    //01.保存用户名和密码
    [ZHUserTool saveUser:[ZHUser userWithUsername:username password:password uid:uid]];
    
    //02.从服务器下载数据
    //[MBProgressHUD showMessage:@""];

    
    NSMutableDictionary *params = [@{} mutableCopy];
    
    params[@"uid"] = @(uid);
    
    [ZHNetwork get:[NSString stringWithFormat:@"%@/%@",ROOT ,@"download.php"]
           message:nil
compoundResponseSerialize:NO
        parameters:params
           success:^(NSString *responseString, id responseObject) {
               
               //合并数据
               NSArray *notes = (NSArray *)responseObject;
               if (notes && notes.count > 0) [ZHSynchronizeTool mergeFromServer:notes]; //有记录才同步
               
               delegateImOK();
           }
           failure:^(NSString *responseString, NSError *error) {
               delegateImOK();
           }];

}
#pragma mark - ZHSignupViewController Delegate

- (void)signupViewController:(ZHSignupViewController *)suvc didSuccessWithUsername:(NSString *)username password:(NSString *)password
{
    //更新视图
    
    [self.loginView setUsername:username password:password];
    
    //将注册页面弹出
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)dealloc
{
    NSLog(@"%@ dealloc",[self class]);
}

@end
