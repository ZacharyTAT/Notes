//
//  ZHLockerView.m
//  手势解锁
//
//  Created by apple on 3/25/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "ZHLockerView.h"
#import "ZHCircleView.h"

#define SUCCEED_COLOR [UIColor blueColor]
#define FIALED_COLOR [UIColor redColor]

@interface ZHLockerView()

/** 图片尺寸作为按钮尺寸 */
@property (nonatomic, assign)CGSize btnSize;

/** 存储所有已经选择的图片 */
@property (nonatomic, strong)NSMutableArray *selectedBtns;

/** 记录当前手指移动的点 */
@property (nonatomic, assign)CGPoint currentPoint;

/** 手势正确还是错误,错误则手势路径为失败时的颜色 */
@property (nonatomic, assign, getter = isFailed)BOOL failed;

@end

@implementation ZHLockerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

/**
 *  初始化，添加9个按钮
 */
- (void)setup
{
    //添加9个按钮
    for (int i = 0; i < 9; i++) {
        
        UIButton *btn = [ZHCircleView buttonWithType:UIButtonTypeCustom];
        
        btn.tag = i;
        
        [self addSubview:btn];
    }
    
    self.backgroundColor = [UIColor clearColor];
}

/**
 *  按钮尺寸跟图片尺寸保持一致
 */
- (CGSize)btnSize
{
    if (CGSizeEqualToSize(_btnSize, CGSizeZero)) {
        _btnSize = [[UIImage imageNamed:@"gesture_node_normal"] size];
    }
    
    return _btnSize;
}

#pragma mark - Properties
- (NSMutableArray *)selectedBtns
{
    if (_selectedBtns == nil) {
        _selectedBtns = [@[] mutableCopy];
    }
    
    return _selectedBtns;
}

#pragma mark - 确定子控件位置
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat btnW = self.btnSize.width;
    CGFloat btnH = self.btnSize.height;
    
    CGFloat marginH = (self.frame.size.width - 3 * btnW) / 2; //水平间距
    CGFloat marginV = (self.frame.size.height - 3 * btnH) / 2; //垂直间距
    
    for (int i = 0; i < self.subviews.count; i++) {
        
        UIButton *btn = (UIButton *)self.subviews[i];
        
        CGFloat btnX = (i % 3) * (btnW + marginH);
        CGFloat btnY = (i / 3) * (btnH + marginV);
        
        btn.frame = (CGRect){{btnX, btnY}, self.btnSize};
    }
}

/**
 *  确定当前手指所在的点
 */
- (CGPoint)pointForTouches:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    
    return [touch locationInView:touch.view];
}

/**
 *  根据点确定按钮
 */
- (UIButton *)btnForPoint:(CGPoint)pnt
{
    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, pnt)) {
            return btn;
        }
    }
    
    return nil;
}

/**
 *  所有选中按钮取消选中
 */
- (void)clearAllSelectedBtn
{
    [self.selectedBtns makeObjectsPerformSelector:@selector(setSelected:) withObject:@(NO)];
    
    [self.selectedBtns removeAllObjects];
}

/**
 *  清除视图
 */
- (void)clear
{
    [self clearAllSelectedBtn];
    [self setNeedsDisplay];
    
    //如果密码错误，不会立刻清除，暂时不能响应用户绘制，在这里要恢复
    self.userInteractionEnabled = YES;
}

/**
 *  手势密码序列化,可定制序列化算法
 */
- (NSString *)serialize
{
    NSMutableString *str = [NSMutableString string];
    
    for (int i = 0; i < self.selectedBtns.count; i++) {
        UIButton *btn = (UIButton *)self.selectedBtns[i];
        [str appendFormat:@"%d",btn.tag + 1];
    }
#warning 怎么更好地表示密码?
    return [str description];
}

#pragma mark - 手势方法

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.failed = NO;
    //定位点
    CGPoint pnt = [self pointForTouches:touches];
    
    //通过点定位按钮
    UIButton *btn = [self btnForPoint:pnt];
    
    if (btn) {
        [btn setSelected:YES];
        [self.selectedBtns addObject:btn];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //定位点
    CGPoint pnt = [self pointForTouches:touches];
    
    //通过点定位按钮
    UIButton *btn = [self btnForPoint:pnt];
    
    if (btn && ![self.selectedBtns containsObject:btn]) {
        [btn setSelected:YES];
        [self.selectedBtns addObject:btn];
    }
    
    self.currentPoint = pnt;
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSString *pswd = [self serialize];
    
    NSLog(@"密码为 : %@",pswd);
    
    if ([self.delegate respondsToSelector:@selector(lockerView:isCorrectPswd:)]) {
        
        self.failed = ![self.delegate lockerView:self isCorrectPswd:pswd];
        
        if (self.failed) {
            self.userInteractionEnabled = NO;
            [self setNeedsDisplay];
            [self performSelector:@selector(clear) withObject:nil afterDelay:1.0];
        }else{
//            [self clear];
        }
    }else{
        NSLog(@"代理没有实现该方法");
        [self clear];
    }

}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

#pragma mark - 画线方法
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

- (void)dealloc
{
    NSLog(@"%@ dealloc", [self class]);
}

@end





