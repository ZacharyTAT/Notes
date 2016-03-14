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

@end

@implementation ZHNewViewController



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //上一页不能用
    self.bottomBar.prePageItem.enabled = NO;
    
    self.textView.editable = YES;
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
    
    //04.禁用"上一页"
    self.bottomBar.prePageItem.enabled = NO;
    
    if (self.latestNote) { //若之前存了，还要先删掉
        if ([self.delegate respondsToSelector:@selector(newViewController:didClickDeleteItemWithLatestNote:)]) {
            [self.delegate newViewController:self didClickDeleteItemWithLatestNote:self.latestNote];
        }
    }
    if (title.length > 20) { //标题最多20个字符
        title = [title substringToIndex:20];
    }
    //保存
    //[self performSelector:@selector(saveWithTitle:) withObject:title];
    [self saveWithTitle:title];
 
    //通知代理
    if ([self.delegate respondsToSelector:@selector(newViewController:didClickBackBtnWithNewNote:)]) {
        [self.delegate newViewController:self didClickBackBtnWithNewNote:self.latestNote];
    }
}

@end










