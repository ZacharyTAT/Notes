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
    navBar.tintColor = ZHTintColor;
    
    //穿透效果
#warning 有时间再想办法吧
}



@end





