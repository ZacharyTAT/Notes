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
#import "AFNetworking.h"

@interface ZHLoginViewController ()<ZHLoginViewDelegate,ZHSignupViewControllerDelegate>

@property (nonatomic, weak)ZHLoginView *loginView;

@end

@implementation ZHLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"登录";
    
    [self setup];
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
    [MBProgressHUD showMessage:@"正在验证"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //发请求给服务器
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        //http://www.bubuko.com/infodetail-189698.html
        
        manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        params[@"username"] = username;
        params[@"password"] = password;
        
        [manager POST:[NSString stringWithFormat:@"%@/%@",ROOT,@"login.php"]
           parameters:params
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  [MBProgressHUD hideHUD];
                  NSLog(@"success = %@",operation.responseString);
                  
                  NSInteger result = [operation.responseString intValue];
                  
                  if (result == -1) {
                      [MBProgressHUD showError:@"用户名不存在"];
                  }else if (result == 0) {
                      [MBProgressHUD showError:@"密码错误"];
                  }else{
                      [MBProgressHUD showSuccess:@"登录成功"];
                      
                      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                          //返回上一页面
                          NSLog(@"登录成功");
                      });
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"error = %@",error);
                  //调试的时候要在这里显示错误信息，用AlertView
                  [MBProgressHUD hideHUD];
              }];
    });

}

/**
 *  初始化注册按钮
 */
- (void)setupSignUpBtn
{
    UIButton *btn = [[UIButton alloc] init];
    [self.view addSubview:btn];
    
    [btn setTitle:@"注册" forState:UIControlStateNormal];
    [btn setTitle:@"注册" forState:UIControlStateHighlighted];
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

#pragma mark - ZHSignupViewController Delegate


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)dealloc
{
    NSLog(@"%@ dealloc",[self class]);
}

@end
