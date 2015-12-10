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



@interface ZHTableViewController ()<ZHNewViewControllerDelegate>

@property (nonatomic, strong)NSMutableArray *dataArr;

@end

@implementation ZHTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"table view did load");
    [self setupNavItem];
    //去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - 数据源
/**
 *  数据源
 */
- (NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
        
        //从document中加载数据
        
        //01.获取文件列表
        NSString *docPath = ZHDocumentPath;
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSArray *lists = [fileMgr contentsOfDirectoryAtPath:docPath error:nil];
        
        //02.转模型后存入数组
        for (int i = 0; i < lists.count; i++) {
            //02-1.获取文件决定路径(包括文件名)
            NSString *filePath = [docPath stringByAppendingPathComponent:lists[i]];
            
            //02-2.转化为模型
            ZHNote *note = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
            
            //02-3.存入对象
            [_dataArr addObject:note];
        }
        
        //更新表格数据
        [self.tableView reloadData];
    }
    
    return _dataArr;
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
    [self.navigationController pushViewController:newVC animated:animated];
}

#pragma mark - table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //01.创建cell
    ZHNoteCell *cell = [ZHNoteCell noteCellWithTableView:tableView];
    
    //02.给cell传递模型，设置cell数据
    cell.note = self.dataArr[indexPath.row];
    
    //03.返回cell
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //获取数据
    ZHNote *note = self.dataArr[indexPath.row];
    ZHScanEditViewController *dvc = [[ZHScanEditViewController alloc] init];
    dvc.note = note;
    dvc.delegate = self;
    [self.navigationController pushViewController:dvc animated:YES];
}

#pragma mark - new ViewController Delegate
- (void)newViewController:(ZHNewViewController *)newViewController didClickBackBtnWithNewNote:(ZHNote *)note
{
    //01.添加新模型
    if (note) [self.dataArr insertObject:note atIndex:0];
    
    //02.更新表格视图
    [self.tableView reloadData];
}

- (void)newViewController:(ZHNewViewController *)newViewController didClickDeleteItemWithLatestNote:(ZHNote *)latestNote
{
    if (latestNote) [self.dataArr removeObject:latestNote];
    [self.tableView reloadData];
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
}


- (void)dealloc
{
    NSLog(@"%@ dealloc",[self class]);
}

@end








