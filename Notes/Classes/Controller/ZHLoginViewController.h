//
//  ZHLoginViewController.h
//  Notes
//
//  Created by apple on 4/15/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//  登录控制器

#import <UIKit/UIKit.h>

@class ZHLoginViewController;

@protocol ZHLoginViewControllerDelegate <NSObject>
/**
 *  成功登录
 */
- (void)loginViewControllerDidSuccess:(ZHLoginViewController *)suvc;
@end


@interface ZHLoginViewController : UIViewController

/** 代理 */
@property (nonatomic, weak) id<ZHLoginViewControllerDelegate> delegate;

/**
 *  是否隐藏注册按钮
 */
@property (nonatomic, assign)BOOL hideSignupBtn;

@end
