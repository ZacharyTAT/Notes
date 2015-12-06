//
//  ZHNewViewController.m
//  Notes
//
//  Created by apple on 12/6/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//  新建笔记控制器

#import "ZHNewViewController.h"

#import "ZHTextView.h"

@interface ZHNewViewController ()

@end

@implementation ZHNewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //由于textView是父类私有属性，不能直接访问，应使用KVC
    ZHTextView *text = [super valueForKey:@"_textView"];
    
    [text becomeFirstResponder];
}



@end
