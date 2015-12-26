//
//  ZHTableViewController.m
//  Notes
//
//  Created by apple on 12/1/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//  展示笔记的表格控制器

#import "ZHTableViewController.h"
#import "ZHNewViewController.h"
#import "ZHScanEditViewController.h"

#import "ZHNoteCell.h"
#import "ZHNote.h"
#import "ZHSearch.h"
#import "ZHSearchBar.h"

#import "ZHDataUtil.h"



@interface ZHTableViewController ()<ZHDetailNoteViewControllerDelegate,ZHDetailNoteViewControllerDataSource,ZHNewViewControllerDelegate,ZHScanEditViewControllerDelegate,ZHSearchDelegate,ZHMultiButtonTableViewCellDelegate>

/** 数据源 */
@property (nonatomic, strong)NSMutableArray *dataArr;

/** 搜索结果数据源 */
@property (nonatomic,strong)NSMutableArray *searchResultArr;

/** 负责搜索的模型 */
@property (nonatomic,strong)ZHSearch *search;

@end

@implementation ZHTableViewController


#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"table view did load");
    [self setupNavItem];
    [self setupTableViewHeaderFooter];
    //去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //顶部偏移,使得搜索框不最开始不显示
    CGPoint contentOffset = self.tableView.contentOffset;
    if (contentOffset.y < -20){
        CGFloat headerViewHeight = self.tableView.tableHeaderView.frame.size.height;
        contentOffset.y += headerViewHeight;
        self.tableView.contentOffset = contentOffset;
    }
}
#pragma mark - 数据源
/**
 *  数据源
 */
- (NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        
        //获取数据
        _dataArr = [ZHDataUtil noteList];
        
        //更新表格数据
        [self.tableView reloadData];
    }
    
    return _dataArr;
}

#pragma mark - 搜索结果数据源
/**
 *  搜索结果数据源
 */
- (NSMutableArray *)searchResultArr
{
    if (_searchResultArr == nil) {
        _searchResultArr = [NSMutableArray array];
    }
    return _searchResultArr;
}

#pragma mark - 设置导航栏内容
/**
 *  设置导航栏内容
 */
- (void)setupNavItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新建" style:UIBarButtonItemStylePlain target:self action:@selector(newBtnClick)];
    self.navigationItem.title = @"Notes";
}

#pragma mark - 初始化表格的头部和尾部
- (void)setupTableViewHeaderFooter
{
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
    
    ZHSearch *search = [[ZHSearch alloc] initWithcontentController:self dataSource:self.searchResultArr];
    [search.searchBar donotDoAutoThings];
    self.search = search;
    search.delegate = self;
    
    self.tableView.tableHeaderView = search.searchBar;
}

#pragma mark - 新建按钮点击事件
/**
 *  新建按钮点击事件
 */
- (void)newBtnClick
{
    NSLog(@"new clicked");
    [self newBtnWithAnimated:YES];
}
-(void)newBtnWithAnimated:(BOOL)animated
{
    ZHNewViewController *newVC = [[ZHNewViewController alloc] init];
    newVC.note = [[ZHNote alloc] initWithTitle:@"" modifydate:[NSDate date] content:@""];
    
    newVC.delegate = self;
    newVC.dataSource = self;
    
    [self.navigationController pushViewController:newVC animated:animated];
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //获取数据
    ZHNote *note = self.dataArr[indexPath.row];
    
    //创建控制器
    ZHScanEditViewController *dvc = [[ZHScanEditViewController alloc] init];
    dvc.note = note;
    dvc.delegate = self;
    dvc.dataSource = self;
    
    //跳转
    [self.navigationController pushViewController:dvc animated:YES];
}

#pragma mark - table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //01.创建cell
    ZHNoteCell *cell = [ZHNoteCell noteCellWithTableView:tableView];
    cell.cellDelegate = self;
    //02.给cell传递模型，设置cell数据
    cell.note = self.dataArr[indexPath.row];
    
    //03.返回cell
    return cell;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - ZHMultiButtonTableViewCellDelegate

#pragma mark - 删除按钮点击
- (void)tableViewCellDidClickDelete:(ZHMultiButtonTableViewCell *)tableViewCell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tableViewCell];
    NSLog(@"%d",indexPath.row);
        
        NSLog(@"UITableViewCellEditingStyleDelete,%@",indexPath);
        
        ZHNote *note = self.dataArr[indexPath.row];
        
        //01.从数据源中删除
        [self.dataArr removeObjectAtIndex:indexPath.row];
        
        //02.从tableView中删除
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        // !!!!!! 一定是上面这种顺序，先删数据源，再删cell，不然会崩
        
        //03.从磁盘删除
        [ZHDataUtil removeNote:note];
}

#pragma mark - 置顶按钮点击
- (void)tableViewCellDidClickStick:(ZHMultiButtonTableViewCell *)tableViewCell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tableViewCell];
    NSLog(@"置置置置置置置置顶%d",indexPath.row);
}

#pragma mark - detail note view controller Delegate

