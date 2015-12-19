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

/**
 *  插入一条数据
 */
- (BOOL)insertWithNote:(ZHNote *)note;

/**
 *  通过id查询一条记录
 */
- (void)queryNoteForId:(NSInteger)noteId;

/**
 *  通过id删除一条记录
 */
- (BOOL)deleteNoteForId:(NSInteger)noteId;

/**
 *  按照id降序返回搜索笔记列表
 */
- (NSMutableArray *)noteList;

@end


