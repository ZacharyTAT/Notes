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
    
#warning 在模拟器中没有效果，跑到真机上试试
    //06.链接文字属性
    self.linkTextAttributes = @{NSForegroundColorAttributeName : ZHTintColor};
    
    //07.设置不可编辑(这样文字检测才能使用)
    self.editable = NO;
    
    //08.添加点击手势
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
    
    //09.关闭自动检查
    self.autocorrectionType = UITextAutocorrectionTypeNo;

    //10.关闭自动打开大写键
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
}

#pragma mark - 点击手势，点击之后变成可点击
- (void)tap
{
    self.editable = YES;
    [self becomeFirstResponder];
}

#pragma mark - 修改尺寸
- (void)changeFrameInset
{
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
}

#pragma mark - 恢复尺寸
- (void)resetFrameInset
{
    //变成不可编辑
    self.editable = NO;
    
    //还原frame
    self.frame = self.originFrame;
    
    //还原contentInset
    self.contentInset = self.originContentInset;
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

@end







