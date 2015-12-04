//
//  ZHBottomBar.m
//  Notes
//
//  Created by apple on 12/4/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//  这是底部工具栏，基本按钮有分享、删除、新建，还将添加上一页\下一页按钮

#import "ZHBottomBar.h"

typedef NS_ENUM(NSInteger, ZHBarItem)
{
    ZHBarItemShare,
    ZHBarItemDelete,
    ZHBarItemCreate
};

@interface ZHBottomBar()

/** 分享按钮 */
@property(nonatomic,weak)UIBarButtonItem *shareBtn;

/** 删除按钮 */
@property(nonatomic,weak)UIBarButtonItem *deleteBtn;

/** 新建按钮 */
@property(nonatomic,weak)UIBarButtonItem *createBtn;

@end

@implementation ZHBottomBar

- (instancetype)init
{
    if (self = [super init]) {
        [self setupSubViews];
    }
    return self;
}

#pragma mark - 迅速创建一个底部栏
+ (instancetype)bottomBar
{
    return [[self alloc] init];
}

#pragma mark - 初始化所有子控件
/**
 *  初始化所有子控件
 */
- (void)setupSubViews
{
    //01.分享按钮
    UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(barItemClick:)];
    shareBtn.tag = ZHBarItemShare;
    shareBtn.tintColor = kTintColor;
    self.shareBtn = shareBtn;
    
    //弹簧
    UIBarButtonItem *spring1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //02.删除按钮
    UIBarButtonItem *deleteBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(barItemClick:)];
    deleteBtn.tag = ZHBarItemDelete;
    deleteBtn.tintColor = kTintColor;
    self.deleteBtn = deleteBtn;
    
    //弹簧
    UIBarButtonItem *spring2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //03.新建按钮
    UIBarButtonItem *createBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(barItemClick:)];
    createBtn.tag = ZHBarItemCreate;
    createBtn.tintColor = kTintColor;
    self.createBtn = createBtn;
    
    
    self.items = @[shareBtn,spring1,deleteBtn,spring2,createBtn];
}

#pragma mark - layoutSubviews

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)barItemClick:(UIBarButtonItem *)barItem
{
    NSLog(@"baritem clicked...%d",barItem.tag);
}

@end










