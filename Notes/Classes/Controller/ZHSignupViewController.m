//
//  ZHSignupViewController.m
//  Notes
//
//  Created by apple on 4/15/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "ZHSignupViewController.h"

#import "ZHSignupView.h"

#import "ZHNetwork.h"
#import "MBProgressHUD+MJ.h"


//导航栏标题
#define SIGNUP_VIEW_CONTROLLER_NAV_TITLE NSLocalizedStringFromTable(@"SIGNUP_VIEW_CONTROLLER_NAV_TITLE", @"ZHSignupViewController", @"注册")
//
#define SIGNUP_VIEW_CONTROLLER_VERIFYING NSLocalizedStringFromTable(@"SIGNUP_VIEW_CONTROLLER_VERIFYING", @"ZHSignupViewController", @"正在验证")
//
#define SIGNUP_VIEW_CONTROLLER_USER_EXISTS NSLocalizedStringFromTable(@"SIGNUP_VIEW_CONTROLLER_USER_EXISTS", @"ZHSignupViewController", @"用户名已存在")
//
#define SIGNUP_VIEW_CONTROLLER_TOBE_REVIEWED NSLocalizedStringFromTable(@"SIGNUP_VIEW_CONTROLLER_TOBE_REVIEWED", @"ZHSignupViewController", @"注册成功，请等待审核")

@interface ZHSignupViewController ()<ZHSignupViewDelegate>

/** 注册视图 */
@property (nonatomic, weak)ZHSignupView *signupView;

@end

@implementation ZHSignupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = SIGNUP_VIEW_CONTROLLER_NAV_TITLE; //@"注册";
    [self setup];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.signupView userTxtFieldBecomeFirstResponder];
}
- (void)setup
{
    ZHSignupView *signupView = [[ZHSignupView alloc] init];
    self.signupView = signupView;
//    signupView.backgroundColor = [UIColor purpleColor];
    signupView.delegate = self;
    CGFloat loginViewX = 30;
    CGFloat loginViewY = 64 + 20;
    signupView.frame = CGRectMake(loginViewX, loginViewY, self.view.frame.size.width -  2 * loginViewX, 300);
    [self.view addSubview:signupView];
    
}

#pragma mark - ZHSignupView delegate


- (void)signupView:(ZHSignupView *)signupView didSignupWithUsername:(NSString *)username password:(NSString *)password
{
    NSLog(@"%@,%@",username ,password);
    
    __weak typeof(self) weakSelf = self;

        //发请求给服务器进行注册
        
    NSMutableDictionary *params = [@{} mutableCopy];
    params[@"username"] = username;
    params[@"password"] = password;
    
    [ZHNetwork post:[NSString stringWithFormat:@"%@/%@",ROOT ,@"register.php"]
            message:SIGNUP_VIEW_CONTROLLER_VERIFYING//@"正在验证"
compoundResponseSerialize:YES
         parameters:params
            success:^(NSString *responseString, id responseObject) {
                NSInteger result = [responseString integerValue];
                if (result == -1) {//用户名已存在
                    [MBProgressHUD showError:SIGNUP_VIEW_CONTROLLER_USER_EXISTS/*@"用户名已存在"*/];
                }else{
                    [MBProgressHUD showSuccess:SIGNUP_VIEW_CONTROLLER_TOBE_REVIEWED/*@"注册成功，请等待审核"*/];
                    //这个页面的工作已经结束了，通知代理
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if ([weakSelf.delegate respondsToSelector:@selector(signupViewController:didSuccessWithUsername:password:)]) {
                            [weakSelf.delegate signupViewController:self didSuccessWithUsername:username password:password];
                        }
                    });
                    
                }

            }
            failure:^(NSString *responseString, NSError *error) {
                
            }];

    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)dealloc
{
    NSLog(@"%@ dealloc", [self class]);
}

@end
