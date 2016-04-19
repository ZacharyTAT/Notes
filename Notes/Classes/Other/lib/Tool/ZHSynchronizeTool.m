//
//  ZHSynchronizeTool.m
//  Notes
//
//  Created by apple on 4/17/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "ZHSynchronizeTool.h"

#import "ZHDataUtil.h"

#import "ZHNote.h"

@implementation ZHSynchronizeTool


#pragma mark - 将服务器上的数据与本地数据合并

+ (BOOL)mergeFromServer:(NSArray *)notes
{
    NSMutableArray *arr = [@[] mutableCopy];
    
    //01.数组转模型
    for (NSMutableDictionary *dict in notes) {
        [arr addObject:[[ZHNote alloc] initWithDict:dict]];
    }
    
    //02.合并
    
    NSMutableArray *noteList = [ZHDataUtil noteList];
    
    [arr addObjectsFromArray:noteList];
    
    //03.清空本地数据并重拍id
    BOOL result = [ZHDataUtil clear];
    
    if (!result) return NO;
    
    //04.写入数据库
     [ZHDataUtil saveNotes:arr];
    
    //最后更新一下未备份标记
    if ([noteList count] > 0) { //还有未备份的笔记
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNotesTobeUpdated];
    }else{ //没有未备份的笔记了
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kNotesTobeUpdated];
    }
    
    return YES;

}

#pragma mark - 数据库中的笔记转为字典形式

+ (NSArray *)noteDicts
{
    NSMutableArray *dicts = [@[] mutableCopy];
    
    NSMutableArray *notes = [ZHDataUtil noteList];
    
    for (ZHNote *note in notes) {
        [dicts addObject:[note toDictionary]];
    }
    
    return dicts;
}





@end
