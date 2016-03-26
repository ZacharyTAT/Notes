//
//  ZHSettingViewController.m
//  Notes
//
//  Created by apple on 3/26/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "ZHSettingViewController.h"

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
    [self setupView];
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

#pragma mark - 初始化视图

- (void)setupView
{
    self.view.backgroundColor = [UIColor cyanColor];
}

- (void)close
{
    NSLog(@"close");
    //通知代理
    
    if ([self.delegate respondsToSelector:@selector(settingViewControllerDidClickClose:)]) {
        [self.delegate settingViewControllerDidClickClose:self];
    }
}

- (void)dealloc
{
    NSLog(@"%@ dealloc....",[self class]);
}

@end



