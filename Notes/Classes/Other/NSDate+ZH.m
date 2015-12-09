//
//  NSDate+ZH.m
//  Notes
//
//  Created by apple on 12/6/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import "NSDate+ZH.h"

@implementation NSDate (ZH)

#pragma mark - 将日期转为本地化字符串
- (NSString *)toLocaleString
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *cmpt = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:self];
    return [NSString stringWithFormat:@"%d年%d月%d日 %02d:%02d",[cmpt year],[cmpt month],[cmpt day],[cmpt hour],[cmpt minute]];
}

@end
