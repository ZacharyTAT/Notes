//
//  ZHLabelCell.m
//  Notes
//
//  Created by apple on 3/26/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "ZHLabelCell.h"

@interface ZHLabelCell()

@end

@implementation ZHLabelCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    //添加标签
    ZHLabel *label = [[ZHLabel alloc] init];
    self.label = label;
    [self.contentView addSubview:label];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

+ (instancetype)labelCellWithTableView:(UITableView *)tableView
{
    NSString static *labelCellID = @"LABELCELLID";
    
    ZHLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:labelCellID];
    
    if (cell == nil) {
        cell = [[ZHLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:labelCellID];
    }
    
    return cell;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat contentHeight = self.contentView.frame.size.height;
    CGFloat contentWidth = self.contentView.frame.size.width;
    
    CGFloat lblW = 100;
    CGFloat lblX = contentWidth - lblW;
    CGFloat lblY = 0;
    CGFloat lblH = contentHeight;
    
    self.label.frame = CGRectMake(lblX, lblY, lblW, lblH);
}

@end
