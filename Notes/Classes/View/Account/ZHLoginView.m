//
//  ZHLoginView.m
//  Notes
//
//  Created by apple on 4/15/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "ZHLoginView.h"

#import "ZHBottomLineTextField.h"

#import "MBProgressHUD+MJ.h"

@interface ZHLoginView()<UITextFieldDelegate>

/** 头像 */
@property (nonatomic, weak)UIImageView *avatar;

/** 用户名框 */
@property (nonatomic, weak)ZHBottomLineTextField *userTxtField;

/** 密码框 */
@property (nonatomic, weak)ZHBottomLineTextField *pswdTxtField;

/** 登录按钮 */
@property (nonatomic, weak)UIButton *loginBtn;

/** 头像宽度 */
@property (nonatomic, assign)CGFloat avatarWidth;

/** 头像高度 */
@property (nonatomic, assign)CGFloat avatarHeight;

@end

@implementation ZHLoginView

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
    //01.头像
    UIImage *image = [UIImage imageNamed:@"login_avatar_default"];
    self.avatarWidth = image.size.width;
    self.avatarHeight = image.size.height;
    
    UIImageView *avatar = [[UIImageView alloc] initWithImage:image];
//    avatar.backgroundColor = [UIColor redColor];
    self.avatar = avatar;
    [self addSubview:avatar];
   
    //02.用户名框
    ZHBottomLineTextField *userTxtField = [[ZHBottomLineTextField alloc] init];
    self.userTxtField = userTxtField;
    userTxtField.placeholder = @"用户名";
    [self addSubview:userTxtField];
    
    //03.密码框
    ZHBottomLineTextField *pswdTxtField = [[ZHBottomLineTextField alloc] init];
    self.pswdTxtField = pswdTxtField;
    pswdTxtField.secureTextEntry = YES;
    pswdTxtField.placeholder = @"密码";
    pswdTxtField.returnKeyType = UIReturnKeyJoin;
    pswdTxtField.delegate = self;
    [self addSubview:pswdTxtField];
    
    //04.登录按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    loginBtn.backgroundColor = [UIColor cyanColor];
    self.loginBtn = loginBtn;
    [self addSubview:loginBtn];
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
    [loginBtn setBackgroundImage:[[UIImage imageNamed:@"login_btn_blue_nor"] resizableImageWithCapInsets:insets] forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[[UIImage imageNamed:@"login_btn_blue_press"] resizableImageWithCapInsets:insets] forState:UIControlStateHighlighted];
    [loginBtn setTitle:@"登录" forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.userTxtField) return YES;
    
    NSLog(@"return");
    [self login];
    return YES;
}

- (void)userTxtFieldBecomeFirstResponder
{
    [self.userTxtField becomeFirstResponder];
}

#pragma mark - 登录点击
/**
 *  登录点击
 */
- (void)login
{
    
    //判断两个输入框是否合法
    
    if (![self isTxtFieldOK]) {
        
        [MBProgressHUD showError:@"用户名和密码不能为空"];
        
        return;
    }
    
    [self endEditing:YES];
    
    if ([self.delegate respondsToSelector:@selector(loginView:didLoginWithUserName:password:)]) {
        [self.delegate loginView:self didLoginWithUserName:self.userTxtField.text password:self.pswdTxtField.text];
    }
}

- (BOOL)isTxtFieldOK
{
    if ([self.userTxtField.text isEqualToString:@""] || [self.pswdTxtField.text isEqualToString:@""]) return NO;
    
    return YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width;
    
    //01.头像
    CGFloat avatarX = self.center.x - self.avatarWidth * 0.5;
    CGFloat avatarY = 0;
    CGFloat avatarW = self.avatarWidth;
    CGFloat avatarH = self.avatarHeight;
    self.avatar.frame = CGRectMake(avatarX, avatarY, avatarW, avatarH);
    
    CGFloat txtFieldH = 45;
    
    //02.用户名框
    CGFloat userTxtFieldX = 0;
    CGFloat userTxtFieldY = CGRectGetMaxY(self.avatar.frame) + 10;
    CGFloat userTxtFieldW = width;
    CGFloat userTxtFieldH = txtFieldH;
    self.userTxtField.frame = CGRectMake(userTxtFieldX, userTxtFieldY, userTxtFieldW, userTxtFieldH);
    
    //03.密码框
    CGFloat pswdTxtFieldX = 0;
    CGFloat pswdTxtFieldY = CGRectGetMaxY(self.userTxtField.frame);
    CGFloat pswdTxtFieldW = width;
    CGFloat pswdTxtFieldH = txtFieldH;
    self.pswdTxtField.frame = CGRectMake(pswdTxtFieldX, pswdTxtFieldY, pswdTxtFieldW, pswdTxtFieldH);
    
    //04.登录按钮
    CGFloat loginBtnX = 10;
    CGFloat loginBtnY = CGRectGetMaxY(self.pswdTxtField.frame) + 10;
    CGFloat loginBtnW = width - loginBtnX * 2;
    CGFloat loginBtnH = 40;
    self.loginBtn.frame = CGRectMake(loginBtnX, loginBtnY, loginBtnW, loginBtnH);
}

- (void)dealloc
{
    NSLog(@"%@ dealloc",[self class]);
}

@end
