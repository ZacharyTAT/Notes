//
//  UIAlertView+Block.m
//  UIAlertViewSelfDelegate
//
//  Created by apple on 4/19/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "UIAlertView+Block.h"

#import <objc/runtime.h>

#define kClickHandlerKey @"kClickHandlerKey"

@implementation UIAlertView (Block)

- (void)setClickHandler:(ClickHandler)clickHandler
{
    //这句话作用如下:
    //由于分类是不能增加成员变量的，而此处的block是需要存储起来的
    //怎么办？可以用下面runtime中的函数，将block以键值的形式与分类关联起来
    //需要设置键，方便以后通过该键取出该block值。
    //可以将该对象看作成字典，指定了键之后，就可以取出值
    objc_setAssociatedObject(self, kClickHandlerKey, clickHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    //最后一个参数是关联该block值的策略，
    //OBJC_ASSOCIATION_COPY_NONATOMIC相当于
    //@property (nonatomic, copy) ClickHandler handler;
    
    
    if (clickHandler) {
        self.delegate = self;
    }else{
        self.delegate = nil;
    }
}

- (ClickHandler)clickHandler
{
    return objc_getAssociatedObject(self, kClickHandlerKey);
}


#pragma mark - Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.clickHandler) {
        self.clickHandler(alertView, buttonIndex);
    }
}

@end