#pragma mark - 点击了删除按钮
- (void)detailNoteViewController:(ZHDetailNoteViewController *)dnvc DidClickDeleteItemWithNote:(ZHNote *)note latestNote:(ZHNote *)latestNote
{
    //删除这两个note
    if (note) [self.dataArr removeObject:note];
    if (latestNote) [self.dataArr removeObject:latestNote];
    
    [self.tableView reloadData];
    
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:ZHNoteDataSourceDidChangeNotification object:nil]];
}

#pragma mark - detail note view controller Data Source

#pragma mark - 下一条笔记
- (ZHNote *)detailNoteViewController:(ZHDetailNoteViewController *)dnvc nextNoteForNote:(ZHNote *)currentNote
{
    NSArray *targetArr = self.dataArr;
    
    if (self.search.isEditing) targetArr = self.searchResultArr;
    
    if (currentNote == [targetArr lastObject])return nil;
    
    NSInteger currentIndex = [targetArr indexOfObject:currentNote];
    
    return targetArr[currentIndex + 1];
}

#pragma mark - 上一条笔记
- (ZHNote *)detailNoteViewController:(ZHDetailNoteViewController *)dnvc previousNoteForNote:(ZHNote *)currentNote
{
    NSArray *targetArr = self.dataArr;
    
    if (self.search.isEditing) targetArr = self.searchResultArr;
    
    if (currentNote == [targetArr firstObject])return nil;
    
    NSInteger currentIndex = [targetArr indexOfObject:currentNote];
    
    return targetArr[currentIndex - 1];
}

#pragma mark - 是否为最上面一条笔记
- (BOOL)detailNoteViewController:(ZHDetailNoteViewController *)dnvc isNoteTopNote:(ZHNote *)note
{
    NSArray *targetArr = self.dataArr;
    
    if (self.search.isEditing) targetArr = self.searchResultArr;
    
    if (!targetArr.count) return YES;//没有数据，则就是最上面一条
    return (note == [targetArr firstObject]);
}

#pragma mark - 是否为最下面一条笔记
- (BOOL)detailNoteViewController:(ZHDetailNoteViewController *)dnvc isNoteBottomNote:(ZHNote *)note
{
    NSArray *targetArr = self.dataArr;
    
    if (self.search.isEditing) targetArr = self.searchResultArr;
    
    if (!targetArr.count) return YES;//没有数据，则就是最下面一条
    return (note == [targetArr lastObject]);
}

#pragma mark - new ViewController Delegate

- (void)newViewController:(ZHNewViewController *)newViewController didClickBackBtnWithNewNote:(ZHNote *)note
{
    //01.添加新模型
    if (note) [self.dataArr insertObject:note atIndex:0];
    
    //02.更新表格视图
    [self.tableView reloadData];
    
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:ZHNoteDataSourceDidChangeNotification object:nil]];
}

- (void)newViewController:(ZHNewViewController *)newViewController didClickDeleteItemWithLatestNote:(ZHNote *)latestNote
{
    if (latestNote) [self.dataArr removeObject:latestNote];
    [self.tableView reloadData];
    
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:ZHNoteDataSourceDidChangeNotification object:nil]];
}

#pragma mark - Scan Edit ViewController Delegate
- (void)scanEditViewController:(ZHScanEditViewController *)sevc didClickBackBtnWithNote:(ZHNote *)note lastestNote:(ZHNote *)lastestNote
{
    //01.删除旧模型
    [self.dataArr removeObject:note];
    
    //02.添加新模型
    if (lastestNote) [self.dataArr insertObject:lastestNote atIndex:0];
    
    //03.更新表格视图
    [self.tableView reloadData];
    
    //04.告诉搜索模型，note数据源改了
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:ZHNoteDataSourceDidChangeNotification object:nil]];
}

#pragma mark - ZHSearchDelegate

#pragma mark - 返回新的搜索结果数据源
- (NSMutableArray *)search:(ZHSearch *)search shouldReloadTableForSearchString:(NSString *)searchString dataSource:(NSMutableArray *)dataSource
{
    self.searchResultArr = [self updateResultDataSourceForSearchText:searchString];
    
    return self.searchResultArr;
}

#pragma mark - 此方法不是ZHSearch的代理方法，只是服务于代理而已
-(NSMutableArray *)updateResultDataSourceForSearchText:(NSString*)searchText
{
    NSMutableArray *tempResults = [NSMutableArray array];
    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
    
    for (int i = 0; i < self.dataArr.count; i++) {
        ZHNote *note = self.dataArr[i];
        NSString *storeString = [NSString stringWithFormat:@"%@ %@",note.title,note.content];
        NSRange storeRange = NSMakeRange(0, storeString.length);
        NSRange foundRange = [storeString rangeOfString:searchText options:searchOptions range:storeRange];
        if (foundRange.length) {
            [tempResults addObject:note];
        }
    }
    
    return tempResults;
}

#pragma mark - 搜索结果表格某一行被点击
- (void)search:(ZHSearch *)search didSelectTableView:(UITableView *)tableView RowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取数据
    ZHNote *note = self.searchResultArr[indexPath.row];
    
    //创建控制器
    ZHScanEditViewController *dvc = [[ZHScanEditViewController alloc] init];
    dvc.note = note;
    dvc.delegate = self;
    dvc.dataSource = self;
    //跳转
    [self.navigationController pushViewController:dvc animated:YES];
}



#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%@ dealloc",[self class]);
}

@end








