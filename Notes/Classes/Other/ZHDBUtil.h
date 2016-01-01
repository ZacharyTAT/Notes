//
//  DBUtil.h
//  FMDB复习
//
//  Created by apple on 12/19/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//  数据库相关，不涉及具体表

#import <Foundation/Foundation.h>

@class ZHNote;

@interface ZHDBUtil : NSObject

/**
 *  创建一个数据表
 *
 *  @param tableName 表的名称
 *
 *  @return YES\成功,NO\失败
 */
- (BOOL)createTableWithName:(NSString *)tableName;

#pragma mark - Insertion

/**
 *  插入一条数据
 */
- (BOOL)insertWithNote:(ZHNote *)note;

#pragma mark - Query

/**
 *  通过id查询一条记录
 */
- (ZHNote *)noteForId:(NSInteger)noteId;

/**
 *  通过修改日期查询一条记录,此时的ZHNote有id
 */
- (ZHNote *)noteForModifyDate:(NSDate *)modifyDate;

/**
 *  通过修改日期获取笔记id，返回值为-1，则代表获取失败
 */
- (NSInteger)noteIdForModifyDate:(NSDate *)modifyDate;

/**
 *  按照id降序返回笔记列表
 *
 *  @param stick YES\返回置顶列表,NO\返回普通列表
 */
- (NSMutableArray *)noteListIfStick:(BOOL)stick;

/**
 *  执行sql查询，返回结果集
 */
- (NSMutableArray *)queryWithSql:(NSString *)sql;

#pragma mark - delete

/**
 *  通过id删除一条记录
 */
- (BOOL)deleteNoteForId:(NSInteger)noteId;

/**
 *  通过修改日期删除笔记
 */
- (BOOL)deleteNoteForModifyDate:(NSDate *)modifyDate;


#pragma mark - Update
/**
 *  通过id修改记录的所有其他值
 */
- (BOOL)updateWithNote:(ZHNote *)updatedNote ForId:(NSInteger)noteId;


@end


