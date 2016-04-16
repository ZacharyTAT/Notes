//
//  ZHUserTool.h
//  Notes
//
//  Created by apple on 4/16/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZHUser;

@interface ZHUserTool : NSObject

/**
 *  保存账号
 *
 */
+ (void)saveUser:(ZHUser *)user;

/**
 *  取出账号
 *
 */
+ (ZHUser *)user;

/**
 *  删除账号
 */
+ (void)deleteUser;

/**
 *  判断账号是否存在
 */
+ (BOOL)isUserExists;




@end
