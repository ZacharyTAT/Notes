//
//  NSString+ZH.m
//  Notes
//
//  Created by apple on 12/10/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import "NSString+ZH.h"

@implementation NSString (ZH)

#pragma mark - 获取字符串第一行有效内容(不包括空格)
+ (NSString *)TitleWithString:(NSString *)text
{
    //拷贝一份，不能破坏原文
    NSString *content = [text copy];
    
    NSString *trimedStr = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([@"" isEqualToString:trimedStr]) { //内容只有空格或回车
        return nil;
    }
    
    NSString *titleTobeTrimed = [[trimedStr componentsSeparatedByString:@"\n"] firstObject]; //到这里是第一行有效的内容，不过可能有尾部有空格，要去掉
    
    return [titleTobeTrimed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end
