//
//  ZHLoginViewController.m
//  Notes
//
//  Created by apple on 4/15/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "ZHLoginViewController.h"

#import "ZHLoginView.h"

@interface ZHLoginViewController ()<ZHLoginViewDelegate>

@property (nonatomic, weak)ZHLoginView *loginView;

@end

@implementation ZHLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setup];
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
- (void)loginViewDidLogin:(ZHLoginView *)loginView
{
    NSLog(@"login");
    //发请求给服务器
    
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
    CGFloat btnW = 150;
    CGFloat btnH = 40;
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
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
