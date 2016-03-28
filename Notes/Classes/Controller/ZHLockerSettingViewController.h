//
//  ZHLockerSettingViewController.h
//  Notes
//
//  Created by apple on 3/28/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHLockerSettingViewController;


@protocol ZHLockerSettingViewControllerDelegate <NSObject>

/**
 *  成功设置了密码
 */
- (void)lockerSettingViewController:(ZHLockerSettingViewController *)lsvc successToSetPassword:(NSString *)password;

@end

@interface ZHLockerSettingViewController : UIViewController

/** 代理 */
@property (nonatomic, weak)id<ZHLockerSettingViewControllerDelegate> delegate;

@end
