//
//  DBUtil.m
//  FMDB复习
//
//  Created by apple on 12/19/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import "ZHDBUtil.h"
#import "ZHNote.h"
#import "FMDatabase.h"

#define kNoteColumnId @"id"
#define kNoteColumnTitle @"title"
#define kNoteColumnContent @"content"
#define kNoteColumnModifyDate @"modifyDate"
#define kNoteColumnIsStick @"isStick"
#define kNoteColumnIsLock @"isLock"

@interface ZHDBUtil()

/** 数据库文件存放路径 */
@property (nonatomic,copy)NSString *dbPath;

/** 数据库实例 */
@property (nonatomic,strong)FMDatabase *DB;

@end

@implementation ZHDBUtil

#pragma mark - Properties
- (NSString *)dbPath
{
    if (_dbPath == nil) {
        
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        
        _dbPath = [docPath stringByAppendingPathComponent:@"notes.sqlite"];
        
    }
    return _dbPath;
}

- (FMDatabase *)DB
{
    if (_DB == nil) {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        if (![fileMgr fileExistsAtPath:self.dbPath]) {
            BOOL result = [fileMgr createFileAtPath:self.dbPath contents:nil attributes:nil];
            if (!result) NSLog(@"创建数据库文件失败");
            return nil;
        }
        _DB = [FMDatabase databaseWithPath:self.dbPath];
    }
    return _DB;
}

#pragma mark - 创建一个数据表
- (BOOL)createTableWithName:(NSString *)tableName
{
    if (![self tableExists:tableName]) { //不存在则创建
        if ([self.DB open]) {
            
            NSString *sql = [NSString stringWithFormat:
                             @"\
                                 CREATE TABLE %@ \
                                 (\
                                     %@ INTEGER PRIMARY key AUTOINCREMENT NOT NULL,\
                                     %@ TEXT NOT NULL,\
                                     %@ TEXT NOT NULL,\
                                     %@ timestamp NOT NULL,\
                                     %@ INTEGER default 0,\
                                     %@ INTEGER default 0 \
                                 )\
                             ",tableName,kNoteColumnId,kNoteColumnTitle,kNoteColumnContent,kNoteColumnModifyDate,kNoteColumnIsStick,kNoteColumnIsLock];
            NSLog(@"%@",sql);
            BOOL res = [self.DB executeUpdate:sql];
            [self.DB close];
            
            return res ? YES : NO ;
        }
        NSLog(@"数据库打开失败");
        return NO;
    }
    
    NSLog(@"表已存在");
    
    return YES;
}

