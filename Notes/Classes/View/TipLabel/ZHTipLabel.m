//
//  ZHTipLabel.m
//  Notes
//
//  Created by apple on 3/28/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "ZHTipLabel.h"

@implementation ZHTipLabel

- (void)showNormalTip:(NSString *)normal
{
    self.textColor = [UIColor blackColor];
    self.text = normal;
}

- (void)showWarningTip:(NSString *)warning
{
    self.textColor = [UIColor redColor];
    self.text = warning;
}


@end
