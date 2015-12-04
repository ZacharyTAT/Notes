//
//  ZHDetailViewController.m
//  Notes
//
//  Created by apple on 12/4/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//  查看具体笔记内容控制器

#import "ZHDetailViewController.h"
#import "ZHBottomBar.h"

@interface ZHDetailViewController ()

/** 展示笔记内容的文本框 */
@property (nonatomic, weak) UITextView *textView;

/** 底部工具条 */
@property (nonatomic, weak) ZHBottomBar *bottomBar;

@end

@implementation ZHDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSubViews];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.textView.text = self.content;
    
    //设置textView的frame
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    CGFloat bottomBarX = 0;
    CGFloat bottomBarW = width;
    CGFloat bottomBarH = 44;
    CGFloat bottomBarY = height - bottomBarH;
    self.bottomBar.frame = CGRectMake(bottomBarX, bottomBarY, bottomBarW, bottomBarH);
}

/**
 *  初始化所有子视图
 */
- (void)setupSubViews
{
    // 01.添加文本框
    UITextView *textView = [[UITextView alloc] init];
    self.textView = textView;
    textView.frame = self.view.bounds;
    [self.view addSubview:textView];
    // 02.添加底部工具栏
    ZHBottomBar *bottomBar = [ZHBottomBar bottomBar];
//    bottomBar.backgroundColor = [UIColor redColor];
    self.bottomBar = bottomBar;
    [self.view addSubview:bottomBar];
    
}
@end







