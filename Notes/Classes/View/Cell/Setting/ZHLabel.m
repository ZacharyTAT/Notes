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
    self.font = [UIFont systemFontOfSize:16.0];
    self.textColor = ZHColor(0, 58, 180);
//    self.backgroundColor = [UIColor redColor];
    self.textAlignment = NSTextAlignmentRight;
    
}

@end
