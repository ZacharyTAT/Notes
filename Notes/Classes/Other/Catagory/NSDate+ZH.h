//
//  NSDate+ZH.h
//  Notes
//
//  Created by apple on 12/6/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ZH)

/**
 *  将日期转为本地化字符串
 */
- (NSString *)toLocaleString;

/**
 *  转为在cell上展示的日期字符串<br/>
 *
 *  1.若距当前日期小于24小时，则只展示时分<br/>
 *  2.若超过一天，但是在三天之内，则只显示昨天或者前天<br/>
 *  3.若超过三天而小于一周，则只显示星期几<br/>
 *  4.否则，显示年月日<br/>
 */
- (NSString *)toDisplayString;



@end
