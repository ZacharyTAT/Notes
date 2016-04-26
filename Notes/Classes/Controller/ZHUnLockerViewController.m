//
//  ZHUnLockerViewController.m
//  Notes
//
//  Created by apple on 3/21/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "ZHUnLockerViewController.h"
#import "ZHLoginViewController.h"
#import "ZHNavigationController.h"

#import "ZHLockerView.h"
#import "ZHTipLabel.h"

#import "ZHUserTool.h"


//导航栏标题
#define UNLOCKER_VIEW_CONTROLLER_CANCEL NSLocalizedStringFromTable(@"UNLOCKER_VIEW_CONTROLLER_CANCEL", @"ZHUnLockerViewController", @"取消")
#define UNLOCKER_VIEW_CONTROLLER_FORGET NSLocalizedStringFromTable(@"UNLOCKER_VIEW_CONTROLLER_FORGET", @"ZHUnLockerViewController", @"忘记手势？")
#define UNLOCKER_VIEW_CONTROLLER_REMAIN_CHANCES NSLocalizedStringFromTable(@"UNLOCKER_VIEW_CONTROLLER_REMAIN_CHANCES", @"ZHUnLockerViewController", @"手势错误，还有%d次机会")
#define UNLOCKER_VIEW_CONTROLLER_INCORRECT NSLocalizedStringFromTable(@"UNLOCKER_VIEW_CONTROLLER_INCORRECT", @"ZHUnLockerViewController", @"手势错误，请重新输入")

@interface ZHUnLockerViewController ()<ZHLockerViewDelegate, ZHLoginViewControllerDelegate>

/** 错误提示文字标签 */
@property (nonatomic, weak)ZHTipLabel *resultLbl;

/** 忘记按钮 */
@property (nonatomic, weak)UIButton *forgetBtn;

/** 记录手势密码输入错误了几次 */
@property (nonatomic, assign)NSUInteger count;

@end

@implementation ZHUnLockerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self test];
    [self setup];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:UNLOCKER_VIEW_CONTROLLER_CANCEL //@"取消"
                                                                             style:0
                                                                            target:self
                                                                            action:@selector(cancel)];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //显示提示文字
    [self.resultLbl showNormalTip:self.tip];
    
    //登录了才显示 忘记手势 按钮
    self.forgetBtn.hidden = ![ZHUserTool isUserExists];
}

/**
 *  存储的正确密码
 */
- (NSString *)correctPswd
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kPasswordKey];
}

- (void)setup
{
    //01.背景
    [self setupBackGroundView];
    
    //02.lockerView
    [self setupLockerView];
    
    //03.提示文字
    [self setupResultLbl];
    
    //04.忘记手势按钮
    [self setupForgetBtn];
}


#pragma mark - 初始化背景视图
/**
 *  初始化背景视图
 */
- (void)setupBackGroundView
{
    self.view.backgroundColor = ZHColor(233, 233, 233);
}

#pragma mark - 初始化手势解锁视图
/**
 *  初始化手势解锁视图
 */
- (void)setupLockerView
{
    ZHLockerView *lockerView = [[ZHLockerView alloc] init];
    
    CGFloat marginBottom = 50;
    
    CGFloat lockerViewX = 20;
    CGFloat lockerViewY = 150;
    CGFloat lockerViewW = self.view.frame.size.width - lockerViewX * 2;
    CGFloat lockerViewH = self.view.frame.size.height - lockerViewY - marginBottom;
    
    lockerView.frame = CGRectMake(lockerViewX, lockerViewY, lockerViewW, lockerViewH);
    
    [self.view addSubview:lockerView];
    
    lockerView.delegate = self;
}

#pragma mark - 初始化密码错误提示标签
/**
 *  初始化密码错误提示标签
 */
- (void)setupResultLbl
{
    ZHTipLabel *lbl = [[ZHTipLabel alloc] init];
    self.resultLbl = lbl;
    lbl.frame = CGRectMake(0, 100, self.view.frame.size.width, 30);
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:lbl];
}

/**
 *  忘记手势按钮
 */
- (void)setupForgetBtn
{
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
//    forgetBtn.backgroundColor = [UIColor redColor];
    
    self.forgetBtn = forgetBtn;
    
    [self.view addSubview:forgetBtn];
    
    [forgetBtn setTitle:UNLOCKER_VIEW_CONTROLLER_FORGET /*@"忘记手势？"*/ forState:UIControlStateNormal];
    
    [forgetBtn addTarget:self action:@selector(forget) forControlEvents:UIControlEventTouchUpInside];
    
    forgetBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    
    [forgetBtn setTitleColor:ZHColor(10, 95, 255) forState:UIControlStateNormal];
    
    CGFloat marginBottom = 10;
    
    //样式
    CGFloat forgetBtnX = 80;
    CGFloat forgetBtnW = self.view.frame.size.width - 2 * forgetBtnX;
    CGFloat forgetBtnH = 20;
    CGFloat forgetBtnY = self.view.frame.size.height - marginBottom - forgetBtnH;
    
    forgetBtn.frame = CGRectMake(forgetBtnX, forgetBtnY, forgetBtnW, forgetBtnH);
}

- (void)forget
{
    NSLog(@"I forgot");
    
    //锁定
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kAppLocked];
    
    ZHLoginViewController *lvc = [[ZHLoginViewController alloc] init];
    lvc.delegate = self;
    lvc.hideSignupBtn = YES;
    [self presentViewController:[[ZHNavigationController alloc] initWithRootViewController:lvc] animated:NO completion:NULL];
}

/**
 *  密码正确
 */
- (void)success
{
    NSLog(@"SUCCESS");
    if (self.completionHander) self.completionHander(self, YES);
}

/**
 *  密码错误
 */
- (void)fail
{
    NSLog(@"FAIL");
//    self.completionHander(self, NO);
    //提示文字
//    self.resultLbl.text = @"密码错误，请重新输入";
    
    if ([ZHUserTool isUserExists]) { //登录了,则最多错5次
        if ((5 - self.count) > 1) {//还有机会
            
            self.count += 1;
            
            [self.resultLbl showWarningTip:[NSString stringWithFormat:UNLOCKER_VIEW_CONTROLLER_REMAIN_CHANCES /*@"手势错误，还有%d次机会"*/, 5 - self.count]];
        
        }else{//没有机会了,调到登录页面(按忘记密码处理)
        
            [self forget];
        
        }
    
    }else{//没有登录
    
        [self.resultLbl showWarningTip:UNLOCKER_VIEW_CONTROLLER_INCORRECT /*@"手势错误，请重新输入"*/];
    }
    
    
}

/**
 *  点击了取消
 */
- (void)cancel
{
    NSLog(@"Cancel");
    if (self.completionHander) self.completionHander(self, NO);
}

#pragma mark - ZHLockerViewDelegate

- (BOOL)lockerView:(ZHLockerView *)lockerView isPswdOK:(NSString *)password
{
    if ([[self correctPswd] isEqualToString:password]) {
        [self success];
        return YES;
    }
    [self fail];
    return NO;
}

#pragma mark - ZHLoginViewController Delegate
- (void)loginViewControllerDidSuccess:(ZHLoginViewController *)suvc
{
    [self dismissViewControllerAnimated:NO completion:NULL];
    
    [self success];
    
    //删除手势密码，因为已经忘记了
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kPasswordKey];
}

- (void)dealloc
{
    NSLog(@"%@ dealloc", [self class]);
}




@end
