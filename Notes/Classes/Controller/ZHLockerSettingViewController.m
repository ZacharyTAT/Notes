//
//  ZHLockerSettingViewController.m
//  Notes
//
//  Created by apple on 3/28/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "ZHLockerSettingViewController.h"

#import "ZHLockerView.h"
#import "ZHTipLabel.h"

//导航栏标题
#define LOCKER_VIEW_CONTROLLER_NAV_TITLE NSLocalizedStringFromTable(@"LOCKER_VIEW_CONTROLLER_NAV_TITLE", @"ZHLockerSettingViewController", @"设置手势密码")
//
#define LOCKER_VIEW_CONTROLLER_DRAW_PATTERN NSLocalizedStringFromTable(@"LOCKER_VIEW_CONTROLLER_DRAW_PATTERN", @"ZHLockerSettingViewController", @"请绘制手势密码")
//
#define LOCKER_VIEW_CONTROLLER_ATLEAST_FOUR NSLocalizedStringFromTable(@"LOCKER_VIEW_CONTROLLER_ATLEAST_FOUR", @"ZHLockerSettingViewController", @"请至少连接4个点")
//
#define LOCKER_VIEW_CONTROLLER_DRAW_AGAIN NSLocalizedStringFromTable(@"LOCKER_VIEW_CONTROLLER_DRAW_AGAIN", @"ZHLockerSettingViewController", @"请再次绘制手势密码")
//
#define LOCKER_VIEW_CONTROLLER_SUCCESS NSLocalizedStringFromTable(@"LOCKER_VIEW_CONTROLLER_SUCCESS", @"ZHLockerSettingViewController", @"设置成功")
//
#define LOCKER_VIEW_CONTROLLER_NO_SAME NSLocalizedStringFromTable(@"LOCKER_VIEW_CONTROLLER_NO_SAME", @"ZHLockerSettingViewController", @"两次绘制的图案不一致，请重新绘制")

@interface ZHLockerSettingViewController ()<ZHLockerViewDelegate>

/** 提示标签 */
@property (nonatomic, weak)ZHTipLabel *tipLbl;

/** 记录这是第几次绘制手势，因为还要验证 */
@property (nonatomic, assign)NSInteger count;

/** 第一次绘制的密码 */
@property (nonatomic, copy)NSString *firstPassword;

@end

@implementation ZHLockerSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = LOCKER_VIEW_CONTROLLER_NAV_TITLE;//@"设置手势密码";
    [self setup];
}

- (void)setup
{
    //01.背景
    [self setupBackGroundView];
    
    //02.lockerView
    [self setupLockerView];
    
    //03.提示文字
    [self setupResultLbl];
}

/**
 *  初始化背景视图
 */
- (void)setupBackGroundView
{
    /*
    UIImageView *backView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Home_refresh_bg"]];
    
    backView.frame = self.view.bounds;
    
    [self.view addSubview:backView];
     */
    self.view.backgroundColor = ZHColor(233, 233, 233);
}

/**
 *  初始化手势解锁视图
 */
- (void)setupLockerView
{
    ZHLockerView *lockerView = [[ZHLockerView alloc] init];
    
    CGFloat marginBottom = 50; //和底部的间距
    
    CGFloat lockerViewX = 20;
    CGFloat lockerViewY = 150;
    CGFloat lockerViewW = self.view.frame.size.width - 2 * lockerViewX;
    CGFloat lockerViewH = self.view.frame.size.height - lockerViewY - marginBottom;
    
    lockerView.frame = CGRectMake(lockerViewX, lockerViewY, lockerViewW, lockerViewH);
    
    [self.view addSubview:lockerView];
    
    lockerView.delegate = self;
}

/**
 *  初始化密码错误提示标签
 */
- (void)setupResultLbl
{
    ZHTipLabel *lbl = [[ZHTipLabel alloc] init];
    self.tipLbl = lbl;
    lbl.frame = CGRectMake(0, 100, self.view.frame.size.width, 30);
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont systemFontOfSize:15.0];
    lbl.text = LOCKER_VIEW_CONTROLLER_DRAW_PATTERN; //@"请绘制手势密码";
    [self.view addSubview:lbl];
}

#pragma mark - ZHLockerView Delegate

- (BOOL)lockerView:(ZHLockerView *)lockerView isPswdOK:(NSString *)password
{
    if (self.count == 0) { //第一次绘制
        
        if ([password length] <= 3) {//密码长度至少4位
            [self.tipLbl showWarningTip:LOCKER_VIEW_CONTROLLER_ATLEAST_FOUR /*@"请至少连接4个点"*/];
            return NO;
        }
        
        self.firstPassword = password;
        self.count += 1;
        
        //显示提示信息
        [self.tipLbl showNormalTip:LOCKER_VIEW_CONTROLLER_DRAW_AGAIN /*@"请再次绘制手势密码"*/];
        
        return YES;
    }else{ //第二次绘制
        if ([self.firstPassword isEqualToString:password]) {
            
            //显示提示信息
            [self.tipLbl showNormalTip:LOCKER_VIEW_CONTROLLER_SUCCESS /*@"设置成功"*/];
            
            //告诉代理，密码设置成功啦
            if ([self.delegate respondsToSelector:@selector(lockerSettingViewController:successToSetPassword:)]) {
                [self.delegate lockerSettingViewController:self successToSetPassword:password];
            }
            
            return YES;
        }else{//第一次密码和第二次密码不一致
            self.count = 0;
            
            //显示提示信息
            [self.tipLbl showWarningTip:LOCKER_VIEW_CONTROLLER_NO_SAME /*@"两次绘制的图案不一致，请重新绘制"*/];
            
            return NO;
        }
    }
}

- (void)dealloc
{
    NSLog(@"%@ dealloc",[self class]);
}



@end