#pragma mark - 判断表是否存在
- (BOOL)tableExists:(NSString *)tableName
{
    if ([self.DB open]) {
        FMResultSet *rs = [self.DB executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
        while ([rs next])
        {
            NSInteger count = [rs intForColumn:@"count"];
            NSLog(@"tableExists %d", count);
            
            
            [self.DB close];
            
            return (0 == count) ? NO : YES;
        }
    }
    return NO;
}

#pragma mark - 插入一条数据
- (BOOL)insertNoteWithTitle:(NSString *)title content:(NSString *)content modifyDate:(NSDate *)modifyDate stick:(BOOL)stick lock:(BOOL)lock
{
    if ([self.DB open]) {
        
//        NSString * sql = @"insert into note (title, content,modifyDate) values(?, ?, ?) ";
        NSString * sql = [NSString stringWithFormat:@"insert into note (%@, %@,%@,%@,%@) values(?, ?, ?, %d, %d) ",kNoteColumnTitle,kNoteColumnContent,kNoteColumnModifyDate,kNoteColumnIsStick,kNoteColumnIsLock, stick, lock];
        
        NSLog(@"sql = %@",sql);
        
        BOOL res = [self.DB executeUpdate:sql,title,content,modifyDate];
        [self.DB close];
        
        return res ? YES : NO;
    }
    return NO;
}
- (BOOL)insertWithNote:(ZHNote *)note
{
    return [self insertNoteWithTitle:note.title content:note.content modifyDate:note.modifydate stick:note.isStick lock:note.isLock];
}
#pragma mark - 通过id查询一条记录
- (ZHNote *)noteForId:(NSInteger)noteId
{
    if ([self.DB open]) {
        NSString * sql =[NSString stringWithFormat:@"select * from note where %@ = %d",kNoteColumnId,noteId] ;
        NSLog(@"sql = %@",sql);
        FMResultSet * rs = [self.DB executeQuery:sql];
        while ([rs next]) {
            NSString *title = [rs stringForColumn:kNoteColumnTitle];
            NSString *content = [rs stringForColumn:kNoteColumnContent];
            NSDate *modifyDate = [rs dateForColumn:kNoteColumnModifyDate];
            BOOL stick = [rs boolForColumn:kNoteColumnIsStick];
            BOOL lock = [rs boolForColumn:kNoteColumnIsLock];
            
            NSLog(@"id=%d, title=%@, content=%@, modifyDate=%@,stick=%d,lock=%d",noteId,title, content, modifyDate, stick, lock);
            
            ZHNote *note = [[ZHNote alloc] initWithTitle:title modifydate:modifyDate content:content stick:stick lock:lock];
            note.noteId = noteId;
            
            [self.DB close];
            return note;
        }
    }
    return nil;
}

#pragma mark - 通过修改日期查询一条记录
- (ZHNote *)noteForModifyDate:(NSDate *)modifyDate
{
    if ([self.DB open]) {
//        NSString * sql = @"select * from note where modifyDate = ?" ;
        NSString * sql = [NSString stringWithFormat:@"select * from note where %@ = ?",kNoteColumnModifyDate];
        NSLog(@"sql = %@",sql);
        FMResultSet * rs = [self.DB executeQuery:sql,modifyDate];
        while ([rs next]) {
            NSInteger noteId = [rs intForColumn:kNoteColumnId];
            NSString *title = [rs stringForColumn:kNoteColumnTitle];
            NSString *content = [rs stringForColumn:kNoteColumnContent];
//            NSDate *modifyDate = [rs dateForColumn:@"modifyDate"];
            BOOL stick = [rs boolForColumn:kNoteColumnIsStick];
            BOOL lock = [rs boolForColumn:kNoteColumnIsLock];
            NSLog(@"id=%d, title=%@, content=%@, modifyDate=%@",noteId,title, content, modifyDate);
            ZHNote *note = [[ZHNote alloc] initWithTitle:title modifydate:modifyDate content:content stick:stick lock:lock];
            note.noteId = noteId;
            
            [self.DB close];
            return note;
        }
    }
    return nil;
}
#pragma mark - 通过修改日期获取笔记id
- (NSInteger)noteIdForModifyDate:(NSDate *)modifyDate
{
    if ([self.DB open]) {
        NSString * sql = @"select id from note where modifyDate = ?" ;
        FMResultSet * rs = [self.DB executeQuery:sql,modifyDate];
        while ([rs next]) {
            NSInteger noteId = [rs intForColumn:@"id"];
            
            NSLog(@"id = %d",noteId);
            [self.DB close];
            
            return noteId;
        }
    }
    return -1;
}

#pragma mark - 按照id降序返回普通笔记(非置顶)列表
- (NSMutableArray *)noteListIfStick:(BOOL)stick
{
    NSString * sql = [NSString stringWithFormat:@"select * from note where %@ = %d order by %@ DESC",kNoteColumnIsStick,stick,kNoteColumnId];
    NSMutableArray *notes = [self queryWithSql:sql];
    
    NSLog(@"noteListCount : %d",notes.count);
    
    return notes;

}

- (NSMutableArray *)queryWithSql:(NSString *)sql
{
    NSMutableArray *notes = [NSMutableArray array];
    if ([self.DB open]) {
        
        NSLog(@"sql = %@",sql);
        FMResultSet * rs = [self.DB executeQuery:sql];
        while ([rs next]) {
            NSInteger noteId = [rs intForColumn:kNoteColumnId];
            NSString *title = [rs stringForColumn:kNoteColumnTitle];
            NSString *content = [rs stringForColumn:kNoteColumnContent];
            NSDate *modifyDate = [rs dateForColumn:kNoteColumnModifyDate];
            BOOL stick = [rs boolForColumn:kNoteColumnIsStick];
            BOOL lock = [rs boolForColumn:kNoteColumnIsLock];
            
            
            ZHNote *note = [ZHNote noteWithTitle:title modifydate:modifyDate content:content stick:stick lock:lock];
            note.noteId = noteId;
            [notes addObject:note];
        }
        [self.DB close];
    }
    NSLog(@"ResultSet count : %d",notes.count);
    
    return notes;
}

#pragma mark - 通过id删除一条记录
- (BOOL)deleteNoteForId:(NSInteger)noteId
{
    if ([self.DB open]) {
        
//        NSString *sql = [NSString stringWithFormat:@"delete from note where id = %d",noteId];
        NSString *sql = [NSString stringWithFormat:@"delete from note where %@ = %d",kNoteColumnId,noteId];
        BOOL res = [self.DB executeUpdate:sql];
        
        [self.DB close];
        
        return res ? YES : NO;
    }
    
    return NO;
}

#pragma mark - 删除所有笔记
- (BOOL)deleteAllNotes
{
    if ([self.DB open]) {
        
        NSString *sql = [NSString stringWithFormat:@"delete from note"];
        BOOL res = [self.DB executeUpdate:sql];
        
        [self.DB close];
        
        return res ? YES : NO;
    }
    
    return NO;
}

#pragma mark - 重新排列id
- (BOOL)reorderId
{
    if ([self.DB open]) {
        
        NSString *sql = [NSString stringWithFormat:@"UPDATE sqlite_sequence set seq = 0 where name = 'note'"];
        BOOL res = [self.DB executeUpdate:sql];
        
        [self.DB close];
        
        return res ? YES : NO;
    }
    
    return NO;
}

#pragma mark - 通过修改日期删除一条记录
- (BOOL)deleteNoteForModifyDate:(NSDate *)modifyDate
{
    if ([self.DB open]) {
        
//        NSString *sql = @"delete from note where modifyDate = ?";
        NSString *sql = [NSString stringWithFormat:@"delete from note where %@ = ?",kNoteColumnModifyDate];
        NSLog(@"sql = %@",sql);
        
        BOOL res = [self.DB executeUpdate:sql,modifyDate];
        
        [self.DB close];
        
        return res ? YES : NO;
    }
    
    return NO;
}

#pragma mark - Update

- (BOOL)updateWithNote:(ZHNote *)updatedNote ForId:(NSInteger)noteId
{
    if ([self.DB open]) {
        
        NSString *title = updatedNote.title;
        NSString *content = updatedNote.content;
        NSDate *modifyDate = updatedNote.modifydate;
        BOOL stick = updatedNote.isStick;
        BOOL lock = updatedNote.isLock;
//        NSString *sql = [NSString stringWithFormat:@"UPDATE note SET title='%@',content='%@',modifyDate=? where id = %d",title,content,noteId];
        NSString *sql = [NSString stringWithFormat:@"UPDATE note SET %@=?,%@=?,%@=?,%@=%d,%@=%d where %@ = %d",kNoteColumnTitle ,kNoteColumnContent ,kNoteColumnModifyDate ,kNoteColumnIsStick ,stick ,kNoteColumnIsLock ,lock ,kNoteColumnId ,noteId];
        NSLog(@"sql = %@",sql);
        
        BOOL res = [self.DB executeUpdate:sql,title,content,modifyDate];
        
        [self.DB close];
        
        return res ? YES : NO;
    }
    
    return NO;
}



@end











