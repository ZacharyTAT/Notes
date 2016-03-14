//
//  ZHSearch.h
//  Notes
//
//  Created by apple on 12/15/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZHSearch,ZHSearchBar,ZHNote;

@protocol ZHSearchDelegate <NSObject>
@optional

/**
 *  在搜索框文字改变时，询问是否应该重新加载数据，一般在此方法里面更新数据源
 *
 *  @param searchString 新的用于搜索的关键词
 *  @param dataSource   旧的数据源，用作参考
 *  @return 新的数据源
 */
- (NSMutableArray *)search:(ZHSearch *)search shouldReloadTableForSearchString:(NSString *)searchString dataSource:(NSMutableArray *)dataSource;
/**
 *  点击了搜索结果表格中的一行
 */
- (void)search:(ZHSearch *)search didSelectTableView:(UITableView *)tableView RowAtIndexPath:(NSIndexPath *)indexPath;

/** 删除了某一行,要在原数据源中删除对应模型，需要对磁盘进行操作*/
- (void)search:(ZHSearch *)search didDeleteRowWithNote:(ZHNote *)note;

/** 置顶某一行 */
- (void)search:(ZHSearch *)search didStickRowWithNote:(ZHNote *)stickNote;


/** 取消置顶某一行 */
- (void)search:(ZHSearch *)search didCancelStickRowWithNote:(ZHNote *)cancelStickNote;

@end

@interface ZHSearch : NSObject

/** 搜索栏 */
@property(nonatomic,strong)ZHSearchBar *searchBar;

/** 搜索控制器 */
@property(nonatomic,strong)UISearchDisplayController *sdc;

/** 数据源 */
@property(nonatomic,strong)NSMutableArray *dataSource;

/** 代理 */
@property(nonatomic,weak)id<ZHSearchDelegate> delegate;

/** 记录是否正处于编辑状态 */
@property(nonatomic,assign,getter = isEditing)BOOL editing;

/**
 *  必须调用此方法进行初始化，而不是init
 *
 *  @param contentController UISearchDisplayController的contentController
 *  @param dataSource        搜索结果的数据来源，将展示在tableView上
 */
- (instancetype)initWithcontentController:(UIViewController *)contentController dataSource:(NSMutableArray *)dataSource;

@end









