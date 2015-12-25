//
//  ZHTableViewCell.m
//  Notes
//
//  Created by apple on 12/23/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import "ZHMultiButtonTableViewCell.h"

@interface ZHMultiButtonTableViewCell()

/** 记录cell中的唯一子视图 */
@property (nonatomic,weak)UIView *cellScrollView;

@end

@implementation ZHMultiButtonTableViewCell

/**
 *  在scrollView开始滚动时，对里面的按钮进行改造
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > 30) return;
    for (UIView *subView in scrollView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
            NSLog(@"%@",subView.subviews);
            
            UIButton *lastBtn = (UIButton *)[subView.subviews lastObject];
            
            //01.拉长父控件，使其容纳两个按钮
            CGRect frame = subView.frame;
            frame.origin.x += lastBtn.frame.size.width;
            frame.size.width += lastBtn.frame.size.width;
            subView.frame = frame;
            
            //02.删除系统"删除"按钮
            [lastBtn removeFromSuperview];
            
            //03.添加自定义"删除"按钮
            UIButton *btn1 = [[UIButton alloc] initWithFrame:lastBtn.frame];
            //与系统颜色一致
            btn1.backgroundColor = lastBtn.backgroundColor;
            [btn1 setTitle:@"删除" forState:UIControlStateNormal];
            [subView addSubview:btn1];
            //点击事件
            [btn1 addTarget:self action:@selector(cellBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            //设置类型
            btn1.tag = ZHTableViewCellTypeDelete;
            
            //04.添加"置顶"按钮
            UIButton *btn2 = [[UIButton alloc] init];
            
            [btn2 setTitle:@"置顶" forState:UIControlStateNormal];
            
            CGRect lastBtnframe = lastBtn.frame;
            CGFloat btnW = lastBtnframe.size.width;
            CGFloat btnH = lastBtnframe.size.height;
            CGFloat btnX = lastBtnframe.origin.x - btnW;
            CGFloat btnY = lastBtnframe.origin.y;
            
            btn2.frame = CGRectMake(btnX, btnY, btnW, btnH);
            
            [subView addSubview:btn2];
            //浅灰色
            [btn2 setBackgroundColor:[UIColor lightGrayColor]];
            //点击事件
            [btn2 addTarget:self action:@selector(cellBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            //设置类型
            btn2.tag = ZHTableViewCellTypeStick;
            
            //05.增长scrollView的滚动区域
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, lastBtn.frame.size.width * 2);
            
        }
    }
}

- (void)cellBtnClicked:(UIButton *)cellBtn
{
    NSLog(@"tag = %d",cellBtn.tag);
    //通知代理
    if (cellBtn.tag == ZHTableViewCellTypeDelete) { // 删除
        if ([self.cellDelegate respondsToSelector:@selector(tableViewCellDidClickDelete:)]) {
            [self.cellDelegate tableViewCellDidClickDelete:self];
        }
    }else if (cellBtn.tag == ZHTableViewCellTypeStick) {//置顶
        if ([self.cellDelegate respondsToSelector:@selector(tableViewCellDidClickStick:)]) {
            [self.cellDelegate tableViewCellDidClickStick:self];
        }
    }
}

- (void)didAddSubview:(UIView *)subview
{
    self.cellScrollView = subview;
}

@end








