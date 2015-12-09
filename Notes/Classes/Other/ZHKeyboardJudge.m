//
//  ZHKeyboardJudge.m
//  KeyboardJudgement
//
//  Created by apple on 12/9/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import "ZHKeyboardJudge.h"

@interface ZHKeyboardJudge()

/** 记录键盘是否打开 */
@property(nonatomic, assign,getter = isOpened)BOOL opened;

@end

@implementation ZHKeyboardJudge

+ (id)allocWithZone:(struct _NSZone *)zone
{
    static ZHKeyboardJudge *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
        [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(keyboardStatusChanged:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(keyboardStatusChanged:) name:UIKeyboardDidHideNotification object:nil];
    });
    return instance;
}

+ (void)load
{
    [self judgeInstance];
}

+(instancetype)judgeInstance
{
    return [[self alloc] init];
}

-(BOOL)keyboardOpened
{
    return self.isOpened;
}

- (void)keyboardStatusChanged:(NSNotification *)notif
{
    NSString *name = notif.name;
    if ([UIKeyboardDidShowNotification isEqualToString:name]) { //键盘打开了
        self.opened = YES;
    }else { //键盘关闭了
        self.opened = NO;
    }
}

@end




