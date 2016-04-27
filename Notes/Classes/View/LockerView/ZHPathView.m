//
//  ZHPathView.m
//  Notes
//
//  Created by apple on 4/27/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "ZHPathView.h"

#define SUCCEED_COLOR ZHColor(10, 95, 255)
#define FIALED_COLOR ZHColor(249, 41, 29)

@interface ZHPathView()

/** 存储所有已经选择的图片 */
@property (nonatomic, weak)NSMutableArray *selectedBtns;

/** 记录当前手指移动的点 */
@property (nonatomic, assign)CGPoint currentPoint;

/** 手势正确还是错误,错误则手势路径为失败时的颜色 */
@property (nonatomic, assign, getter = isFailed)BOOL failed;

@end

@implementation ZHPathView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setNeedsDisplayWithSelectedBtns:(NSMutableArray *)selectedBtns currentPoint:(CGPoint)currentPoint failed:(BOOL)failed
{
    self.selectedBtns = selectedBtns;
    self.currentPoint = currentPoint;
    self.failed = failed;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if (self.selectedBtns.count == 0) return;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for (int i = 0; i < self.selectedBtns.count; i++) {
        
        UIButton *btn = (UIButton *)self.selectedBtns[i];
        
        if (i == 0) {
            [path moveToPoint:btn.center];
        }else{
            [path addLineToPoint:btn.center];
        }
    }
    
    [path addLineToPoint:self.currentPoint];
    
    //线颜色
    [self.failed ? FIALED_COLOR : SUCCEED_COLOR set];
    
    //线宽
    [path setLineWidth:3];
    
    //线条样式
    [path setLineJoinStyle:kCGLineJoinBevel];
    
    //画线
    [path stroke];
}

@end
