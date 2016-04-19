//
//  UIAlertView+Block.h
//  UIAlertViewSelfDelegate
//
//  Created by apple on 4/19/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClickHandler)(UIAlertView *alertView, NSUInteger btnIdx);

@interface UIAlertView (Block)<UIAlertViewDelegate>

- (void)setClickHandler:(ClickHandler)clickHandler;

- (ClickHandler)clickHandler;

@end
