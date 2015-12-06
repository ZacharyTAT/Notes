//
//  ZHDetailViewController.m
//  Notes
//
//  Created by apple on 12/4/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//  查看具体笔记内容控制器

#import "ZHDetailViewController.h"

#import "ZHTextView.h"
#import "ZHBottomBar.h"
#import "ZHNote.h"
#import "NSDate+ZH.h"

@interface ZHDetailViewController () <UITextViewDelegate>

/** 展示笔记内容的文本框 */
@property (nonatomic, weak) ZHTextView *textView;

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
    
    NSLog(@"%@",self.note);
    //文字
//    self.textView.text = self.note.content;
    //日期
    self.textView.modifydateLbl.text = [self.note.modifydate toLocaleString];
#warning label文字与正文间距相差有点大
    
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
    ZHTextView *textView = [[ZHTextView alloc] init];
    self.textView = textView;
    textView.frame = self.view.bounds;
    NSLog(@"%@",NSStringFromCGRect(textView.frame));
    [self.view addSubview:textView];
    //设置代理
    textView.delegate = self;
    
    // 02.添加底部工具栏
    ZHBottomBar *bottomBar = [ZHBottomBar bottomBar];
    self.bottomBar = bottomBar;
    [self.view addSubview:bottomBar];
    
}

#pragma mark - 完成按钮点击事件
/**
 *  完成按钮点击事件
 */
- (void)doneBtnClick
{
    NSLog(@"done clicked...");
    NSLog(@"%@",self.textView.text);
    [self.view endEditing:YES];
    self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - UItextView delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBtnClick)];
}

- (void)dealloc
{
    NSLog(@"detail view controller dealloc...");
}

@end







