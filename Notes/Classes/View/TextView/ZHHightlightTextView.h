//
//  ZHHightlightTextView.h
//  UITextView关键词阴影
//
//  Created by apple on 12/30/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHHightlightTextView : UITextView

/**
 *  高亮显示文本框中的一部分文字
 */
- (void)highlightString:(NSString *)stringToHightlight;

/**
 *  移除所有高亮视图
 */
- (void)removeAllHighlightView;

@end
