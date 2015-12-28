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

#pragma mark - delete

/**
 *  删除制定note对应的磁盘数据
 *
 */
+ (void)removeNote:(ZHNote *)note;

#pragma mark - Insertition

/**
 *  将指定的note保存在磁盘上
 */
+ (void)saveWithNote:(ZHNote *)note;

#pragma mark - Query

/**
 *  获取所有笔记列表
 */
+ (NSMutableArray *)noteList;


#pragma mark - Update
/**
 *  交换两个模型，以id为参考，交换其他内容
 *
 *  @return YES\成功 NO\失败
 */
+ (BOOL)exchangeNote:(ZHNote *)note withNote:(ZHNote *)anotherNote;

@end





