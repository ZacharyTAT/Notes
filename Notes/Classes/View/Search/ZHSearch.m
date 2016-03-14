//
//  ZHSearch.m
//  Notes
//
//  Created by apple on 12/15/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import "ZHSearch.h"
#import "ZHSearchBar.h"
#import "ZHNote.h"
#import "ZHNoteCell.h"
#import "ZHDataUtil.h"

@interface ZHSearch()<UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate,ZHMultiButtonTableViewCellDelegate>


/** 记录搜索栏的背景视图 */
@property(nonatomic,weak)UIView *searchBarBackgroundView;

/** 没有结果时，显示在tableView上面的字符串，默认是"没有结果" */
@property(nonatomic,copy)NSString *noResultsText;

/** 搜索栏上的文本框 */
@property(nonatomic,weak)UITextField *textField;

@end

@implementation ZHSearch

- (instancetype)initWithcontentController:(UIViewController *)contentController dataSource:(NSMutableArray *)dataSource
{
    if (self = [super init]) {
        //01.搜索栏
        [self setupSearchBar];
        
        //02.DisplayController
        [self setupDisplayControllerWithContentController:contentController];
        
        //03.dataSource
        self.dataSource = dataSource;
    }
    return self;
}

#pragma mark - 外界内容改变了
- (void)noteDataSourceDidChange
{
    BOOL should = [self searchDisplayController:self.sdc shouldReloadTableForSearchString:self.textField.text];
    if (should) {
        [self.sdc.searchResultsTableView reloadData];
    }
}
#pragma mark - 初始化DisplayController
/**
 *  初始化DisplayController
 */
- (void)setupDisplayControllerWithContentController:(UIViewController *)contentController
{
    UISearchDisplayController *sdc = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:contentController];
    
    //01.代理
    sdc.delegate = self;
    
    //02.搜索结果(表格)数据源
    sdc.searchResultsDataSource = self;
    
    //03.搜索结果(表格)代理
    sdc.searchResultsDelegate = self;
    
    //04.不显示空白的cell
    sdc.searchResultsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //05.没有结果时显示的字符串
//    self.noResultsText = @"啊啊啊啊";
    
    self.sdc = sdc;
}

#pragma mark - 初始化搜索栏
/**
 *  初始化搜索栏
 */
- (void)setupSearchBar
{
    ZHSearchBar *searchBar = [[ZHSearchBar alloc] init];
    self.searchBar = searchBar;
    [searchBar sizeToFit];
    
    //01.代理
    searchBar.delegate = self;
    
    //02.未开始编辑时显示的占位文字
    searchBar.placeholder = @"搜索";
//    [ZHHierarchy processWithView:searchBar];
    //03.隐藏背景视图 & 设置文本框的背景色
    UIView *fatherView = searchBar.subviews[0];
    for (UIView *subView in [fatherView subviews]) {
        if ([subView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            
            UIView *searchBarBackgroundView = [[UIView alloc] initWithFrame:subView.frame];
            self.searchBarBackgroundView = searchBarBackgroundView;
            searchBarBackgroundView.backgroundColor = [UIColor whiteColor];
            [fatherView addSubview:searchBarBackgroundView];
            [subView removeFromSuperview];
            
        }else if ([subView isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
            UITextField *textField = (UITextField *)subView;
            textField.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1.0];
            [fatherView bringSubviewToFront:subView];
            
            self.textField = textField;
        }
    }
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"INITException" reason:@"不能调用此init方法，需要调用指定init方法--initWithcontentController:dataSource:" userInfo:nil];
}



#pragma mark - tableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //01.创建cell
    ZHNoteCell *cell = [ZHNoteCell noteCellWithTableView:tableView];
    
    cell.cellDelegate = self;
    
    //02.给cell传递模型，设置cell数据
    cell.note = self.dataSource[indexPath.row];
    
    
    //03.返回cell
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



