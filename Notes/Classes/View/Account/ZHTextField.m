//
//  ZHTextField.m
//  Notes
//
//  Created by apple on 4/15/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "ZHTextField.h"

@interface ZHTextField()

/** 底部分割线 */
@property (nonatomic, weak)UIView *bottomLine;

@end

@implementation ZHTextField

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
//    self.backgroundColor = [UIColor blueColor];
    self.textAlignment = NSTextAlignmentCenter;
    self.font = [UIFont systemFontOfSize:15.0];
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    self.bottomLine = bottomLine;
    [self addSubview:bottomLine];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGFloat bottomLineX = 0;
    CGFloat bottomLineH = 1;
    CGFloat bottomLineY = height - bottomLineH;
    CGFloat bottomLineW = width;
    
    self.bottomLine.frame = CGRectMake(bottomLineX, bottomLineY, bottomLineW, bottomLineH);
}

@end
