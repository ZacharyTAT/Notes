//
//  ZHUnLockerViewController.m
//  Notes
//
//  Created by apple on 3/21/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "ZHUnLockerViewController.h"

#import "ZHLockerView.h"
#import "ZHTipLabel.h"

#import "ZHUserTool.h"

@interface ZHUnLockerViewController ()<ZHLockerViewDelegate>

/** 错误提示文字标签 */
@property (nonatomic, weak)ZHTipLabel *resultLbl;

/** 忘记按钮 */
@property (nonatomic, weak)UIButton *forgetBtn;

@end

@implementation ZHUnLockerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self test];
    [self setup];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:0 target:self action:@selector(cancel)];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //显示提示文字
    [self.resultLbl showNormalTip:self.tip];
    
    //登录了才显示 忘记手势 按钮
    self.forgetBtn.hidden = ![ZHUserTool isUserExists];
}
- (void)test
{
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *success = [[UIButton alloc] init];
    success.backgroundColor = [UIColor greenColor];
    [success setTitle:@"成功" forState:UIControlStateNormal];
    [success addTarget:self action:@selector(success) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:success];
    //    success.center = CGPointMake(100, 100);
    success.frame = CGRectMake(100, 100, 50, 50);
    
    UIButton *fail = [[UIButton alloc] init];
    fail.backgroundColor = [UIColor redColor];
    [fail setTitle:@"失败" forState:UIControlStateNormal];
    [fail addTarget:self action:@selector(fail) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fail];
    //    fail.center = CGPointMake(100, 200);
    fail.frame = CGRectMake(100, 200, 50, 50);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:0 target:self action:@selector(cancel)];
}

/**
 *  存储的正确密码
 */
- (NSString *)correctPswd
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kPasswordKey];
}

- (void)setup
{
    //01.背景
    [self setupBackGroundView];
    
    //02.lockerView
    [self setupLockerView];
    
    //03.提示文字
    [self setupResultLbl];
    
    //04.忘记手势按钮
    [self setupForgetBtn];
}


#pragma mark - 初始化背景视图
/**
 *  初始化背景视图
 */
- (void)setupBackGroundView
{
    self.view.backgroundColor = ZHColor(233, 233, 233);
}

#pragma mark - 初始化手势解锁视图
/**
 *  初始化手势解锁视图
 */
- (void)setupLockerView
{
    ZHLockerView *lockerView = [[ZHLockerView alloc] init];
    
    CGFloat marginBottom = 50;
    
    CGFloat lockerViewX = 20;
    CGFloat lockerViewY = 150;
    CGFloat lockerViewW = self.view.frame.size.width - lockerViewX * 2;
    CGFloat lockerViewH = self.view.frame.size.height - lockerViewY - marginBottom;
    
    lockerView.frame = CGRectMake(lockerViewX, lockerViewY, lockerViewW, lockerViewH);
    
    [self.view addSubview:lockerView];
    
    lockerView.delegate = self;
}

#pragma mark - 初始化密码错误提示标签
/**
 *  初始化密码错误提示标签
 */
- (void)setupResultLbl
{
    ZHTipLabel *lbl = [[ZHTipLabel alloc] init];
    self.resultLbl = lbl;
    lbl.frame = CGRectMake(0, 100, self.view.frame.size.width, 30);
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:lbl];
}

/**
 *  忘记手势按钮
 */
- (void)setupForgetBtn
{
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
//    forgetBtn.backgroundColor = [UIColor redColor];
    
    self.forgetBtn = forgetBtn;
    
    [self.view addSubview:forgetBtn];
    
    [forgetBtn setTitle:@"忘记手势？" forState:UIControlStateNormal];
    
    [forgetBtn addTarget:self action:@selector(forget) forControlEvents:UIControlEventTouchUpInside];
    
    forgetBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    
    [forgetBtn setTitleColor:ZHColor(10, 95, 255) forState:UIControlStateNormal];
    
    CGFloat marginBottom = 10;
    
    //样式
    CGFloat forgetBtnX = 80;
    CGFloat forgetBtnW = self.view.frame.size.width - 2 * forgetBtnX;
    CGFloat forgetBtnH = 20;
    CGFloat forgetBtnY = self.view.frame.size.height - marginBottom - forgetBtnH;
    
    forgetBtn.frame = CGRectMake(forgetBtnX, forgetBtnY, forgetBtnW, forgetBtnH);
}

- (void)forget
{
    
}

/**
 *  密码正确
 */
- (void)success
{
    NSLog(@"SUCCESS");
    if (self.completionHander) self.completionHander(self, YES);
}

/**
 *  密码错误
 */
- (void)fail
{
    NSLog(@"FAIL");
//    self.completionHander(self, NO);
    //提示文字
//    self.resultLbl.text = @"密码错误，请重新输入";
    [self.resultLbl showWarningTip:@"密码错误，请重新输入"];
}

/**
 *  点击了取消
 */
- (void)cancel
{
    NSLog(@"Cancel");
    if (self.completionHander) self.completionHander(self, NO);
}

#pragma mark - ZHLockerViewDelegate

- (BOOL)lockerView:(ZHLockerView *)lockerView isPswdOK:(NSString *)password
{
    if ([[self correctPswd] isEqualToString:password]) {
        [self success];
        return YES;
    }
    [self fail];
    return NO;
}

- (void)dealloc
{
    NSLog(@"%@ dealloc", [self class]);
}

@end
