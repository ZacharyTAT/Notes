//
//  ZHDetailNoteViewController.m
//  Notes
//
//  Created by apple on 12/24/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//  具体一条笔记的通用控制器，作为父类而存在

#import "ZHDetailNoteViewController.h"
#import <objc/message.h>

#import "ZHPageBottomBar.h"
#import "ZHBottomBar.h"
#import "ZHNote.h"

#import "NSDate+ZH.h"
#import "NSString+ZH.h"
#import "ZHKeyboardJudge.h"
#import "ZHDataUtil.h"
#import "ZHLocker.h"


#define DETAIL_NOTE_VIEW_CONTROLLER_NAV_BACK NSLocalizedStringFromTable(@"DETAIL_NOTE_VIEW_CONTROLLER_NAV_BACK", @"ZHDetailNoteViewController", @"返回")
#define DETAIL_NOTE_VIEW_CONTROLLER_NAV_DONE NSLocalizedStringFromTable(@"DETAIL_NOTE_VIEW_CONTROLLER_NAV_DONE", @"ZHDetailNoteViewController", @"完成")
#define DETAIL_NOTE_VIEW_CONTROLLER_ACTIONSHEET_CANCEL NSLocalizedStringFromTable(@"DETAIL_NOTE_VIEW_CONTROLLER_ACTIONSHEET_CANCEL", @"ZHDetailNoteViewController", @"取消")
#define DETAIL_NOTE_VIEW_CONTROLLER_ACTIONSHEET_DELETE NSLocalizedStringFromTable(@"DETAIL_NOTE_VIEW_CONTROLLER_ACTIONSHEET_DELETE", @"ZHDetailNoteViewController", @"删除笔记")
#define DETAIL_NOTE_VIEW_CONTROLLER_VERIFY_TITLE NSLocalizedStringFromTable(@"DETAIL_NOTE_VIEW_CONTROLLER_VERIFY_TITLE", @"ZHDetailNoteViewController", @"请输入解锁手势")
#define DETAIL_NOTE_VIEW_CONTROLLER_PUBLIC NSLocalizedStringFromTable(@"DETAIL_NOTE_VIEW_CONTROLLER_PUBLIC", @"ZHDetailNoteViewController", @"公开")
#define DETAIL_NOTE_VIEW_CONTROLLER_PRIVATE NSLocalizedStringFromTable(@"DETAIL_NOTE_VIEW_CONTROLLER_PRIVATE", @"ZHDetailNoteViewController", @"加密")

@interface ZHDetailNoteViewController ()<UIActionSheetDelegate,ZHBottomBarDelegate>

/** 展示笔记内容的文本框 */
@property (nonatomic, weak) ZHTextView *textView;

/** 底部工具条 */
@property (nonatomic, weak) ZHBottomBar *bottomBar;

/** 权限按钮 */
@property (nonatomic, strong) UIBarButtonItem *authorityBtn;

/** 记录文本是否修改过 */
@property (nonatomic, assign,getter = isTextViewChanged)BOOL textViewChanged;

/** 记录最新的一条笔记记录 */
@property(nonatomic, strong)ZHNote *latestNote;


@end

@implementation ZHDetailNoteViewController

#pragma mark - Controller life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textViewChanged = NO;
    [self setupLeftNavItem];
    [self setupRightNavItem];
    [self setupSubViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"%@",self.note);
    //文字
    self.textView.text = self.note.content;
    //日期
    self.textView.modifydateLbl.text = [self.note.modifydate toLocaleString];
#warning label文字与正文间距相差有点大
    
    //设置textView的frame
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    CGFloat bottomBarX = 0;
    CGFloat bottomBarW = width;
    CGFloat bottomBarH = 44;
    CGFloat bottomBarY = height - bottomBarH;
    self.bottomBar.frame = CGRectMake(bottomBarX, bottomBarY, bottomBarW, bottomBarH);
    
    //上一页和下一页是否可用
    
    //上一页
    if ([self.dataSource respondsToSelector:@selector(detailNoteViewController:isNoteTopNote:)]) {
        if ([self.dataSource detailNoteViewController:self isNoteTopNote:self.note]) {//是最上面一条
            self.bottomBar.prePageItem.enabled = NO;
        }
    }
    //下一页
    if ([self.dataSource respondsToSelector:@selector(detailNoteViewController:isNoteBottomNote:)]) {
        if ([self.dataSource detailNoteViewController:self isNoteBottomNote:self.note]) { //是最下面一条
            self.bottomBar.nextPageItem.enabled = NO;
        }
    }
    
    //权限
    [self showAuthorityBtn];
}

