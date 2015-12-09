//
//  ZHKeyboardJudge.h
//  KeyboardJudgement
//
//  Created by apple on 12/9/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//  一个时刻监听键盘打开还是关闭的单例

#import <Foundation/Foundation.h>

@interface ZHKeyboardJudge : NSObject

/** 单例 */
+ (instancetype)judgeInstance;

/**
 *  判断键盘是否打开
 *
 *  @return YES\打开，NO\关闭
 */
- (BOOL)keyboardOpened;

@end
