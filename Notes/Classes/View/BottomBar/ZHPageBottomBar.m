//
//  ZHPageBottomBar.m
//  Notes
//
//  Created by apple on 12/24/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import "ZHPageBottomBar.h"


@implementation ZHPageBottomBar

- (instancetype)init
{
    if (self = [super init]) {
        [self addTitleBtnWithTitle:@"上一页" type:ZHBarItemPrePage AtIndex:1];
        [self addTitleBtnWithTitle:@"下一页" type:ZHBarItemNextPage AtIndex:3];
    }
    return self;
}


@end
