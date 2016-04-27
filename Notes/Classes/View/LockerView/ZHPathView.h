//
//  ZHPathView.h
//  Notes
//
//  Created by apple on 4/27/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHPathView : UIView

/**
 *  通过传入数据进行画图
 *
 *  @param selectedBtns 选中的按钮数组
 *  @param currentPoint 当前点
 *  @param failed       是否失败
 */
- (void)setNeedsDisplayWithSelectedBtns:(NSMutableArray *)selectedBtns currentPoint:(CGPoint)currentPoint failed:(BOOL)failed;

@end