#pragma mark - tableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noteDataSourceDidChange) name:ZHNoteDataSourceDidChangeNotification object:nil];
    
    //告诉代理，哪一行被点了，并将模型传过去
    if ([self.delegate respondsToSelector:@selector(search:didSelectTableView:RowAtIndexPath:)]) {
        [self.delegate search:self didSelectTableView:tableView RowAtIndexPath:indexPath];
    }
}
#pragma mark - ZHMultiButtonTableViewCellDelegate

#pragma mark - 删除按钮点击
- (void)tableViewCellDidClickDelete:(ZHMultiButtonTableViewCell *)tableViewCell
{
    NSIndexPath *indexPath = [self.sdc.searchResultsTableView indexPathForCell:tableViewCell];
    NSLog(@"%d",indexPath.row);
    
    NSLog(@"UITableViewCellEditingStyleDelete,%@",indexPath);
    
    ZHNote *note = self.dataSource[indexPath.row];
    
    //01.从数据源中删除
    //        [self.dataArr removeObjectAtIndex:indexPath.row];
    [self.dataSource removeObjectAtIndex:indexPath.row];
    
    //02.从tableView中删除
    [self.sdc.searchResultsTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    // !!!!!! 一定是上面这种顺序，先删数据源，再删cell，不然会崩
    
    //03.通知代理
    if ([self.delegate respondsToSelector:@selector(search:didDeleteRowWithNote:)]) {
        [self.delegate search:self didDeleteRowWithNote:note];
    }
}

#pragma mark - 置顶按钮点击
- (void)tableViewCellDidClickStick:(ZHMultiButtonTableViewCell *)tableViewCell
{
    UITableView *tableView = self.sdc.searchResultsTableView;
    //01.表格先取消编辑状态
    [tableView setEditing:NO animated:NO];
    
    //02.获取模型
    NSIndexPath *indexPath = [tableView indexPathForCell:tableViewCell];
    NSLog(@"置置置置置置置置顶%d",indexPath.row);
    
    ZHNote *stickNote = self.dataSource[indexPath.row];
    
    //03.修改置顶标志
    stickNote.stick = YES;
    
    //04.原地删除(由于还会插入，所以总数不变，不需要更新标题)
    //数据源
    [self.dataSource removeObjectAtIndex:indexPath.row];
    //表格
    [tableView deleteRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationLeft];
    
    //05.顶部插入
    [self.dataSource insertObject:stickNote atIndex:0];
    [tableView insertRowsAtIndexPaths:@[
                                             [NSIndexPath indexPathForRow:0 inSection:0]
                                             ]
                          withRowAnimation:UITableViewRowAnimationRight];
    //06.通知代理
    if ([self.delegate respondsToSelector:@selector(search:didStickRowWithNote:)]) {
        [self.delegate search:self didStickRowWithNote:stickNote];
    }
}

#pragma mark - 取消置顶按钮点击
- (void)tableViewCellDidCancelStick:(ZHMultiButtonTableViewCell *)tableViewCell
{
    UITableView *tableView = self.sdc.searchResultsTableView;
    //01.表格先取消编辑状态
    [tableView setEditing:NO animated:NO];
    
    //02.获取模型
    NSIndexPath *indexPath = [tableView indexPathForCell:tableViewCell];
    NSLog(@"取消置置置置置置置置顶%d",indexPath.row);
    ZHNote *cancelStickNote = self.dataSource[indexPath.row];
    
    //03.修改置顶标志
    cancelStickNote.stick = NO;
    
    //04.原地删除(由于还会插入，所以总数不变，不需要更新标题)
    //数据源
    [self.dataSource removeObjectAtIndex:indexPath.row];
    //表格
    [tableView deleteRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationRight];
    
    //---------从这里开始就和置顶不同了
    
    //查询该条记录的下一条未置顶的记录
    ZHNote *nextNote = [ZHDataUtil nextNoteForNoteId:cancelStickNote.noteId stick:NO];
    
    ZHNote *nextNoteInDataSource = [self nextNonStickNoteInArr:self.dataSource fromNoteId:nextNote.noteId];
    
    //05.插入到下一条记录之前
    if (nextNoteInDataSource) {
        
        NSUInteger nextNoteIndex = [self indexOfNoteInDataArr:nextNoteInDataSource];
        [self.dataSource insertObject:cancelStickNote atIndex:nextNoteIndex];
        [tableView insertRowsAtIndexPaths:@[
                        [NSIndexPath indexPathForRow:nextNoteIndex inSection:0]
                                                 ]
                         withRowAnimation:UITableViewRowAnimationLeft];
    }else{ //没有下一条，插入到最后
        
        [self.dataSource addObject:cancelStickNote];
        [tableView insertRowsAtIndexPaths:@[
            [NSIndexPath indexPathForRow:(self.dataSource.count - 1) inSection:0]
                                                 ]
                        withRowAnimation:UITableViewRowAnimationLeft];
    }
    
    //06.通知代理
    if ([self.delegate respondsToSelector:@selector(search:didCancelStickRowWithNote:)]) {
        [self.delegate search:self didCancelStickRowWithNote:cancelStickNote];
    }
}

/**
 *  查找指定note在数据源中的索引
 */
- (NSUInteger)indexOfNoteInDataArr:(ZHNote *)noteToFind
{
    for (int i = 0; i < self.dataSource.count; i++) {
        ZHNote *note = self.dataSource[i];
        if (note.noteId == noteToFind.noteId) return i;
    }
    
    return NSNotFound;
}

/**
 *  查找在指定数组中，相对某记录id的非置顶项
 *
 *  @param noteId 从这个id往后找
 */
- (ZHNote *)nextNonStickNoteInArr:(NSMutableArray *)arr fromNoteId:(NSUInteger)noteId
{
    for (ZHNote *note in arr) {
        if (!note.isStick && note.noteId <= noteId) return note;
    }
    
    return nil;
}
#pragma mark - UISearchBar delegate

#pragma mark - 决定是否可开始编辑，一般用于开始编辑前做一些事情
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    self.editing = YES;
    //调整背景视图尺寸,使之伸长20高度，进入状态栏区域，若考虑屏幕适配，则要进行判断
    [self changeSearchBarBackgroundViewFrame:YES];
    
    return YES;
}

