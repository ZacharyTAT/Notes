//
//  ZHTextView.h
//  Notes
//
//  Created by apple on 12/6/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZHTextViewDelegate <NSObject,UITextViewDelegate>

@optional
/**
 *  当键盘完全弹出后(动画结束),并且textView成为第一响应者时调用
 */
- (void)textViewDidBeginEditingAfterKeyboardTotallyShowUp:(UITextView *)textView;

@end


@interface ZHTextView : UITextView

/** 显示本笔记的修改时间 */
@property(nonatomic,weak)UILabel *modifydateLbl;

/** 代理 */
@property(nonatomic,weak)id<ZHTextViewDelegate> delegate;

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
