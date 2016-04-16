//
//  ZHSignUpTextField.m
//  Notes
//
//  Created by apple on 4/16/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "ZHSignUpTextField.h"

@implementation ZHSignUpTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupStyle];
    }
    return self;
}

- (void)setupStyle
{
    //01.左右子视图显示模式
    self.leftViewMode = UITextFieldViewModeAlways;
    self.rightViewMode = UITextFieldViewModeAlways;

    //02.字体
    self.font = [UIFont systemFontOfSize:13.0];
    
    //背景色
    self.backgroundColor = ZHColor(230, 230, 230);
}


@end
