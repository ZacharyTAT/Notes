//
//  ZHHierarchy.h
//  Hierarchy
//
//  Created by apple on 12/13/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHHierarchy : NSObject
/**
 *  获取一个类的各个父类
 *
 *  @param class      需要研究的类
 *  @param untilClass 直到某个类为止,若父类结构中不存在这个类，则默认到NSObject
 *
 *  @return 该数组中存的对象都是Class类型
 */
+ (NSArray *)superClassesInClass:(Class)class unitlClass:(Class)untilClass;


/**
 *  获取一个类的全部类
 */
+ (NSArray *)superClassesInClass:(Class)aClass;
@end