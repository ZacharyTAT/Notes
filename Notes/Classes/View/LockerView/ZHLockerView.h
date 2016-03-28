//
//  ZHLockerView.h
//  手势解锁
//
//  Created by apple on 3/25/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHLockerView;

@protocol ZHLockerViewDelegate <NSObject>

/**
 *  询问代理密码是否正确
 *  @param password   通过手势序列化的密码字符串
 *
 *  @return YES\绘制的密码符合要求 NO\不符合要求,不止是用来验证密码正确与否
 */
- (BOOL)lockerView:(ZHLockerView *)lockerView isPswdOK:(NSString *)password;

@end

@interface ZHLockerView : UIView

/** 代理 */
@property (nonatomic, weak)id<ZHLockerViewDelegate> delegate;

@end
