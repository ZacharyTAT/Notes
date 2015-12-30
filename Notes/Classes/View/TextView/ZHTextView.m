//
//  ZHTextView.m
//  Notes
//
//  Created by apple on 12/6/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//  自定义的文本框，顶部添加显示时间的标签

#import "ZHTextView.h"

#import "ZHKeyboardJudge.h"

#define kmodifydateLblH 15
#define kmodifydateLblFont 13.0

@interface ZHTextView()

/** 修改frame之前的frame，用于恢复 */
@property (nonatomic,assign)CGRect originFrame;

/** 修改frame之前的contentInset，用于恢复 */
@property (nonatomic,assign)UIEdgeInsets originContentInset;

/** 判断是否可以修改frame和inset */
@property (nonatomic,assign)BOOL canChangeFrameInset;

@end

@implementation ZHTextView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //01.初始化属性
        [self setup];
        
        //02.初始化子控件
        [self setupModifydateLbl];
        
    }
    return self;
}
#pragma mark - 初始化一些属性
- (void)setup
{
    //01.字体
    self.font = [UIFont systemFontOfSize:18.0];
    
    //02.垂直方向始终可拖拽
    self.alwaysBounceVertical = YES;
    
    //03.顶部底部空白间距
    self.contentInset = UIEdgeInsetsMake(kmodifydateLblH, 0, 100, 0);
    
    //04.初始偏移
    self.contentOffset = CGPointMake(0, kmodifydateLblH * (-1) );
    
    //05.文字检测
    self.dataDetectorTypes = UIDataDetectorTypeLink | UIDataDetectorTypePhoneNumber;
    
    //06.链接文字属性,主题色，下划线
    self.linkTextAttributes = @{
                                NSForegroundColorAttributeName  :   ZHTintColor ,
                                NSUnderlineStyleAttributeName   :   @(1)
                                };
    
    //07.设置不可编辑(这样文字检测才能使用)
    self.editable = NO;
    
    //08.添加点击手势
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
    
    //09.关闭自动检查
    self.autocorrectionType = UITextAutocorrectionTypeNo;

    //10.关闭自动打开大写键
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    //11.监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    //12.默认可以修改frame和inset
    self.canChangeFrameInset = YES;
}

#pragma mark - 键盘完全弹出时触发
- (void)keyboardDidShow:(NSNotification *)notif
{
    if ([self isFirstResponder] && self.isEditable) {
        if ([self.delegate respondsToSelector:@selector(textViewDidBeginEditingAfterKeyboardTotallyShowUp:)]) {
            [self.delegate textViewDidBeginEditingAfterKeyboardTotallyShowUp:self];
        }
    }
}

#pragma mark - 点击手势，点击之后变成可点击
- (void)tap
{
    self.editable = YES;
    [self becomeFirstResponder];
    NSLog(@"%@",NSStringFromRange(self.selectedRange));
}

#pragma mark - 修改尺寸
- (void)changeFrameInset
{
    if (self.canChangeFrameInset){
        //坑啊啊啊啊啊，键盘切换一下输入法，就会发出DidShow通知
        
        //frame
        CGFloat keyboardHeight = [[ZHKeyboardJudge judgeInstance] keyboardheight];
        CGRect frame = self.frame;
        self.originFrame = self.frame;
        NSLog(@"%@",NSStringFromCGRect(frame));
        frame.size.height -= keyboardHeight + 10;
        self.frame = frame;
        NSLog(@"%@",NSStringFromCGRect(frame));
        
        //contentInset
        UIEdgeInsets inset = self.contentInset;
        self.originContentInset = self.contentInset;
        inset.bottom = 50;
        self.contentInset = inset;
        self.canChangeFrameInset = NO;
    }else{ //更新高度
        CGFloat keyboardHeight = [[ZHKeyboardJudge judgeInstance] keyboardheight];
        CGRect frame = self.originFrame;
        NSLog(@"%@",NSStringFromCGRect(frame));
        frame.size.height -= keyboardHeight + 10;
        self.frame = frame;
        NSLog(@"%@",NSStringFromCGRect(frame));
    }
}

#pragma mark - 恢复尺寸
- (void)resetFrameInset
{
    if (self.canChangeFrameInset){
    
    }else {
        //变成不可编辑
        self.editable = NO;
        
        //还原frame(self.originFrame非空且不为0)
        if (!CGRectIsEmpty(self.originFrame) && !CGRectEqualToRect(self.originFrame, CGRectZero)) self.frame = self.originFrame;
        
        NSLog(@"frame = %@,originFrame = %@",NSStringFromCGRect(self.frame),NSStringFromCGRect(self.originFrame));
        
        //还原contentInset
        if (!UIEdgeInsetsEqualToEdgeInsets(self.originContentInset, UIEdgeInsetsZero)) self.contentInset = self.originContentInset;
        
        NSLog(@"contentInset = %@,originContentInset = %@",NSStringFromUIEdgeInsets(self.contentInset),NSStringFromUIEdgeInsets(self.originContentInset));
        
        self.canChangeFrameInset = YES;
    }
}
#pragma mark - 添加显示时间标签控件
/**
 *  添加显示时间标签控件
 */
- (void)setupModifydateLbl
{
    UILabel *modifydataLbl = [[UILabel alloc] init];
    self.modifydateLbl = modifydataLbl;
    
    //设置标签属性(字体)
    
    //01.字体大小
    modifydataLbl.font = [UIFont systemFontOfSize:kmodifydateLblFont];
    
    //02.字体颜色
    modifydataLbl.textColor = [UIColor lightGrayColor];
    
    //03.居中对齐
    modifydataLbl.textAlignment = NSTextAlignmentCenter;
    
    //用于测试
    //modifydataLbl.text = @"13540359524";
    
    [self addSubview:modifydataLbl];
}

#pragma mark - layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width;
    
    //显示时间的标签放在最顶部
    CGFloat modifydateLblX = 0;
    CGFloat modifydateLblH = kmodifydateLblH;
    CGFloat modifydateLblY = modifydateLblH * (-1);
    CGFloat modifydateLblW = width;
    
    self.modifydateLbl.frame = CGRectMake(modifydateLblX, modifydateLblY, modifydateLblW, modifydateLblH);
    
}

#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%@ dealloc...",[self class]);
    //移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end







