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
    ZHBarItemCreate
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

@end
