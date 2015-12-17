//
//  ZHDataUtil.m
//  Notes
//
//  Created by apple on 12/9/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import "ZHDataUtil.h"
#import "ZHNote.h"


@implementation ZHDataUtil

#pragma mark - 删除制定note对应的磁盘数据
+ (void)removeNote:(ZHNote *)note
{
    if (note == nil) return;
    
    NSString *fileName = [NSString stringWithFormat:@"%lf.data",[note.modifydate timeIntervalSince1970]];
    
    NSString *filePath = [ZHDocumentPath stringByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {//存在即删除
        
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        NSLog(@"删除文件成功...");
        
        return;
    }
    
    NSLog(@"不存在这样的文件，别删了...");
}

#pragma mark - 将指定的note保存在磁盘上
+ (void)saveWithNote:(ZHNote *)note
{
    if (note == nil) return;
    
    NSString *fileName = [NSString stringWithFormat:@"%lf.data",[note.modifydate timeIntervalSince1970]];
    
    NSString *filePath = [ZHDocumentPath stringByAppendingPathComponent:fileName];
    
    [NSKeyedArchiver archiveRootObject:note toFile:filePath];
    
    NSLog(@"保存文件成功");
}

#pragma mark - 获取所有笔记列表
+ (NSMutableArray *)noteList
{
    NSMutableArray *dataArr = [NSMutableArray array];
    //从document中加载数据
    
    //01.获取文件列表
    NSString *docPath = ZHDocumentPath;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSArray *lists = [fileMgr contentsOfDirectoryAtPath:docPath error:nil];
    
    //02.转模型后存入数组
    for (int i = 0; i < lists.count; i++) {
        NSString *fileName = lists[i];
        if ([[fileName pathExtension] isEqualToString:@"data"]){
            //02-1.获取文件决定路径(包括文件名)
            NSString *filePath = [docPath stringByAppendingPathComponent:fileName];
            
            //02-2.转化为模型
            ZHNote *note = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
            
            //02-3.存入对象
    //        [dataArr addObject:note];
            [dataArr insertObject:note atIndex:0];
        }
    }
    return dataArr;
}

@end
