//
//  ZHDataUtil.h
//  Notes
//
//  Created by apple on 12/9/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZHNote;

@interface ZHDataUtil : NSObject

/**
 *  删除制定note对应的磁盘数据
 *
 */
+ (void)removeNote:(ZHNote *)note;

/**
 *  将指定的note保存在磁盘上
 */
+ (void)saveWithNote:(ZHNote *)note;
@end