#pragma mark - 根据需要更改背景视图的高度和位置
- (void)changeSearchBarBackgroundViewFrame:(BOOL)stretch
{
    CGRect frame = self.searchBarBackgroundView.frame;
    if (stretch) {
        frame.origin.y -= 20;
        frame.size.height += 20;
    }else{
        frame.origin.y += 20;
        frame.size.height -= 20;
    }
    
    self.searchBarBackgroundView.frame = frame;
}


#pragma mark - 点击了搜索框中的取消按钮
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    NSLog(@"searchBarCancelButtonClicked...");
    [searchBar endEditing:YES];
    self.editing = NO;
    searchBar.showsCancelButton = NO;
    [self changeSearchBarBackgroundViewFrame:NO];
    
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UISearchDisplayController delegate

#pragma mark - 搜索框文字改变即调用此方法，传入新的搜索关键词，一般在此方法里更新搜索的数据源
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    //询问代理要新的数据源
    if ([self.delegate respondsToSelector:@selector(search:shouldReloadTableForSearchString:dataSource:)]) {
        self.dataSource = [self.delegate search:self shouldReloadTableForSearchString:searchString dataSource:self.dataSource];
        
        //这里不能写判断数据源为空的语句，否则当第一次有数据，第二次没有数据时，tableView中的
        //UILabel会被移除掉，而无论第一次是否有数据，UILabel都在
        //若是在为性能着想，则应该加一个标志位，若此函数第一次调用，则执行下列for循环操作
        //否则不执行
        for (UIView *subView in controller.searchResultsTableView.subviews) {
            if ([subView isKindOfClass:[UILabel class]]) {
                UILabel *label = (UILabel *)subView;
                if (self.noResultsText)
                    label.text = self.noResultsText;
                else
                    label.text = @"没有结果";
                break;
            }
        }
        
        return YES;
    }
    NSLog(@"代理没有实现该方法...");
    return NO;
}

- (void)dealloc
{
    NSLog(@"%@",[self class]);
    
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end















