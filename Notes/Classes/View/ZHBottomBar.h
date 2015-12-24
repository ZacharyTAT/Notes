//
//  ZHBottomBar.h
//  Notes
//
//  Created by apple on 12/4/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHBottomBar;

#pragma mark - 底部栏的按钮枚举
/**
 *  底部栏的按钮枚举
 */
typedef NS_ENUM(NSInteger, ZHBarItem)
{
    /** 分享按钮 */
    ZHBarItemShare,
    
    /** 删除按钮 */
    ZHBarItemDelete,
    
    /** 新建按钮 */
    ZHBarItemCreate,
    
    /** 上一页按钮 */
    ZHBarItemPrePage,
    
    /** 下一页按钮 */
    ZHBarItemNextPage
};

#pragma mark - 底部栏的代理方法
@protocol ZHBottomBarDelegate <NSObject,UIToolbarDelegate>

@optional

/**
 *  点击了底部栏的中的某个按钮
 */
- (void)bottomBar:(ZHBottomBar *)bottomBar didClickItem:(UIBarButtonItem *)barItem;


@end


@interface ZHBottomBar : UIToolbar

/** 代理 */
@property(nonatomic,weak)id<ZHBottomBarDelegate> delegate;


/**
 *  迅速创建一个底部栏
 */
+ (instancetype)bottomBar;


/**
 *  添加一个显示文字的按钮
 *
 *  @param index 添加的位置，不包含弹簧的位置，从0开始.若index大于item个数(不包含弹簧)，则默认加到最后
 */
- (void)addTitleBtnWithTitle:(NSString *)title type:(ZHBarItem)barItemType AtIndex:(NSUInteger)index;


@end





