//
//  ZHBottomBar.m
//  Notes
//
//  Created by apple on 12/4/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//  这是底部工具栏，基本按钮有分享、删除、新建，还将添加上一页\下一页按钮

#import "ZHBottomBar.h"



@interface ZHBottomBar()


/** 存储item数组，不包含弹簧 */
@property(nonatomic,strong)NSMutableArray *itemArr;


@end

@implementation ZHBottomBar

/**
 *  第一次使用这个类的时候调用
 */
+(void)initialize
{
    //工具栏的主题
    [[UIToolbar appearance] setTintColor:ZHTintColor];
    
}

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

- (void)layoutSubviews
{
    [super layoutSubviews];
//    [ZHHierarchy processWithView:self];
    //设置背景的透明度
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"_UIToolbarBackground")]) {
            subView.backgroundColor = [UIColor whiteColor];
            subView.alpha = 0.9;
        }
    }
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
//    shareBtn.tintColor = ZHTintColor; //由UIToolBar主题设置
    //self.shareBtn = shareBtn;
    
    //弹簧
    UIBarButtonItem *spring1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //02.删除按钮
    UIBarButtonItem *deleteBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(barItemClick:)];
    deleteBtn.tag = ZHBarItemDelete;
//    deleteBtn.tintColor = ZHTintColor;
    //self.deleteBtn = deleteBtn;
    
    //弹簧
    UIBarButtonItem *spring2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //03.新建按钮
    UIBarButtonItem *createBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(barItemClick:)];
    createBtn.tag = ZHBarItemCreate;
//    createBtn.tintColor = ZHTintColor;
    //self.createBtn = createBtn;
    
    self.itemArr = [NSMutableArray arrayWithArray:@[shareBtn,deleteBtn,createBtn]];
    
    self.items = @[shareBtn,spring1,deleteBtn,spring2,createBtn];
}

#pragma mark - 添加一个显示文字的按钮
- (void)addTitleBtnWithTitle:(NSString *)title type:(ZHBarItem)barItemType AtIndex:(NSUInteger)index
{
    NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:self.items];
    
    //弹簧
    UIBarButtonItem *spring = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //按钮
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(barItemClick:)];
    
    titleItem.tag = barItemType;
//    titleItem.tintColor = ZHTintColor;
    
    if (barItemType == ZHBarItemPrePage) {
        self.prePageItem = titleItem;
    }else if (barItemType == ZHBarItemNextPage) {
        self.nextPageItem = titleItem;
    }
    
    //self.createBtn = createBtn;
    
    if (index < self.itemArr.count) { //插入
        
        UIBarButtonItem *item = self.itemArr[index];
        
        //更新itemArr
        [self.itemArr insertObject:titleItem atIndex:index];
        
        //更新items
        NSArray *insertArr = @[titleItem,spring];
        
        NSUInteger itemIndex = [mutableArr indexOfObject:item];
        [mutableArr insertObjects:insertArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(itemIndex, insertArr.count)]];
        
    }else{ //最后面追加
        
        //更新itemArr
        [self.itemArr addObject:titleItem];
        
        //更新items
        NSArray *insertArr = @[spring,titleItem];
        
        [mutableArr addObjectsFromArray:insertArr];
    }
    
    self.items = mutableArr;
}


- (void)barItemClick:(UIBarButtonItem *)barItem
{
    NSLog(@"%d",barItem.tag);
    //通知代理，按钮被点击了
    if ([self.delegate respondsToSelector:@selector(bottomBar:didClickItem:)]) {
        [self.delegate bottomBar:self didClickItem:barItem];
    }
}

@end










