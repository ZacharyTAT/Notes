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
+ (NSMutableArray *)noteListIfStick:(BOOL)stick;

/**
 *  获取对应Id记录的下一条记录
 *
 *  @param stick  此下一条记录是否是置顶的
 */
+ (ZHNote *)nextNoteForNoteId:(NSInteger)noteId stick:(BOOL)stick;

#pragma mark - Update
/**
 *  交换两个模型，以id为参考，交换其他内容
 *
 *  @return YES\成功 NO\失败
 */
+ (BOOL)exchangeNote:(ZHNote *)note withNote:(ZHNote *)anotherNote;

/**
 *  置顶\取消置顶对应Id项
 *
 *  @param stick  YES\置顶 NO\取消置顶
 */
+ (BOOL)stickNoteIfStick:(BOOL)stick forId:(NSInteger)noteId;


@end





