//
//  ZHStickView.m
//  StickView
//
//  Created by apple on 1/1/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "ZHStickView.h"

@implementation ZHStickView

/*
 --------------------
 |        ·p2       |
 |    ·p1     ·p3   |
 |                  |
 |                  |
 | ·p5    ·p4    ·p6|
 |                  |
 --------------------
 
 
 */

- (void)drawRect:(CGRect)rect
{
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //保存当前上下文
    UIGraphicsPushContext(ctx);
    
    CGFloat p1X = width * 0.25;
    CGFloat p1Y = height * 0.5 - 2;
    
    CGFloat p2X = p1X * 2;
    CGFloat p2Y = 0;
    
    CGFloat p3X = p1X * 3;
    CGFloat p3Y = p1Y;
    
    CGFloat p4X = p2X;
    CGFloat p4Y = height * 0.8;
    
    CGFloat p5X = p1X - width * 0.125;
    CGFloat p5Y = p4Y;
    
    CGFloat p6X = p3X + width * 0.125;
    CGFloat p6Y = p4Y;
    
//    [ZHColor(202, 202, 202) setStroke];
    [[UIColor lightGrayColor] setStroke];
    CGContextSetLineWidth(ctx, 1.0);
    
    // p1->p2
    CGContextMoveToPoint(ctx, p1X, p1Y);
    CGContextAddLineToPoint(ctx, p2X, p2Y);
    CGContextStrokePath(ctx);
    
    // p2->p3
    CGContextMoveToPoint(ctx, p2X, p2Y);
    CGContextAddLineToPoint(ctx, p3X, p3Y);
    CGContextStrokePath(ctx);
    
    // p2->p4
    CGContextMoveToPoint(ctx, p2X, p2Y);
    CGContextAddLineToPoint(ctx, p4X, p4Y);
    CGContextStrokePath(ctx);
    
    // p5->p6
    CGContextMoveToPoint(ctx, p5X, p5Y);
    CGContextAddLineToPoint(ctx, p6X, p6Y);
    CGContextStrokePath(ctx);
    
    //弹栈
    UIGraphicsPopContext();
}

@end