#pragma mark - 更新UI，当模型改了之后更新信息
- (void)updateUIWithNote:(ZHNote *)note
{
    if ([self.delegate respondsToSelector:@selector(detailNoteViewController:DidChangeWithNote:)]) {
        [self.delegate detailNoteViewController:self DidChangeWithNote:note];
    }
    
}

#pragma mark - 初始化右边返回按钮
/**
 *  初始化右边返回按钮
 */
- (void)setupRightNavItem
{
    self.authorityBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:0 target:self action:@selector(authorityBtnClick:)];
    
}
#pragma mark - 初始化左边返回按钮
/**
 *  初始化左边返回按钮
 */
- (void)setupLeftNavItem
{
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:DETAIL_NOTE_VIEW_CONTROLLER_NAV_BACK //@"返回"
                                                                             style:0
                                                                            target:self
                                                                            action:@selector(backBtnClick)];
}

#pragma mark - 初始化所有子视图
/**
 *  初始化所有子视图
 */
- (void)setupSubViews
{
    // 01.添加文本框
    ZHTextView *textView = [[ZHTextView alloc] init];
    self.textView = textView;
    textView.frame = self.view.bounds;
    NSLog(@"%@",NSStringFromCGRect(textView.frame));
    [self.view addSubview:textView];
    //设置代理
    textView.delegate = self;
    //键盘弹出时，不会自动滚动
    textView.layoutManager.allowsNonContiguousLayout = NO;
    
    // 02.添加底部工具栏
    [self setupBottomBar];
}

#pragma mark - 设置底部工具条
- (void)setupBottomBar
{
    ZHBottomBar *bottomBar = [ZHPageBottomBar bottomBar];
    self.bottomBar = bottomBar;
    [self.view addSubview:bottomBar];
    //设置代理
    bottomBar.delegate = self;
}

#pragma mark - 保存数据
/**
 *  保存数据
 */
- (void)saveWithTitle:(NSString *)title
{
    BOOL stick = NO;
    BOOL lock = NO;
    //先删除之前的记录
    if (self.latestNote == nil) { //删除self.note
        stick = self.note.stick;
        lock = self.note.lock;
        [ZHDataUtil removeNote:self.note];
    }else{ //删除self.latestNote
        stick = self.latestNote.stick;
        lock = self.latestNote.lock;
        [ZHDataUtil removeNote:self.latestNote];
    }
    
    //00.建立note模型
    ZHNote *note = [[ZHNote alloc] initWithTitle:title modifydate:[NSDate date] content:self.textView.text stick:stick lock:lock];
    
    //01.先保存到磁盘，这样可以查询到id
    [ZHDataUtil saveWithNote:note];
    
    //02.保存到note属性中以备后用
    self.latestNote = note;
    
}

#pragma mark - UITextView delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:DETAIL_NOTE_VIEW_CONTROLLER_NAV_DONE //@"完成"
                                                                              style:0
                                                                             target:self
                                                                             action:@selector(doneBtnClick)];
    
    //修改frame和contentInset
    //[(ZHTextView *)textView changeFrameInset];
    
}
- (void)textViewDidBeginEditingAfterKeyboardTotallyShowUp:(UITextView *)textView
{
    //修改frame和contentInset
    [(ZHTextView *)textView changeFrameInset];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"end editing...");
    
    //还原frame和contentInset
    [(ZHTextView *)textView resetFrameInset];
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.textViewChanged = YES;
}

