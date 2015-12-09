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


@end
