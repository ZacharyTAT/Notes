//
//  ZHUser.h
//  Notes
//
//  Created by apple on 4/16/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHUser : NSObject<NSCoding>

/** 用户名 */
@property (nonatomic, copy)NSString *username;

/** 密码 */
@property (nonatomic, copy)NSString *password;

/**
 *  通过用户名和密码创建一个User对象
 *
 */
+ (instancetype)userWithUsername:(NSString *)username password:(NSString *)password;

@end