#pragma mark - BottomBar Delegate
- (void)bottomBar:(ZHBottomBar *)bottomBar didClickItem:(UIBarButtonItem *)barItem
{
    switch (barItem.tag) {
        case ZHBarItemShare: //分享按钮
            break;
            
        case ZHBarItemDelete:   //删除按钮
            [self deleteItemHandler];
            break;
            
        case ZHBarItemCreate:   //新建按钮
            [self createItemHandler];
            break;
            
        case ZHBarItemPrePage:   //上一页
            [self prePageitemHandler];
            break;
            
        case ZHBarItemNextPage:   //下一页
            [self nextPageitemHandler];
            break;
        
        default:
            break;
    }
}

#pragma mark - 底部工具栏各按钮点击事件

#pragma mark - 点击删除按钮
- (void)deleteItemHandler
{
    [[[UIActionSheet alloc] initWithTitle:nil
                                 delegate:self
                        cancelButtonTitle: DETAIL_NOTE_VIEW_CONTROLLER_ACTIONSHEET_CANCEL //@"取消"
                   destructiveButtonTitle:DETAIL_NOTE_VIEW_CONTROLLER_ACTIONSHEET_DELETE //@"删除笔记"
                        otherButtonTitles:nil, nil] showInView:self.view];
}

#pragma mark - 点击新建按钮
- (void)createItemHandler
{
    UINavigationController *nav = self.navigationController;
    
    //01.销毁当前控制器
    [self.navigationController popViewControllerAnimated:NO];
    
    //02.压入新建控制器
    objc_msgSend(nav.topViewController, @selector(newBtnWithAnimated:),NO);
}

#pragma mark - 点击上一页按钮
- (void)prePageitemHandler
{
    ZHNote *preNote = [self previousNote];
    if (preNote) { //不为空才更新
        [self changeNote:preNote];
    }
}
#pragma mark - 获取上一条记录
/**
 *  获取当前记录的上一条记录
 */
- (ZHNote *)previousNote
{
    ZHNote *preNote = nil;
    if ([self.dataSource respondsToSelector:@selector(detailNoteViewController:previousNoteForNote:)]) {
        ZHNote *currentNote = self.latestNote;
        if (currentNote == nil) {
            currentNote = self.note;
        }
        preNote = [self.dataSource detailNoteViewController:self previousNoteForNote:currentNote];
    }
    
    return preNote;
}

#pragma mark - 点击下一页按钮
- (void)nextPageitemHandler
{

    ZHNote *nextNote = [self nextNote];
    if (nextNote) {//不为空才更新
        [self changeNote:nextNote];
    }
}

#pragma mark - 获取当前记录的下一条记录
- (ZHNote *)nextNote
{
    ZHNote *nextNote = nil;
    if ([self.dataSource respondsToSelector:@selector(detailNoteViewController:nextNoteForNote:)]) {
        ZHNote *currentNote = self.latestNote;
        if (currentNote == nil) {
            currentNote = self.note;
        }
        nextNote = [self.dataSource detailNoteViewController:self nextNoteForNote:currentNote];
    }
    
    return nextNote;
}

- (void)changeNote:(ZHNote *)note
{
    __weak typeof(self) weakSelf = self;
    
    void (^doSame)() = ^{
        /*
        self.note = note;
        self.latestNote = nil;
        
        [self updateUI];
        */
        [weakSelf updateUIWithNote:note];
        NSLog(@"preNote = %@",note);
    };
    //更新模型
    if (note.isLock && kPasswordFromUserDefault) {
            __weak typeof(self) weakSelf = self;
            
            [ZHLocker verifyInViewControlloer:self
                                        title:DETAIL_NOTE_VIEW_CONTROLLER_VERIFY_TITLE //@"请输入解锁手势"
                            completionHandler:
             ^(ZHUnLockerViewController *ulvc, BOOL result) {
                
                [weakSelf dismissViewControllerAnimated:YES completion:NULL];
                
                if (result) {
                    doSame();
                }
             }];
            return;
    }
    doSame();
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) {//删除笔记并显示下一条
        
//        self.textView.text = @"";
//        self.textViewChanged = YES;
//        [self doneBtnClick];
        
        
        
        //00.删除之前，获取下一条
        
        ZHNote *nextNoteToDisplay = [self nextNote];
        if (nextNoteToDisplay == nil) {//下一条获取不到，可能当前条是最下面一条，所以就获取上一条
            nextNoteToDisplay = [self previousNote];
        }
        
        //01.删除
        //通知代理，从数据源中删除
        if ([self.delegate respondsToSelector:@selector(detailNoteViewController:DidClickDeleteItemWithNote:latestNote:)]) {
            [self.delegate detailNoteViewController:self DidClickDeleteItemWithNote:self.note latestNote:self.latestNote];
        }
        
        //从磁盘删除
        [ZHDataUtil removeNote:self.note];
        if (self.latestNote) [ZHDataUtil removeNote:self.latestNote];
        
        //02.显示下一条
        //nextNoteToDisplay为空，则说明全部删完了
        if (nextNoteToDisplay == nil) {//直接返回
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{//显示之
            [self updateUIWithNote:nextNoteToDisplay];
            
        }
    }
}


