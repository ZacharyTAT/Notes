//
//  ZHSynchronizeTool.h
//  Notes
//
//  Created by apple on 4/17/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHSynchronizeTool : NSObject

/**
 *  将服务器数据与本地数据合并
 */
+ (BOOL)mergeFromServer:(NSArray *)notes;

@end
