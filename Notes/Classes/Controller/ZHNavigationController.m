//
//  ZHNavigationController.m
//  Notes
//
//  Created by apple on 12/1/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import "ZHNavigationController.h"

@interface ZHNavigationController ()

@end

@implementation ZHNavigationController


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"navigation did load");
    [self setup];
}

/**
 *  导航控制器的初始化
 */
- (void)setup
{
    UINavigationBar * navBar = [UINavigationBar appearance];
    
    //文字颜色
    //tintColor\barTintColor
    navBar.tintColor = [UIColor colorWithRed:252/255.0 green:206/255.0 blue:37/255.0 alpha:1.0];
    
    //穿透效果
//    self.navigationBar.translucent = NO;
//    self.navigationBar.alpha = 0.5;
}



@end





