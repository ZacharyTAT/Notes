//
//  ZHHightlightTextView.m
//  UITextView关键词阴影
//
//  Created by apple on 12/30/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import "ZHHightlightTextView.h"

@interface ZHHightlightTextView()

/** 记录textContainerView */
@property (nonatomic,weak)UIView *textContainerView;

/** 记录计算好的textRange，以备后用 */
@property (nonatomic,weak)UITextRange *textRange;

/** 存储创建的高亮视图 */
@property (nonatomic,strong)NSMutableArray *highlightViews;


@end

@implementation ZHHightlightTextView


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        for (UIView *subView in self.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"_UITextContainerView")]) {
                self.textContainerView = subView;
            }
        }
        
    }
    
    return self;
}

- (void)awakeFromNib
{
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"_UITextContainerView")]) {
            self.textContainerView = subView;
        }
    }
}

- (NSMutableArray *)highlightViews
{
    if (_highlightViews == nil) {
        
        _highlightViews = [NSMutableArray array];
    }
    return _highlightViews;
}

//参考自:https://github.com/Exile90/ICTextView

- (void)highlightString:(NSString *)stringToHightlight
{
    UITextRange *textRange = [self textRangeOfString:stringToHightlight];
    
    [self highlightStringAtRects:[self selectionRectsForRange:textRange]];
}

/**
 *  将指定位置高亮
 *
 *  @param selectionRects 若干文字块
 */
- (void)highlightStringAtRects:(NSArray *)selectionRects
{
    for (UITextSelectionRect *selectionRect in selectionRects) {
        UIView *highlightView = [[UIView alloc] initWithFrame:selectionRect.rect];
        [self insertSubview:highlightView belowSubview:self.textContainerView];
        
        highlightView.backgroundColor = [UIColor colorWithRed:254/255.0 green:192/255.0 blue:9/288.0 alpha:1.0];
        highlightView.layer.cornerRadius = 5.0;
        
        [self.highlightViews addObject:highlightView];
    }
    
    //滚动
//    [self scrollRectToVisible:[[selectionRects firstObject] rect] animated:NO];
    
    NSRange range = [self rangeWithTextRange:self.textRange];
    
    self.contentOffset = CGPointMake(0, [self lineInLocation:range.location]);
}

#pragma mark - 移除所有高亮视图
- (void)removeAllHighlightView
{
    if (!self.highlightViews.count) return;
    
    [self.highlightViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //自己也要清空掉所有高亮视图
    [self.highlightViews removeAllObjects];
}

/**
 *  计算确定范围内文字的垂直偏移
 */
- (NSUInteger)lineInLocation:(NSUInteger)location
{
#warning 这里的size写固定了，应该是要计算出来的
    
    CGSize size = CGSizeMake(20, 20);
    //一行多少个字
    NSUInteger numberOfWordsInOneLine = self.textContainerView.frame.size.width / size.width;
    
    return (location / numberOfWordsInOneLine + 1) * size.height;
}

/**
 *  从UITextRange转换为NSRange
 *  转换方法参考自:
 *  http://stackoverflow.com/questions/21149767/convert-selectedtextrange-uitextrange-to-nsrange
 *
 */
- (NSRange)rangeWithTextRange:(UITextRange *)textRange
{
    UITextPosition *beginPos = self.beginningOfDocument;
    
    UITextPosition *textBeginPos = textRange.start;
    UITextPosition *textEndPos = textRange.end;
    
    NSUInteger location = [self offsetFromPosition:beginPos toPosition:textBeginPos];
    
    NSUInteger length = [self offsetFromPosition:textBeginPos toPosition:textEndPos];
    
    return NSMakeRange(location, length);
}

/**
 *  文字范围内可见的rect
 *
 *  @param considerInset 是否考虑contentInset
 */
- (CGRect)visibleRect:(BOOL)considerInset
{
    if (considerInset) {
        UIEdgeInsets contentInset = self.contentInset;
        CGRect visibleRect = self.bounds;
        visibleRect.origin.x += contentInset.left;
        visibleRect.origin.y += contentInset.top;
        visibleRect.size.width -= (contentInset.left + contentInset.right);
        visibleRect.size.height -= (contentInset.top + contentInset.bottom);
        return visibleRect;
    }
    
    return self.bounds;
}
/**
 *  计算文本可见范围
 *  @param startPosition 开始位置作为传出值
 */
- (NSRange)visibleRangeWithVisibleRect:(CGRect)visibleRect startPosition:(UITextPosition *__autoreleasing *)startPosition
{
    CGPoint startPoint = visibleRect.origin;
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(visibleRect), CGRectGetMaxY(visibleRect));
    
    UITextPosition *visibleStart = [self characterRangeAtPoint:startPoint].start;
    UITextPosition *visibleEnd = [self characterRangeAtPoint:endPoint].end;
    
    NSRange visibleRange = NSMakeRange([self offsetFromPosition:self.beginningOfDocument toPosition:visibleStart], [self offsetFromPosition:visibleStart toPosition:visibleEnd]);
    
    if (startPosition) *startPosition = visibleStart;
    
    return visibleRange;
}

/**
 *  计算文本框中文字的范围
 */
- (UITextRange *)textRangeOfString:(NSString *)string
{
    NSRange stringRange = [self.text rangeOfString:string];
    
    // visible rect

    CGRect visibleRect = [self visibleRect:YES];
    
    UITextPosition *startPosition;
    
    //visible range
    NSRange visibleRange = [self visibleRangeWithVisibleRect:visibleRect startPosition:&startPosition];
    
    //text Range
    UITextPosition *start = [self positionFromPosition:startPosition offset:(stringRange.location - visibleRange.location)];
    UITextPosition *end = [self positionFromPosition:start offset:stringRange.length];
    
    UITextRange *textRange = [self textRangeFromPosition:start toPosition:end];
    
    self.textRange = textRange;
    
    return textRange;
}

@end








