//
//  ZHHierarchy.m
//  Hierarchy
//
//  Created by apple on 12/13/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import "ZHHierarchy.h"

@implementation ZHHierarchy

/**
 *  获取一个类的各个父类
 *
 *  @param class      需要研究的类
 *  @param untilClass 直到某个类为止,若父类结构中不存在这个类，则默认到NSObject
 *
 *  @return 该数组中存的对象都是Class类型
 */
+ (NSArray *)superClassesInClass:(Class)class unitlClass:(Class)untilClass
{
    id instance = [[class alloc] init];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    while (![instance isMemberOfClass:untilClass] && ![instance isMemberOfClass:[NSObject class]]) {
        
        Class superClass = [class superclass];
        [arr addObject:superClass];
        class = superClass;
        instance = [[superClass alloc] init];
        
    }
    
    return arr;
    
}
/**
 *  获取一个类的全部类
 */
+ (NSArray *)superClassesInClass:(Class)aClass
{
    return [self superClassesInClass:aClass unitlClass:[NSObject class]];
}

@end








