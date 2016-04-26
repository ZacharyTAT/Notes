//
//  ZHSignupView.m
//  Notes
//
//  Created by apple on 4/16/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "ZHSignupView.h"

#import "ZHSignUpTextField.h"

#import "MBProgressHUD+MJ.h"

//用户名框占位字符串
#define SIGNUP_VIEW_USER_TXTFIELD_PLACEHOLDER NSLocalizedStringFromTable(@"SIGNUP_VIEW_USER_TXTFIELD_PLACEHOLDER", @"ZHSignupView", @"请输入用户名")
//密码框占位字符串
#define SIGNUP_VIEW_PSWD_TXTFIELD_PLACEHOLDER NSLocalizedStringFromTable(@"SIGNUP_VIEW_PSWD_TXTFIELD_PLACEHOLDER", @"ZHSignupView", @"请输入密码，试试右边的眼睛")
#define SIGNUP_VIEW_SIGNUP_TEXT NSLocalizedStringFromTable(@"SIGNUP_VIEW_SIGNUP_TEXT", @"ZHSignupView", @"注册")
//用户名和密码不能为空
#define SIGNUP_VIEW_EMPTY NSLocalizedStringFromTable(@"SIGNUP_VIEW_EMPTY", @"ZHSignupView", @"用户名和密码不能为空")

@interface ZHSignupView()<UITextFieldDelegate>

/** 用户名框 */
@property (nonatomic, weak)ZHSignUpTextField *userTxtField;

/** 密码框 */
@property (nonatomic, weak)ZHSignUpTextField *pswdTxtField;

/** 登录按钮 */
@property (nonatomic, weak)UIButton *signupBtn;

@end

@implementation ZHSignupView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    //01.用户名框
    ZHSignUpTextField *userTxtField = [[ZHSignUpTextField alloc] init];
    self.userTxtField = userTxtField;
    userTxtField.placeholder = SIGNUP_VIEW_USER_TXTFIELD_PLACEHOLDER; //@"请输入用户名";
    
    //leftView
    UIButton *userLeftView = [[UIButton alloc] init];
    [userLeftView setImage:[UIImage imageNamed:@"login_name"] forState:UIControlStateNormal];
    userLeftView.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    userLeftView.frame = CGRectMake(10, 10, 30, 20);
    userLeftView.userInteractionEnabled = NO;
    userTxtField.leftView = userLeftView;
    
    [self addSubview:userTxtField];
    
    //03.密码框
    ZHSignUpTextField *pswdTxtField = [[ZHSignUpTextField alloc] init];
    self.pswdTxtField = pswdTxtField;
    pswdTxtField.secureTextEntry = YES;
    pswdTxtField.placeholder = SIGNUP_VIEW_PSWD_TXTFIELD_PLACEHOLDER;//@"请输入密码，试试右边的眼睛";
    pswdTxtField.returnKeyType = UIReturnKeyJoin;
    pswdTxtField.delegate = self;
    
    //leftView
    UIButton *pswdLeftView = [[UIButton alloc] init];
    [pswdLeftView setImage:[UIImage imageNamed:@"login_password"] forState:UIControlStateNormal];
    pswdLeftView.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    pswdLeftView.frame = CGRectMake(10, 10, 30, 20);
    pswdLeftView.userInteractionEnabled = NO;
    pswdTxtField.leftView = pswdLeftView;
    
    //rightView
    UIButton *visible = [[UIButton alloc] init];
    visible.frame = CGRectMake(10, 10, 40, 40);
    [visible setBackgroundImage:[UIImage imageNamed:@"account_invisible"] forState:UIControlStateNormal];
    [visible setBackgroundImage:[UIImage imageNamed:@"account_visible"] forState:UIControlStateSelected];
    [visible addTarget:self action:@selector(changeVisibility:) forControlEvents:UIControlEventTouchUpInside];
    pswdTxtField.rightView = visible;
    
    [self addSubview:pswdTxtField];
    
    //04.注册按钮
    UIButton *signupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    loginBtn.backgroundColor = [UIColor cyanColor];
    self.signupBtn = signupBtn;
    [self addSubview:signupBtn];
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
    [signupBtn setBackgroundImage:[[UIImage imageNamed:@"login_btn_blue_nor"] resizableImageWithCapInsets:insets] forState:UIControlStateNormal];
    [signupBtn setTitle:SIGNUP_VIEW_SIGNUP_TEXT /*@"注册"*/ forState:UIControlStateNormal];
    [signupBtn setBackgroundImage:[[UIImage imageNamed:@"login_btn_blue_press"] resizableImageWithCapInsets:insets] forState:UIControlStateHighlighted];
    [signupBtn setTitle:SIGNUP_VIEW_SIGNUP_TEXT /*@"注册"*/ forState:UIControlStateHighlighted];
    [signupBtn addTarget:self action:@selector(signup) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  判断两个输入框是否输入合法
 */
- (BOOL)isTextFieldOK
{
    if ([self.userTxtField.text isEqualToString:@""] || [self.pswdTxtField.text isEqualToString:@""]) return NO;
    
    return YES;
}

/**
 *  登录按钮点击
 */
- (void)signup
{
    if (![self isTextFieldOK]) {
        
        [MBProgressHUD showError:SIGNUP_VIEW_EMPTY /*@"用户名和密码不能为空"*/];
        
        return;
    }
    
    [self endEditing:YES];
    
    //告诉代理
    if ([self.delegate respondsToSelector:@selector(signupView:didSignupWithUsername:password:)]) {
        [self.delegate signupView:self didSignupWithUsername:self.userTxtField.text password:self.pswdTxtField.text];
    }
}

/**
 *  密码可见点击
 *
 */
- (void)changeVisibility:(UIButton *)btn
{
    //若当前按钮为选中，则点击之后，密码不可见(YES)，反之密码可见
    
    self.pswdTxtField.secureTextEntry = btn.isSelected;
    
    btn.selected = !btn.isSelected;
}

- (void)userTxtFieldBecomeFirstResponder
{
    [self.userTxtField becomeFirstResponder];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width;
    
    CGFloat txtFieldH = 45;
    
    CGFloat topMargin = 50;
    
    //02.用户名框
    CGFloat userTxtFieldX = 0;
    CGFloat userTxtFieldY = topMargin;
    CGFloat userTxtFieldW = width;
    CGFloat userTxtFieldH = txtFieldH;
    self.userTxtField.frame = CGRectMake(userTxtFieldX, userTxtFieldY, userTxtFieldW, userTxtFieldH);
    
    //03.密码框
    CGFloat pswdTxtFieldX = 0;
    CGFloat pswdTxtFieldY = CGRectGetMaxY(self.userTxtField.frame) + 20;
    CGFloat pswdTxtFieldW = width;
    CGFloat pswdTxtFieldH = txtFieldH;
    self.pswdTxtField.frame = CGRectMake(pswdTxtFieldX, pswdTxtFieldY, pswdTxtFieldW, pswdTxtFieldH);
    
    //04.登录按钮
    CGFloat loginBtnX = 10;
    CGFloat loginBtnY = CGRectGetMaxY(self.pswdTxtField.frame) + 20;
    CGFloat loginBtnW = width - loginBtnX * 2;
    CGFloat loginBtnH = 40;
    self.signupBtn.frame = CGRectMake(loginBtnX, loginBtnY, loginBtnW, loginBtnH);
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.userTxtField) return YES;
    
    NSLog(@"sign up");
    
    [self signup];
    
    return YES;
}

- (void)dealloc
{
    NSLog(@"%@ dealloc",[self class]);
}

@end
