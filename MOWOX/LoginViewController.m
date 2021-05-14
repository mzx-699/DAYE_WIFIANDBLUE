//
//  LoginViewController.m
//  MOWOX
//
//  Created by Mac on 2017/10/30.
//  Copyright © 2017年 yusz. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetpasswordViewController.h"
#import "MainViewController.h"
#import "WelcomeViewController.h"
#import <objc/runtime.h>

@interface LoginViewController () <UITextFieldDelegate,GizWifiSDKDelegate>

@property (nonatomic, strong) UITextField *emailTF;
@property (nonatomic, strong) UITextField *passwordTF;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *RegisterBtn;
@property (nonatomic, strong) UIButton *forgetPWBtn;
@property (nonatomic, strong) UIButton *eyespasswordBtn;
@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) UILabel *passwordLabel;

@end

@implementation LoginViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *backImage = [UIImage imageNamed:@"loginView"];
    self.view.layer.contents = (id)backImage.CGImage;
    
    //_headerImage = [self headerImage];
    _emailTF = [self emailTF];
    _passwordTF = [self passwordTF];
    _loginBtn = [self loginBtn];
    _RegisterBtn = [self RegisterBtn];
    _forgetPWBtn = [self forgetPWBtn];
    _eyespasswordBtn = [self eyespasswordBtn];
    _checkBtn = [self checkBtn];
    _passwordLabel = [self passwordLabel];
    [_eyespasswordBtn setImage:[UIImage imageNamed:@"ic_eyesclosed"] forState:UIControlStateNormal];
    
    //读取上次的 记住密码
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"passWord"]){
        [_checkBtn setImage:[UIImage imageNamed:@"rememberpassword"] forState:UIControlStateNormal];
        _checkBtn.tag = select;
        _passwordTF.text = [defaults objectForKey:@"passWord"];
        NSLog(@"帐号密码%@",_passwordTF.text);
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [GizWifiSDK sharedInstance].delegate = self;
    
}

- (UITextField *)emailTF{
    if (!_emailTF) {
        _emailTF = [[UITextField alloc] init];
        _emailTF.backgroundColor = [UIColor clearColor];
        _emailTF.font = [UIFont systemFontOfSize:16.f];
        _emailTF.textColor = [UIColor whiteColor];
        _emailTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _emailTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _emailTF.delegate = self;
        _emailTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _emailTF.borderStyle = UITextBorderStyleRoundedRect;
        [_emailTF addTarget:self action:@selector(textFieldTextChange) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_emailTF];
        [_emailTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(280/WScale, 40/HScale));
            make.top.equalTo(self.view.mas_top).offset(200/HScale);
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        _emailTF.layer.borderWidth = 1.0;
        _emailTF.layer.borderColor = [UIColor whiteColor].CGColor;
        _emailTF.layer.cornerRadius = 10.f/HScale;
        _emailTF.placeholder = LocalString(@"e-mail");
        
        Ivar ivar =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
        UILabel *placeholderLabel = object_getIvar(_emailTF, ivar);
        placeholderLabel.textColor = [UIColor whiteColor];
        placeholderLabel.font = [UIFont boldSystemFontOfSize:16];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *email = [userDefaults objectForKey:@"email"];
        if (email != NULL) {
            _emailTF.text = email;
        }
        
    }
    return _emailTF;
}
- (UITextField *)passwordTF{
    if (!_passwordTF) {
        _passwordTF = [[UITextField alloc] init];
        _passwordTF.backgroundColor = [UIColor clearColor];
        _passwordTF.font = [UIFont systemFontOfSize:15.f];
        _passwordTF.textColor = [UIColor whiteColor];
        _passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _passwordTF.delegate = self;
        _passwordTF.secureTextEntry = YES;
        _passwordTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _passwordTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _passwordTF.borderStyle = UITextBorderStyleRoundedRect;
        
        [_passwordTF addTarget:self action:@selector(textFieldTextChange) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_passwordTF];
        [_passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(280/WScale, 40/HScale));
            make.top.equalTo(self.emailTF.mas_bottom).offset(30);
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        _passwordTF.layer.borderWidth = 1.0;
        _passwordTF.layer.borderColor = [UIColor whiteColor].CGColor;
        _passwordTF.layer.cornerRadius = 10.f/HScale;
        _passwordTF.placeholder = LocalString(@"password");
        
        Ivar ivar =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
        UILabel *placeholderLabel = object_getIvar(_passwordTF, ivar);
        placeholderLabel.textColor = [UIColor whiteColor];
        placeholderLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _passwordTF;
}

- (UIButton *)eyespasswordBtn{
    if (!_eyespasswordBtn) {
        _eyespasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_eyespasswordBtn addTarget:self action:@selector(eyespassword) forControlEvents:UIControlEventTouchUpInside];
        [_eyespasswordBtn.widthAnchor constraintEqualToConstant:30].active = YES;
        [_eyespasswordBtn.heightAnchor constraintEqualToConstant:30].active = YES;
        [self.view addSubview:_eyespasswordBtn];
        [_eyespasswordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30/WScale, 30/HScale));
            make.right.equalTo(self.view.mas_right).offset(-50);
            make.centerY.equalTo(self.passwordTF.mas_centerY);
        }];
    }
    return _eyespasswordBtn;
}

