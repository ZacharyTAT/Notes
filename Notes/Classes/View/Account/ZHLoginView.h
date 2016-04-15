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
 */
- (void)loginViewDidLogin:(ZHLoginView *)loginView;


@end

@interface ZHLoginView : UIView

/** 代理 */
@property (nonatomic, weak)id<ZHLoginViewDelegate> delegate;




@end


