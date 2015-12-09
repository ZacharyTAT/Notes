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
    NSString *fileName = [NSString stringWithFormat:@"%lf.data",[note.modifydate timeIntervalSince1970]];
    
    NSString *filePath = [ZHDocumentPath stringByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {//存在即删除
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        return;
    }
    
    NSLog(@"删除文件失败，不存在这样的文件..");
}

#pragma mark - 将指定的note保存在磁盘上
+ (void)saveWithNote:(ZHNote *)note
{
    NSString *fileName = [NSString stringWithFormat:@"%lf.data",[note.modifydate timeIntervalSince1970]];
    
    NSString *filePath = [ZHDocumentPath stringByAppendingPathComponent:fileName];
    
    [NSKeyedArchiver archiveRootObject:note toFile:filePath];
}


@end
