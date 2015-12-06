//
//  ZHTextView.m
//  Notes
//
//  Created by apple on 12/6/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//  自定义的文本框，顶部添加显示时间的标签

#import "ZHTextView.h"

#define kmodifydateLblH 15

@interface ZHTextView()

/** 显示本笔记的修改时间 */
@property(nonatomic,weak)UILabel *modifydateLbl;

@end

@implementation ZHTextView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.font = [UIFont systemFontOfSize:18.0];
        self.alwaysBounceVertical = YES;
        self.contentInset = UIEdgeInsetsMake(kmodifydateLblH, 0, 100, 0);
        self.contentOffset = CGPointMake(0, kmodifydateLblH * (-1) );
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
    modifydataLbl.font = [UIFont systemFontOfSize:15.0];
    
    //02.字体颜色
    modifydataLbl.textColor = [UIColor lightGrayColor];
    
    //03.居中对齐
    modifydataLbl.textAlignment = NSTextAlignmentCenter;
    
    //用于测试
    modifydataLbl.text = @"xxxxxxxxxx";
    
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







