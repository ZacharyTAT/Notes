//
//  ZHTextView.h
//  Notes
//
//  Created by apple on 12/6/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHTextView : UITextView

/** 显示本笔记的修改时间 */
@property(nonatomic,weak)UILabel *modifydateLbl;

/**
 *  修改尺寸
 */
- (void)changeFrameInset;

#pragma mark - 恢复尺寸
/**
 *  传入父控件设置的frame恢复尺寸
 */
- (void)resetFrameInset;
@end
