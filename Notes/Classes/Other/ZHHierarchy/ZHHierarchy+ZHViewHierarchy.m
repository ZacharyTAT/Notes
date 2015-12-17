//
//  ZHHierarchy+ZHViewHierarchy.m
//  Hierarchy
//
//  Created by apple on 12/13/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import "ZHHierarchy+ZHViewHierarchy.h"

@implementation ZHHierarchy (ZHViewHierarchy)

+ (void)processWithView:(UIView *)view
{
    NSString *fileStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>%@",[self subViewsInView:view]];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *filePath = [docPath stringByAppendingPathComponent:@"data.xml"];
    NSLog(@"%@",filePath);
    [fileStr writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

/**
 *  将子控件的层次关系以xml形式拼接
 *
 *  @return xml字符串
 */
+ (NSString *)subViewsInView:(UIView *)view
{
    NSString *className = NSStringFromClass([view class]);
    NSMutableString *str = [NSMutableString stringWithFormat:@"<%@",className];
    
    NSArray *supers = [self superClassesInClass:[view class] unitlClass:[UIView class]];
    for (int i = 0; i < supers.count; i++) {
        [str appendFormat:@" superclass%d=\"%@\"",(i+1),supers[i]];
    }
    [str appendString:@" >"];
    
    for (UIView *subView in view.subviews) {
        [str appendString:[self subViewsInView:subView]];
    }
    
    [str appendString:[NSString stringWithFormat:@"</%@>",className]];
    
    return str;
}

@end
