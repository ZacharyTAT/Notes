//
//  ZHNewViewController.m
//  Notes
//
//  Created by apple on 12/6/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//  新建笔记控制器

#import "ZHNewViewController.h"

#import "ZHTextView.h"
#import "ZHBottomBar.h"
#import "ZHNote.h"

#import "NSDate+ZH.h"
#import "NSString+ZH.h"
#import "ZHKeyboardJudge.h"
#import "ZHDataUtil.h"

@interface ZHNewViewController ()


/** 展示笔记内容的文本框 */
@property (nonatomic, weak) ZHTextView *textView;

/** 底部工具条 */
@property (nonatomic, weak) ZHBottomBar *bottomBar;

/** 记录文本是否修改过 */
@property (nonatomic, assign,getter = isTextViewChanged)BOOL textViewChanged;

/** 记录最新的一条笔记记录 */
@property(nonatomic, strong)ZHNote *latestNote;

// 这两个方法的方法体在父类中，在此进行声明是为了去掉警告(没错，我就是强迫症TAT)
- (NSString *)noteTitle;
- (void)saveWithTitle:(NSString *)title;

@end

@implementation ZHNewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.textView becomeFirstResponder];
}

#pragma mark - 重写自父类的方法

#pragma mark - 完成按钮点击事件
- (void)doneBtnClick
{
    NSLog(@"%@ done clicked...",[self class]);
    NSLog(@"%@",self.textView.text);
    //还原textView的frame
    self.textView.frame = self.view.bounds;
    
    if (!self.isTextViewChanged) {
        if (self.latestNote == nil) {
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        
            return;
        }
        
        [self.view endEditing:YES];
        
        self.navigationItem.rightBarButtonItem = nil;
        
        return;
        
    } //若是新建备忘录，文本内容没有改变，则直接返回
    
    //截取第一行有效字符为title
//    NSString *title = [self performSelector:@selector(noteTitle)];
    NSString *title = [NSString TitleWithString:self.textView.text];
    if (title == nil) { // 没有有效字符
        
        //删除磁盘上保存的模型
        [ZHDataUtil removeNote:self.latestNote];
        
        //通知代理删除之前保存的模型
        if ([self.delegate respondsToSelector:@selector(newViewController:didClickDeleteItemWithLatestNote:)]) {
            [self.delegate newViewController:self didClickDeleteItemWithLatestNote:self.latestNote];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
        
    }//虽然文本内容改变，但都是空格和回车，也直接返回
    
    
    //编辑内容有效，更新视图
    self.textViewChanged = NO;

    
    //01.退出键盘
    [self.view endEditing:YES];
    
    
    //02.去掉完成编辑按钮
    self.navigationItem.rightBarButtonItem = nil;
    
    //03.更新顶部的时间标签
    self.textView.modifydateLbl.text = [[NSDate date] toLocaleString];
    
    if (self.latestNote) { //若之前存了，还要先删掉
        if ([self.delegate respondsToSelector:@selector(newViewController:didClickDeleteItemWithLatestNote:)]) {
            [self.delegate newViewController:self didClickDeleteItemWithLatestNote:self.latestNote];
        }
    }
    
    //保存
    [self performSelector:@selector(saveWithTitle:) withObject:title];
    
 
    //通知代理
    if ([self.delegate respondsToSelector:@selector(newViewController:didClickBackBtnWithNewNote:)]) {
        [self.delegate newViewController:self didClickBackBtnWithNewNote:self.latestNote];
    }
}

#pragma mark - 返回按钮点击事件
- (void)backBtnClick
{
    NSLog(@"%@ back button clicked...",[self class]);
    
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

@end










