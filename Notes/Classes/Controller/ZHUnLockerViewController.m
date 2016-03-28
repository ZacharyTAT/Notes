//
//  ZHUnLockerViewController.m
//  Notes
//
//  Created by apple on 3/21/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "ZHUnLockerViewController.h"
#import "ZHLockerView.h"


@interface ZHUnLockerViewController ()<ZHLockerViewDelegate>

/** 错误提示文字标签 */
@property (nonatomic, weak)UILabel *resultLbl;

@end

@implementation ZHUnLockerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self test];
    [self setup];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:0 target:self action:@selector(cancel)];
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
 *  模拟的正确密码
 */
- (NSString *)correctPswd
{
    return @"47526";
}

- (void)setup
{
    //01.背景
    [self setupBackGroundView];
    
    //02.lockerView
    [self setupLockerView];
    
    //03.提示文字
    [self setupResultLbl];
}

/**
 *  初始化背景视图
 */
- (void)setupBackGroundView
{
    UIImageView *backView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Home_refresh_bg"]];
    
    backView.frame = self.view.bounds;
    
    [self.view addSubview:backView];
}

/**
 *  初始化手势解锁视图
 */
- (void)setupLockerView
{
    ZHLockerView *lockerView = [[ZHLockerView alloc] init];
    
    CGFloat lockerViewX = 0;
    CGFloat lockerViewY = 150;
    CGFloat lockerViewW = self.view.frame.size.width;
    CGFloat lockerViewH = self.view.frame.size.height - lockerViewY;
    
    lockerView.frame = CGRectMake(lockerViewX, lockerViewY, lockerViewW, lockerViewH);
    
    [self.view addSubview:lockerView];
    
    lockerView.delegate = self;
}

/**
 *  初始化密码错误提示标签
 */
- (void)setupResultLbl
{
    UILabel *lbl = [[UILabel alloc] init];
    self.resultLbl = lbl;
    lbl.frame = CGRectMake(0, 70, self.view.frame.size.width, 30);
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.textColor = [UIColor redColor];
    lbl.font = [UIFont systemFontOfSize:13.0];
    [self.view addSubview:lbl];
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
    self.resultLbl.text = @"密码错误，请重新输入";
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
