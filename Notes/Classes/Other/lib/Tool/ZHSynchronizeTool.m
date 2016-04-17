//
//  ZHSynchronizeTool.m
//  Notes
//
//  Created by apple on 4/17/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "ZHSynchronizeTool.h"

#import "ZHDataUtil.h"

@implementation ZHSynchronizeTool


#pragma mark - 将服务器上的数据与本地数据合并

+ (BOOL)mergeFromServer:(NSArray *)notes
{
    //01.合并
    NSMutableArray *arr = [notes mutableCopy];
    
    [arr addObjectsFromArray:[ZHDataUtil noteList]];
    
    //02.清空本地数据并重拍id
    BOOL result = [ZHDataUtil clear];
    
    if (!result) return NO;
    
    //03.写入数据库
     [ZHDataUtil saveNotes:arr];
    
    return YES;

}




@end
