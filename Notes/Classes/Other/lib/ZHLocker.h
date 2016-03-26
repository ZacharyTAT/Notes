//
//  ZHLocker.h
//  Notes
//
//  Created by apple on 3/26/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//  此类是用于弹出带九宫格手势解锁视图的控制器
//  包括需要手势验证VC和设置手势VC

#import <Foundation/Foundation.h>
#import "ZHUnLockerViewController.h"

@interface ZHLocker : NSObject

/**
 *  弹出手势验证控制器
 *
 *  @param aVC              通过这个VC弹出
 *  @param completionHander 控制器消失时句柄
 */
+ (void)verifyInViewControlloer:(UIViewController *)aVC completionHandler:(ZHUnLockerCompletionHander)completionHander;


@end