- (UIButton *)checkBtn{
    if (!_checkBtn) {
        _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkBtn setImage:[UIImage imageNamed:@"not password"] forState:UIControlStateNormal];
        [_checkBtn addTarget:self action:@selector(check) forControlEvents:UIControlEventTouchUpInside];
        [_checkBtn.widthAnchor constraintEqualToConstant:25].active = YES;
        [_checkBtn.heightAnchor constraintEqualToConstant:25].active = YES;
        _checkBtn.tag = unselect;
        [self.view addSubview:_checkBtn];
        [_checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(25/WScale, 25/HScale));
            make.left.equalTo(self.view.mas_left).offset(50);
            make.top.equalTo(self.passwordTF.mas_bottom).offset(20);
        }];
    }
    return _checkBtn;
}

- (UILabel *)passwordLabel{
    if (!_passwordLabel) {
        _passwordLabel = [[UILabel alloc] init];
        _passwordLabel.font = [UIFont systemFontOfSize:14.f];
        _passwordLabel.backgroundColor = [UIColor clearColor];
        _passwordLabel.textColor = [UIColor whiteColor];
        _passwordLabel.textAlignment = NSTextAlignmentCenter;
        _passwordLabel.text = LocalString(@"Remember Password");
        _passwordLabel.adjustsFontSizeToFitWidth = YES;
        [self.view addSubview:_passwordLabel];
        [_passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(150/WScale, 20/HScale));
            make.left.equalTo(self.checkBtn.mas_right).offset(5);
            make.centerY.equalTo(self.checkBtn.mas_centerY);
        }];
    }
    return _passwordLabel;
}

//监听文本框事件
- (void)textFieldTextChange{
    if (_emailTF.text.length >0 && _passwordTF.text.length > 0){
        [_loginBtn setBackgroundColor:[UIColor colorWithRed:71/255.0 green:120/255.0 blue:204/255.0 alpha:1]];
        _loginBtn.enabled = YES;
    }else{
        [_loginBtn setBackgroundColor:[UIColor colorWithRed:71/255.0 green:120/255.0 blue:204/255.0 alpha:0.4]];
        _loginBtn.enabled = NO;
    }
}

- (UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setTitle:LocalString(@"Sign In") forState:UIControlStateNormal];
        [_loginBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn setBackgroundColor:[UIColor colorWithRed:108/255.0 green:113/255.0 blue:118/255.0 alpha:1.f]];
        [_loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn.enabled = YES;
        [self.view addSubview:_loginBtn];
        [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(280/WScale, 40/HScale));
            make.top.equalTo(self.passwordTF.mas_bottom).offset(60/HScale);
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        
        //_loginBtn.layer.borderWidth = 1.0;
        //_loginBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _loginBtn.layer.cornerRadius = 10.f/HScale;
        
        
    }
    return _loginBtn;
}

