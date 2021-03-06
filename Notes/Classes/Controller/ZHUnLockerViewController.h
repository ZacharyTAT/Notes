//
//  ZHUnLockerViewController.h
//  Notes
//
//  Created by apple on 3/21/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHUnLockerViewController;
/**
 *
 *  @param result YES\成功 NO\失败
 */
typedef void (^ZHUnLockerCompletionHander)(ZHUnLockerViewController *ulvc, BOOL result);

@interface ZHUnLockerViewController : UIViewController

/** 使用block进行回调 */
@property (nonatomic, copy) ZHUnLockerCompletionHander completionHander;

@property (nonatomic, copy)NSString *tip;

@end
