//
//  ZHLineCell.m
//  Notes
//
//  Created by apple on 3/28/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "ZHLineCell.h"

@interface ZHLineCell()

/** 分割线 */
@property (nonatomic, weak)UIView *seperator;

@end

@implementation ZHLineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSeperator];
    }
    return self;
}

- (void)addSeperator
{
    UIView *seperator = [[UIView alloc] init];
    seperator.backgroundColor = [UIColor grayColor];
    [self addSubview:seperator];
    self.seperator = seperator;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat contentW = self.frame.size.width;
    CGFloat contentH = self.frame.size.height;
    
    CGFloat seperatorH = 1;
    CGFloat seperatorX = 0;
    CGFloat seperatorY = contentH - seperatorH;
    CGFloat seperatorW = contentW;
    
    self.seperator.frame = CGRectMake(seperatorX, seperatorY, seperatorW, seperatorH);
}

@end