- (UIButton *)RegisterBtn{
    if (!_RegisterBtn) {
        _RegisterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_RegisterBtn setTitle:LocalString(@"Register") forState:UIControlStateNormal];
        [_RegisterBtn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
        [_RegisterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_RegisterBtn addTarget:self action:@selector(registerLogin) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_RegisterBtn];
        [_RegisterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100/WScale, 16/HScale));
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.loginBtn.mas_bottom).offset(50/HScale);
        }];
    }
    return _RegisterBtn;
}

- (UIButton *)forgetPWBtn{
    if (!_forgetPWBtn) {
        _forgetPWBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetPWBtn setTitle:LocalString(@"Forget Password") forState:UIControlStateNormal];
        [_forgetPWBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_forgetPWBtn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
        [_forgetPWBtn addTarget:self action:@selector(forgetPW) forControlEvents:UIControlEventTouchUpInside];
        //_forgetPWBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.view addSubview:_forgetPWBtn];
        [_forgetPWBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(150/WScale, 16/HScale));
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(self.RegisterBtn.mas_bottom).offset(30/HScale);
        }];
    }
    return _forgetPWBtn;
}

#pragma mark - uitextfield delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}

#pragma mark - GizWifiSDK delegate
// 实现回调
- (void)wifiSDK:(GizWifiSDK *)wifiSDK didUserLogin:(NSError *)result uid:(NSString *)uid token:(NSString *)token {
    if(result.code == GIZ_SDK_SUCCESS) {
        //登录成功
        NSLog(@"登录成功,%@", result);
        
        [GizManager shareInstance].uid = uid;
        [GizManager shareInstance].token = token;
        
        //        //保存Wi-Fi名称
        //        NSUserDefaults *wifinameDefaults = [NSUserDefaults standardUserDefaults];
        //        [wifinameDefaults setObject: [GizManager getCurrentWifi] forKey:@"wifiname"];
        //        NSLog(@"Wi-Fi名称%@",[GizManager getCurrentWifi]);
        //保存帐号密码
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:self.emailTF.text forKey:@"email"];
        if (self.checkBtn.tag == select) {
            //保存密码
            [userDefaults setObject:self.passwordTF.text forKey:@"passWord"];
        }else{
            //去除密码
            [userDefaults removeObjectForKey:@"passWord"];
        }
        [userDefaults synchronize];
        
        WelcomeViewController *WelcomeVC = [[WelcomeViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:WelcomeVC];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nav animated:YES completion:nil];
        
    } else {
        // 登录失败
        NSLog(@"登录失败,%@", result);
        [NSObject showHudTipStr:LocalString(@"Login failed")];
        //[NSObject showHudTipStr3:[NSString stringWithFormat:@"%@",result]];
        
    }
    
}

#pragma mark - Actions
- (void)login{
    
    [[GizWifiSDK sharedInstance] userLogin:_emailTF.text password:_passwordTF.text];

}

- (void)eyespassword{
    if (_passwordTF.secureTextEntry == YES) {
        [_eyespasswordBtn setImage:[UIImage imageNamed:@"ic_eyespassword"] forState:UIControlStateNormal];
        _passwordTF.secureTextEntry = NO;
    }else{
        _passwordTF.secureTextEntry = YES;
        [_eyespasswordBtn setImage:[UIImage imageNamed:@"ic_eyesclosed"] forState:UIControlStateNormal];
    }
    
}

-(void)check{
    if (_checkBtn.tag == unselect) {
        _checkBtn.tag = select;
        [_checkBtn setImage:[UIImage imageNamed:@"rememberpassword"] forState:UIControlStateNormal];
    }else if (_checkBtn.tag == select) {
        _checkBtn.tag = unselect;
        [_checkBtn setImage:[UIImage imageNamed:@"not password"] forState:UIControlStateNormal];
    }
    
}
- (void)registerLogin{
    RegisterViewController *RegisterVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:RegisterVC animated:YES];
}

- (void)forgetPW{
    ForgetpasswordViewController *ForgetVC = [[ForgetpasswordViewController alloc] init];
    [self.navigationController pushViewController:ForgetVC animated:YES];
    
}

@end
