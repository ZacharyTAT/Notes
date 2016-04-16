//
//  ZHSignupView.h
//  Notes
//
//  Created by apple on 4/16/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHSignupView;

@protocol ZHSignupViewDelegate <NSObject>

/**
 *  将用户名和密码传给代理
 *
 *  @param username   用户名
 *  @param password   密码
 */
- (void)signupView:(ZHSignupView *)signupView didSignupWithUsername:(NSString *)username password:(NSString *)password;

@end

@interface ZHSignupView : UIView

/** 代理 */
@property(nonatomic, weak) id<ZHSignupViewDelegate> delegate;

/**
 *  让用户名框成为第一响应者
 */
- (void)userTxtFieldBecomeFirstResponder;

@end


