//
//  ZHUserTool.m
//  Notes
//
//  Created by apple on 4/16/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "ZHUserTool.h"

#import "ZHUser.h"

#define ZHUserFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"user.data"]

@implementation ZHUserTool

#pragma mark - 保存账号
+ (void)saveUser:(ZHUser *)user
{
    [NSKeyedArchiver archiveRootObject:user toFile:ZHUserFile];
}

#pragma mark - 获取账号信息
+ (ZHUser *)user
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:ZHUserFile];
}

#pragma mark - 删除账号
+ (void)deleteUser
{
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    [mgr removeItemAtPath:ZHUserFile error:NULL];
}

#pragma mark - 账号是否存在
+ (BOOL)isUserExists
{
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    return [mgr fileExistsAtPath:ZHUserFile];
}






@end
