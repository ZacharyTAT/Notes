//
//  ZHPageBottomBar.m
//  Notes
//
//  Created by apple on 12/24/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import "ZHPageBottomBar.h"

#define PAGE_BOTTOM_BAR_ITEM_PREPAGE NSLocalizedStringFromTable(@"PAGE_BOTTOM_BAR_ITEM_PREPAGE", @"ZHPageBottomBar", @"上一页")
#define PAGE_BOTTOM_BAR_ITEM_NEXTPAGE NSLocalizedStringFromTable(@"PAGE_BOTTOM_BAR_ITEM_NEXTPAGE", @"ZHPageBottomBar", @"下一页")

@implementation ZHPageBottomBar

- (instancetype)init
{
    if (self = [super init]) {
        [self addTitleBtnWithTitle:PAGE_BOTTOM_BAR_ITEM_PREPAGE /*@"上一页"*/ type:ZHBarItemPrePage AtIndex:1];
        [self addTitleBtnWithTitle:PAGE_BOTTOM_BAR_ITEM_NEXTPAGE /*@"下一页"*/ type:ZHBarItemNextPage AtIndex:3];
    }
    return self;
}


@end
