//
//  ZHScanEditViewController.m
//  Notes
//
//  Created by apple on 12/6/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//  此控制器用于笔记的查看和编辑，它同样适用于新建笔记控制器

#import "ZHScanEditViewController.h"
#import <objc/message.h>

#import "ZHTextView.h"
#import "ZHBottomBar.h"
#import "ZHNote.h"

#import "NSDate+ZH.h"
#import "NSString+ZH.h"
#import "ZHKeyboardJudge.h"
#import "ZHDataUtil.h"

@interface ZHScanEditViewController ()<UITextViewDelegate,UIActionSheetDelegate,ZHBottomBarDelegate>

/** 展示笔记内容的文本框 */
@property (nonatomic, weak) ZHTextView *textView;

/** 底部工具条 */
@property (nonatomic, weak) ZHBottomBar *bottomBar;

/** 记录文本是否修改过 */
@property (nonatomic, assign,getter = isTextViewChanged)BOOL textViewChanged;

/** 记录最新的一条笔记记录 */
@property(nonatomic, strong)ZHNote *latestNote;


@end

@implementation ZHScanEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textViewChanged = NO;
    [self setupLeftNavItem];
    [self setupSubViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"%@",self.note);
    //文字
    self.textView.text = self.note.content;
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

#pragma mark - 初始化左边返回按钮
/**
 *  初始化左边返回按钮
 */
- (void)setupLeftNavItem
{
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:0 target:self action:@selector(backBtnClick)];
}

#pragma mark - 初始化所有子视图
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
    //设置代理
    bottomBar.delegate = self;
    
}

#pragma mark - 完成按钮点击事件
- (void)doneBtnClick
{
    NSLog(@"done clicked...");
    NSLog(@"%@",self.textView.text);
    //还原textView的frame
    self.textView.frame = self.view.bounds;
    
    if (!self.isTextViewChanged) {
        
        //01.退出键盘
        [self.view endEditing:YES];
        
        //02.去掉完成编辑按钮
        self.navigationItem.rightBarButtonItem = nil;
        
        return;
    }
    
    
    //截取第一行有效字符为title
    NSString *title = [NSString TitleWithString:self.textView.text];
    if (title == nil) { // 没有有效字符
        /*
         *  若进行了保存，后清空了内容后，则保存了的模型也要从磁盘上删掉
         */
        [ZHDataUtil removeNote:self.latestNote];
        [ZHDataUtil removeNote:self.note];  //这里可能会多删一次，不过不要紧，删除方法里面已经做过判断
        
        //通知代理
        if ([self.delegate respondsToSelector:@selector(scanEditViewController:didClickBackBtnWithNote:lastestNote:)]) {
            self.latestNote = nil;
            [self.delegate scanEditViewController:self didClickBackBtnWithNote:self.note lastestNote:self.latestNote];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }

    //编辑内容有效，更新视图
    
    //更新状态
    self.textViewChanged = NO;
    
    //01.退出键盘
    [self.view endEditing:YES];
    
    
    //02.去掉完成编辑按钮
    self.navigationItem.rightBarButtonItem = nil;
    
    //03.更新顶部的时间标签
    self.textView.modifydateLbl.text = [[NSDate date] toLocaleString];
    
    //保存
    [self saveWithTitle:title];
    //通知代理
    if ([self.delegate respondsToSelector:@selector(scanEditViewController:didClickBackBtnWithNote:lastestNote:)]) {
        [self.delegate scanEditViewController:self didClickBackBtnWithNote:self.note lastestNote:self.latestNote];
        self.note = self.latestNote;
    }
}

#pragma mark - 返回按钮点击事件
- (void)backBtnClick
{
    NSLog(@"back button clicked...");
    
    if (!self.textViewChanged) { //没有更改文本,则直接返回
        NSLog(@"文本没有改变...");
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    NSLog(@"text changed...");
    
    //执行完成按钮的操作，这其中会更新lastest属性
    if ([[ZHKeyboardJudge judgeInstance] keyboardOpened]) { //键盘打开了，才要模拟完成按钮
        [self doneBtnClick];
    }
    
    
    //返回到上层
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 保存数据
/**
 *  保存数据
 */
- (void)saveWithTitle:(NSString *)title
{
    //先删除之前的记录
    if (self.latestNote == nil) { //删除self.note
        [ZHDataUtil removeNote:self.note];
    }else{ //删除self.latestNote
        [ZHDataUtil removeNote:self.latestNote];
    }
    
    //00.建立note模型
    ZHNote *note = [[ZHNote alloc] initWithTitle:title modifydate:[NSDate date] content:self.textView.text];
    
    //01.保存到note属性中以备后用
    self.latestNote = note;
    
    //02.保存到磁盘
    [ZHDataUtil saveWithNote:note];
}

#pragma mark - UItextView delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:0 target:self action:@selector(doneBtnClick)];
    CGFloat keyboardHeight = [[ZHKeyboardJudge judgeInstance] keyboardheight];
    CGRect frame = textView.frame;
    NSLog(@"%@",NSStringFromCGRect(frame));
    frame.size.height -= keyboardHeight + 10;
    textView.frame = frame;
    NSLog(@"%@",NSStringFromCGRect(frame));
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.textViewChanged = YES;
}

#pragma mark - BottomBar Delegate
- (void)bottomBar:(ZHBottomBar *)bottomBar didClickItem:(UIBarButtonItem *)barItem
{
    switch (barItem.tag) {
        case ZHBarItemShare: //分享按钮
            
            break;
        case ZHBarItemDelete:   //删除按钮
            [self deleteItemHandler];
            break;
        case ZHBarItemCreate:   //新建按钮
            [self createItemHandler];
            break;
            
        default:
            break;
    }
}

#pragma mark - 删除按钮的处理事件
- (void)deleteItemHandler
{
    [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除笔记" otherButtonTitles:nil, nil] showInView:self.view];
}

#pragma mark - 新建按钮的处理事件
- (void)createItemHandler
{
    UINavigationController *nav = self.navigationController;
    
    //01.销毁当前控制器
    [self.navigationController popViewControllerAnimated:NO];
    
    //02.压入新建控制器
    objc_msgSend(nav.topViewController, @selector(newBtnWithAnimated:),NO);
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) {//删除笔记
        self.textView.text = @"";
        self.textViewChanged = YES;
        [self doneBtnClick];
    }
}

- (void)dealloc
{
    NSLog(@"%@ dealloc...",[self class]);
}


@end





