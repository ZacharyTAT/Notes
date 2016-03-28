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
              completionHandler:(ZHUnLockerCompletionHander)completionHander
{
    
    ZHUnLockerViewController *ulvc = [[ZHUnLockerViewController alloc] init];
    ulvc.title = title;
    
    ulvc.completionHander = completionHander;
    
    [aVC presentViewController:[[ZHNavigationController alloc] initWithRootViewController:ulvc] animated:YES completion:NULL];
}

@end
