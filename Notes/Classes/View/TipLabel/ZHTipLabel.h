//
//  ZHTipLabel.h
//  Notes
//
//  Created by apple on 3/28/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHTipLabel : UILabel

/**
 *  显示正常信息，黑色字
 */
- (void)showNormalTip:(NSString *)normal;

/**
 *  显示错误\失败等信息，红色字
 */
- (void)showWarningTip:(NSString *)warning;

@end
