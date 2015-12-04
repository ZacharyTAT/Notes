//
//  ZHTableViewController.m
//  Notes
//
//  Created by apple on 12/1/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import "ZHTableViewController.h"
#import "ZHDetailViewController.h"

#import "ZHNoteCell.h"
#import "ZHNote.h"



@interface ZHTableViewController ()

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


- (NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    
        for (int  i = 0; i < 20; i++) {
            NSString *title = [NSString stringWithFormat:@"%02dtitletitletitletitletitletitletitletitle",i];
            NSString *content = [NSString stringWithFormat:@"content%@",title];
            ZHNote *note = [[ZHNote alloc] initWithTitle:title modifydate:[NSDate date] content:content];
            [_dataArr addObject:note];
        }
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
    ZHDetailViewController *dvc = [[ZHDetailViewController alloc] init];
    dvc.content = [NSString stringWithFormat:@"%@---%@",note.modifydate,note.content];
    [self.navigationController pushViewController:dvc animated:YES];
}

@end