#pragma mark - 完成按钮点击事件
- (void)doneBtnClick
{
#warning 这个方法要留给子类去实现
}

#pragma mark - 显示权限按钮
- (void)showAuthorityBtn
{
    if (kPasswordFromUserDefault == nil) {
        self.navigationItem.rightBarButtonItem = nil;
        return;
    }
    ZHNote *note = self.note;
    
    if (self.latestNote) note = self.latestNote;
    
    NSString *btnTitle = note.isLock ? DETAIL_NOTE_VIEW_CONTROLLER_PUBLIC/*@"公开"*/ : DETAIL_NOTE_VIEW_CONTROLLER_PRIVATE/*@"加密"*/;
    
    [self.authorityBtn setTitle:btnTitle];
    
    self.navigationItem.rightBarButtonItem = self.authorityBtn;
    
}
#pragma mark - 权限按钮点击事件
- (void)authorityBtnClick:(UIBarButtonItem *)authorityBtn
{
    ZHNote *note = self.note;
    if (self.latestNote) note = self.latestNote;
    
    __weak typeof(self) weakSelf = self;
    
    void (^doSame)() = ^{
        
        note.lock = !note.lock;
        
        NSString *btnTitle = note.isLock ? DETAIL_NOTE_VIEW_CONTROLLER_PUBLIC/*@"公开"*/ : DETAIL_NOTE_VIEW_CONTROLLER_PRIVATE/*@"加密"*/;
        
        //01.更改标题
        [authorityBtn setTitle:btnTitle];
        
        //02.通知代理,更新表格视图，如果需要的话
        if ([weakSelf.delegate respondsToSelector:@selector(detailNoteViewController:DidChangeAuthority:)]) {
            [weakSelf.delegate detailNoteViewController:weakSelf DidChangeAuthority:note.lock];
        }
        
        //03.持久化
        [ZHDataUtil changeAuthorityIfLock:note.isLock forId:note.noteId];
    };
    
    if (note.isLock && kPasswordFromUserDefault) { //若是私密记录，将之公开，需要验证
            [ZHLocker verifyInViewControlloer:self
                                        title:DETAIL_NOTE_VIEW_CONTROLLER_VERIFY_TITLE //@"请输入解锁手势"
                            completionHandler:^(ZHUnLockerViewController *ulvc, BOOL result) {
                [weakSelf dismissViewControllerAnimated:YES completion:NULL];
                if (result) {
                    doSame();
                }
            }];
            return;
    }
    
    doSame();
}

#pragma mark - 返回按钮点击事件
- (void)backBtnClick
{
    NSLog(@"back button clicked...");
    
    if (!self.textViewChanged) { //没有更改文本,则直接返回
        NSLog(@"文本没有改变...");
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    NSLog(@"text changed...");
    
    //执行完成按钮的操作，这其中会更新lastest属性
    if ([[ZHKeyboardJudge judgeInstance] keyboardOpened]) { //键盘打开了，才要模拟完成按钮
        [self doneBtnClick];
    }
    
    
    //返回到上层
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)dealloc
{
    NSLog(@"%@ dealloc...",[self class]);
}

@end
