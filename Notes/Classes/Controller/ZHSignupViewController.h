//
//  ZHSignupViewController.h
//  Notes
//
//  Created by apple on 4/15/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//  注册视图

#import <UIKit/UIKit.h>

@class ZHSignupViewController;

@protocol ZHSignupViewControllerDelegate <NSObject>

/**
 *  成功注册
 */
- (void)signupViewControllerDidSuccess:(ZHSignupViewController *)suvc;

@end

@interface ZHSignupViewController : UIViewController

/** 代理 */
@property (nonatomic, weak)id<ZHSignupViewControllerDelegate> delegate;

@end
