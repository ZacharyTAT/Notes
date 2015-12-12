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

#pragma mark - 转为在cell上展示的日期字符串
/**
 *  转为在cell上展示的日期字符串
 *
 *  1.若距当前日期小于24小时，则只展示时分
 *  2.若超过一天，但是在三天之内，则只显示昨天或者前天
 *  3.若超过三天而小于一周，则只显示星期几
 *  4.否则，显示年月日
 */
- (NSString *)toDisplayString
{
    if ([NSDate isDate:self sameDayAsDate:[NSDate date]]) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *cmpt = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:self];
        return [NSString stringWithFormat:@"%02d:%02d",[cmpt hour],[cmpt minute]];
    }//今天
    
    if ([NSDate isYesterday:self]) {
        return @"昨天";
    }//昨天
    
    if ([NSDate isTheDayBeforeYesterday:self]) {
        return @"前天";
    }//前天
    
    if ([NSDate isDate:self sameDayAsDate:[[NSDate date] dateByAddingTimeInterval:(-7 * 24 * 60 * 60)]]) {
        return [NSDate weekdayStringFromDate:self];
    }//一个星期之内
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *cmpt = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:self];
    return [NSString stringWithFormat:@"%d-%d-%d",[cmpt year] % 100,[cmpt month],[cmpt day]];
}


/**
 *  计算两日期相差的天数
 */
+ (NSInteger)daysBetweenDate:(NSDate *)fromDateTime andDate:(NSDate *)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

/**
 *  传入指定日期，返回星期几
 */
+ (NSString*)weekdayStringFromDate:(NSDate*)date {
    
    NSArray *weekdays = @[[NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
    
    //    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    calendar.timeZone = [NSTimeZone localTimeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

/**
 *  计算一个月的天数
 *
 *  @param date 日期
 */
+ (NSInteger)daysInMonth:(NSDate *)date {
    return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay
                                              inUnit:NSCalendarUnitMonth
                                             forDate:date].length;
}

/**
 *  对比两个日期的年月日是否相同
 */
+(BOOL)isDate:(NSDate*)date1 sameDayAsDate:(NSDate*)date2 {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

/**
 *  判断某一日期相对现在是否为明天
 */
+ (BOOL)isTomorrow:(NSDate *)date
{
    return [self isDate:date sameDayAsDate:[[NSDate date] dateByAddingTimeInterval:60 * 60 * 24]];
}

/**
 *  判断某一日期相对现在是否为昨天
 */
+ (BOOL)isYesterday:(NSDate *)date
{
    return [self isDate:date sameDayAsDate:[[NSDate date] dateByAddingTimeInterval:60 * 60 * 24 * (-1)]];
}

/**
 *  判断某一日期相对现在是否为后天
 */
+ (BOOL)isTheDayAfterTomorrow:(NSDate *)date
{
    return [self isDate:date sameDayAsDate:[[NSDate date] dateByAddingTimeInterval:60 * 60 * 24 * 2]];
}

/**
 *  判断某一日期相对现在是否为前天
 */
+ (BOOL)isTheDayBeforeYesterday:(NSDate *)date
{
    return [self isDate:date sameDayAsDate:[[NSDate date] dateByAddingTimeInterval:60 * 60 * 24 * -2]];
}
@end





