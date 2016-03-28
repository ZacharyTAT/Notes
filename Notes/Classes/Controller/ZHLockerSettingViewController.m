//
//  ZHLockerSettingViewController.m
//  Notes
//
//  Created by apple on 3/28/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "ZHLockerSettingViewController.h"

#import "ZHLockerView.h"

@interface ZHLockerSettingViewController ()<ZHLockerViewDelegate>

/** 提示标签 */
@property (nonatomic, weak)UILabel *tipLbl;

@end

@implementation ZHLockerSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"设置手势密码";
    [self setup];
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
    self.tipLbl = lbl;
    lbl.frame = CGRectMake(0, 100, self.view.frame.size.width, 30);
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont systemFontOfSize:15.0];
    lbl.text = @"请绘制手势密码";
    [self.view addSubview:lbl];
}

#pragma mark - ZHLockerView Delegate

- (BOOL)lockerView:(ZHLockerView *)lockerView isPswdOK:(NSString *)password
{
    return YES;
}

@end
