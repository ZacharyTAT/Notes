//
//  ZHUnLockerViewController.m
//  Notes
//
//  Created by apple on 3/21/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "ZHUnLockerViewController.h"

@interface ZHUnLockerViewController ()

@end

@implementation ZHUnLockerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self test];
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

- (void)success
{
    NSLog(@"SUCCESS");
    self.completionHander(self, YES);
}

- (void)fail
{
    NSLog(@"FAIL");
    self.completionHander(self, NO);
}

- (void)cancel
{
    NSLog(@"Cancel");
    self.completionHander(self, NO);
}

- (void)dealloc
{
    NSLog(@"%@ dealloc", [self class]);
}

@end
