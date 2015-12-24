//
//  ZHNavigationController.m
//  Notes
//
//  Created by apple on 12/1/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//  自定义的导航控制器

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
    UINavigationBar *appearance = [UINavigationBar appearance];
    
    //文字颜色
    //tintColor\barTintColor
    appearance.tintColor = ZHTintColor;
    
    //穿透效果
    //直接改navBar的backgroundColor和alpha是不行的
    //要该背景视图_UINavigationBarBackground,它是负责管理navBar的背景
    
//    [ZHHierarchy processWithView:self.navigationBar];
    UINavigationBar *navBar = self.navigationBar;
    for (UIView *subView in navBar.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
//            [subView removeFromSuperview];
            subView.backgroundColor = [UIColor whiteColor];
            subView.alpha = 0.9;
        }
    }
    
}



@end





