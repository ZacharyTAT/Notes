//
//  ZHScanEditViewController.m
//  Notes
//
//  Created by apple on 12/6/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//  此控制器用于笔记的查看和编辑，它同样适用于新建笔记控制器

#import "ZHScanEditViewController.h"

#import "ZHNote.h"

#import "ZHTextView.h"
#import "ZHPageBottomBar.h"

#import "NSString+ZH.h"
#import "NSDate+ZH.h"
#import "ZHDataUtil.h"
#import "ZHKeyboardJudge.h"


@interface ZHScanEditViewController ()<ZHBottomBarDelegate>

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




#pragma mark - 重写至父类的方法
- (void)setupBottomBar
{
    ZHBottomBar *bottomBar = [ZHPageBottomBar bottomBar];
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






@end





