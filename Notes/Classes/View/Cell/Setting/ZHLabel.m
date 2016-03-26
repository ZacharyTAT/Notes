//
//  ZHLabel.m
//  Notes
//
//  Created by apple on 3/26/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "ZHLabel.h"

@implementation ZHLabel

- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.font = [UIFont systemFontOfSize:15.0];
    self.textColor = [UIColor cyanColor];
//    self.backgroundColor = [UIColor redColor];
    self.textAlignment = NSTextAlignmentRight;
    
}

@end
