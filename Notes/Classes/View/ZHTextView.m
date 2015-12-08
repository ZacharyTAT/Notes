//
//  ZHTextView.m
//  Notes
//
//  Created by apple on 12/6/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//  自定义的文本框，顶部添加显示时间的标签

#import "ZHTextView.h"

#define kmodifydateLblH 15
#define kmodifydateLblFont 13.0


@implementation ZHTextView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
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
        
        [self setupModifydateLbl];
        
    }
    return self;
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







