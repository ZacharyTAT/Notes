//
//  ZHCircleView.m
//  手势解锁
//
//  Created by apple on 3/25/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "ZHCircleView.h"

@implementation ZHCircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    //不能点击
    self.userInteractionEnabled = NO;
    
    //正常图片
    [self setBackgroundImage:[UIImage imageNamed:@"lock_btn_none"] forState:UIControlStateNormal];
    
    //选中图片
    [self setBackgroundImage:[UIImage imageNamed:@"lock_btn_sel"] forState:UIControlStateSelected];
}

@end
