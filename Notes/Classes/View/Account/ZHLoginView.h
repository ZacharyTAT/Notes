//
//  ZHLoginView.h
//  Notes
//
//  Created by apple on 4/15/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//  登录视图，用户名\密码输入框，登录按钮

#import <UIKit/UIKit.h>

@class ZHLoginView;

@protocol ZHLoginViewDelegate <NSObject>

/**
 *  点击了登录按钮
 *
 *  @param username  用户名
 *  @param password  密码
 */
- (void)loginView:(ZHLoginView *)loginView didLoginWithUserName:(NSString *)username password:(NSString *)password;


@end

@interface ZHLoginView : UIView

/** 代理 */
@property (nonatomic, weak)id<ZHLoginViewDelegate> delegate;

/** 用户名框变成第一响应者 */
- (void)userTxtFieldBecomeFirstResponder;

/**
 *  通过外界设置用户名和密码
 *
 *  @param username 用户名
 *  @param password 密码
 */
- (void)setUsername:(NSString *)username password:(NSString *)password;


@end



