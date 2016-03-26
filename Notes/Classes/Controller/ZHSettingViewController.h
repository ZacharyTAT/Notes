//
//  ZHSettingViewController.h
//  Notes
//
//  Created by apple on 3/26/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//  控制页

#import <UIKit/UIKit.h>

@class ZHSettingViewController;

@protocol ZHSettingViewControllerDelegate <NSObject>

/**
 *  点击了关闭按钮，代理应该将其关闭
 */
- (void)settingViewControllerDidClickClose:(ZHSettingViewController *)svc;

@end

@interface ZHSettingViewController : UIViewController

/** 代理 */
@property (nonatomic, weak)id<ZHSettingViewControllerDelegate> delegate;

@end
