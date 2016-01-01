//
//  ZHNoteCell.m
//  Notes
//
//  Created by apple on 12/1/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import "ZHNoteCell.h"
#import "ZHNote.h"
#import "NSDate+ZH.h"

#define kTitleLblRatio 0.7
#define kTitleDateMargin 9

@interface ZHNoteCell()

/** 显示标题的标签 */
@property (nonatomic, weak)UILabel *titleLbl;

/** 显示时间的标签 */
@property (nonatomic, weak)UILabel *modifydateLbl;

/** 分割线 */
@property (nonatomic, weak)UIView *separator;

/** 时间标签显示文字 */
@property (nonatomic,copy)NSString *modifydateLblText;

/** 记录cell中的唯一子视图 */
@property (nonatomic,weak)UIView *cellScrollView;

@end

@implementation ZHNoteCell

@synthesize note = _note;


#pragma mark - cell的构造方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}


#pragma mark - 快速创建cell的类方法
+ (instancetype)noteCellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"cellID";
    ZHNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[ZHNoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    //01.设置cell选中时的背景色
    UIView *selectedView = [[UIView alloc] init];
    selectedView.backgroundColor = [UIColor colorWithRed:252/255.0 green:206/255.0 blue:37/255.0 alpha:1.0];
    cell.selectedBackgroundView = selectedView;
    
    //02.最右边有个箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
}

#pragma mark - Properties
- (void)setNote:(ZHNote *)note
{
    _note = note;
    
    _titleLbl.text = note.title;
//    _modifydateLbl.text = self.modifydateLblText;
    _modifydateLbl.text = [note.modifydate toDisplayString]; //为什么不这么写，看下面
    //好吧，打脸了，如果按下面这种方式，编辑笔记然后返回时，cell上的时间不会刷新
    
//    if (note.isStick) { //是置顶项，则背景色为灰色
//        self.backgroundColor = ZHColor(174, 194, 156);
//    }else{ //考虑cell的循环利用，当不是置顶项时，要设置回来
//        self.backgroundColor = [UIColor whiteColor];
//    }
}

/**
 *  由于setNote:方法在cell滚动时，不断被调用
 *  这也导致了toDisplayString方法不断调用，不断计算日期字符串
 *  而事实上，只需要计算一次，所以用这个属性记录下来，后面就不需要计算
 */
- (NSString *)modifydateLblText
{
    if (_modifydateLblText == nil) {
        _modifydateLblText = [self.note.modifydate toDisplayString];
    }
    
    return _modifydateLblText;
}

#pragma mark - layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.contentView.frame.size.width - 10;
    CGFloat height = self.contentView.frame.size.height;
    
    //标题标签
    CGFloat titleLblX = 10;
    CGFloat titleLblY = 0;
    CGFloat titleLblW = width * kTitleLblRatio;
    CGFloat titleLblH = height;
    self.titleLbl.frame = CGRectMake(titleLblX, titleLblY, titleLblW, titleLblH);
    
    //修改日期标签
    CGFloat modifydateLblX = CGRectGetMaxX(self.titleLbl.frame) + kTitleDateMargin;
    CGFloat modifydateLblY = 0;
    CGFloat modifydateLblW = width * (1 - kTitleLblRatio) - kTitleDateMargin;
    CGFloat modifydateLblH = height;
    self.modifydateLbl.frame = CGRectMake(modifydateLblX, modifydateLblY, modifydateLblW, modifydateLblH);
    
    //分割线
    CGFloat separatorX = 5;
    CGFloat separatorH = 1;
    CGFloat separatorY = CGRectGetMaxY(self.contentView.frame) - 1;
    CGFloat separatorW = self.frame.size.width - separatorX - 2;
    self.separator.frame = CGRectMake(separatorX, separatorY, separatorW, separatorH);
    
    
}

#pragma mark - 添加子控件
/** 添加子控件 */
- (void)setupViews
{
    //标题
    UILabel *titleLbl = [[UILabel alloc] init];
    self.titleLbl = titleLbl;
    [self.contentView addSubview:titleLbl];
    
    //修改日期
    UILabel *modifydateLbl = [[UILabel alloc] init];
    self.modifydateLbl = modifydateLbl;
    modifydateLbl.textAlignment = NSTextAlignmentRight; //右对齐
//    modifydateLbl.backgroundColor = [UIColor cyanColor];
    [self.contentView addSubview:modifydateLbl];
    
    //分割线
    UIView *separator = [[UIView alloc] init];
    self.separator = separator;
    [self.cellScrollView addSubview:separator];
    separator.backgroundColor = [UIColor lightGrayColor];
}


@end









