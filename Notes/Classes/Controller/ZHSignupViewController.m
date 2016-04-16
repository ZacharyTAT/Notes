//
//  ZHSignupViewController.m
//  Notes
//
//  Created by apple on 4/15/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "ZHSignupViewController.h"

#import "ZHSignupView.h"

#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"

@interface ZHSignupViewController ()<ZHSignupViewDelegate>

/** 注册视图 */
@property (nonatomic, weak)ZHSignupView *signupView;

@end

@implementation ZHSignupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"注册";
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
    [MBProgressHUD showMessage:@"正在验证"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //发请求给服务器进行注册
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        
        mgr.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
        
        NSMutableDictionary *params = [@{} mutableCopy];
        params[@"username"] = username;
        params[@"password"] = password;
        
        [mgr POST:[NSString stringWithFormat:@"%@/%@",ROOT ,@"register.php"]
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"%@",operation.responseString);
              [MBProgressHUD hideHUD];
              NSInteger result = [operation.responseString integerValue];
              if (result == -1) {//用户名已存在
                  [MBProgressHUD showError:@"用户名已存在"];
              }else{
                  [MBProgressHUD showSuccess:@"注册成功，请等待审核"];
                  //这个页面的工作已经结束了，通知代理
                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                      if ([weakSelf.delegate respondsToSelector:@selector(signupViewController:didSuccessWithUsername:password:)]) {
                          [weakSelf.delegate signupViewController:self didSuccessWithUsername:username password:password];
                      }
                  });
                  
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"%@",error);
              [MBProgressHUD hideHUD];
          }];
    });

    
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
