//
//  ZHLocker.m
//  Notes
//
//  Created by apple on 3/26/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//  

#import "ZHLocker.h"
#import "ZHNavigationController.h"

@implementation ZHLocker

+ (void)verifyInViewControlloer:(UIViewController *)aVC completionHandler:(ZHUnLockerCompletionHander)completionHander
{
    ZHUnLockerViewController *ulvc = [[ZHUnLockerViewController alloc] init];
    ulvc.title = @"请输入解锁手势";
    
    ulvc.completionHander = completionHander;
    
    [aVC presentViewController:[[ZHNavigationController alloc] initWithRootViewController:ulvc] animated:YES completion:NULL];
}

@end
