//
//  ZHHierarchy+ZHViewHierarchy.h
//  Hierarchy
//
//  Created by apple on 12/13/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import "ZHHierarchy.h"

@interface ZHHierarchy (ZHViewHierarchy)

/**
 *  将传入的view的层次结构保存在一个名为data.xml
 */
+ (void)processWithView:(UIView *)view;

/**
 *  将传入的view的层次结构保存在一个xml文件中
 *  @param fileName 保存的文件名，不是文件路径，只是文件名,另外不需要写".xml"
 */
+ (void)processWithView:(UIView *)view inFile:(NSString *)fileName;
@end
