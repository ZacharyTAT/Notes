//
//  ZHLocker.m
//  Notes
//
//  Created by apple on 3/26/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//  

#import "ZHLocker.h"
#import "ZHNavigationController.h"

@implementation ZHLocker

+ (void)verifyInViewControlloer:(UIViewController *)aVC
                          title:(NSString *)title
                            tip:(NSString *)tip
              completionHandler:(ZHUnLockerCompletionHander)completionHander
{
    
    ZHUnLockerViewController *ulvc = [[ZHUnLockerViewController alloc] init];
    ulvc.title = title;
    ulvc.tip = tip;
    ulvc.completionHander = completionHander;
    
    [aVC presentViewController:[[ZHNavigationController alloc] initWithRootViewController:ulvc] animated:YES completion:NULL];
}

+ (void)verifyInViewControlloer:(UIViewController *)aVC title:(NSString *)title completionHandler:(ZHUnLockerCompletionHander)completionHander
{
    [ZHLocker verifyInViewControlloer:aVC title:title tip:@"" completionHandler:completionHander];
}

@end
