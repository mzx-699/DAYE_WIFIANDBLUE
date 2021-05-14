//
//  RegisterViewController.m
//  MOWOX
//
//  Created by 安建伟 on 2018/12/14.
//  Copyright © 2018 yusz. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"
#import <GizWifiSDK/GizWifiSDK.h>
#import <objc/runtime.h>

@interface RegisterViewController () <UITextFieldDelegate,GizWifiSDKDelegate>

@property (nonatomic, strong) UITextField *emailTF;
@property (nonatomic, strong) UITextField *passwordTF;
@property (nonatomic, strong) UITextField *repeatpasswordTF;
@property (nonatomic, strong) UISwitch *agreeSwitch;
@property (nonatomic, strong) UIButton *RegisterBtn;

@property (nonatomic, strong) UILabel *agreeLabel;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
//    self.view = scrollView;
    UIImage *backImage = [UIImage imageNamed:@"loginView"];
    self.view.layer.contents = (id)backImage.CGImage;
    
    [self setNavItem];
    _emailTF = [self emailTF];
    _passwordTF = [self passwordTF];
    _repeatpasswordTF = [self repeatpasswordTF];
    _RegisterBtn = [self RegisterBtn];
    //_agreeSwitch = [self agreeSwitch];
    //_agreeLabel = [self agreeLabel];
    [GizWifiSDK sharedInstance].delegate = self;

    
}

- (void)setNavItem{
    self.navigationItem.title = LocalString(@"Register");
}

- (UITextField *)emailTF{
    if (!_emailTF) {
        _emailTF = [[UITextField alloc] init];
        _emailTF.backgroundColor = [UIColor clearColor];
        _emailTF.font = [UIFont systemFontOfSize:15.f];
        _emailTF.textColor = [UIColor whiteColor];
        _emailTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _emailTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _emailTF.delegate = self;
        _emailTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _emailTF.borderStyle = UITextBorderStyleRoundedRect;
        [_emailTF addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
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
        _passwordTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _passwordTF.borderStyle = UITextBorderStyleRoundedRect;
        [_passwordTF addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_passwordTF];
        [_passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(280/WScale, 40/HScale));
            make.top.equalTo(self.emailTF.mas_bottom).offset(30/HScale);
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

- (UITextField *)repeatpasswordTF{
    if (!_repeatpasswordTF) {
        _repeatpasswordTF = [[UITextField alloc] init];
        _repeatpasswordTF.backgroundColor = [UIColor clearColor];
        _repeatpasswordTF.font = [UIFont systemFontOfSize:15.f];
        _repeatpasswordTF.textColor = [UIColor whiteColor];
        _repeatpasswordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _repeatpasswordTF.autocorrectionType = UITextAutocorrectionTypeNo;
        _repeatpasswordTF.delegate = self;
        _repeatpasswordTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _repeatpasswordTF.borderStyle = UITextBorderStyleRoundedRect;
        [_repeatpasswordTF addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_repeatpasswordTF];
        [_repeatpasswordTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(280/WScale, 40/HScale));
            make.top.equalTo(self.passwordTF.mas_bottom).offset(30/HScale);
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        
        _repeatpasswordTF.layer.borderWidth = 1.0;
        _repeatpasswordTF.layer.borderColor = [UIColor whiteColor].CGColor;
        _repeatpasswordTF.layer.cornerRadius = 10.f/HScale;
        _repeatpasswordTF.placeholder = LocalString(@"repeat password");
        Ivar ivar =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
        UILabel *placeholderLabel = object_getIvar(_repeatpasswordTF, ivar);
        placeholderLabel.textColor = [UIColor whiteColor];
        placeholderLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _repeatpasswordTF;
}

- (UISwitch *)agreeSwitch{
    if (!_agreeSwitch) {
        _agreeSwitch = [[UISwitch alloc]init];
        [_agreeSwitch setThumbTintColor:[UIColor whiteColor]];
        _agreeSwitch.layer.cornerRadius = 15.5f;
        _agreeSwitch.layer.masksToBounds = YES;
        [_agreeSwitch addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_agreeSwitch];
        [_agreeSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60/WScale, 30/HScale));
            make.top.equalTo(self.repeatpasswordTF.mas_bottom).offset(30/HScale);
            make.leftMargin.mas_equalTo(self.repeatpasswordTF.mas_leftMargin);
        }];
    }
    return _agreeSwitch;
}

- (UILabel *)agreeLabel{
    if (!_agreeLabel) {
        _agreeLabel = [[UILabel alloc] init];
        _agreeLabel.font = [UIFont systemFontOfSize:15.f];
        _agreeLabel.backgroundColor = [UIColor clearColor];
        _agreeLabel.textColor = [UIColor whiteColor];
        _agreeLabel.textAlignment = NSTextAlignmentLeft;
        _agreeLabel.text = LocalString(@"I agree to the Terms of Use");
        [self.view addSubview:_agreeLabel];
        [_agreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(300/WScale, 20/HScale));
            make.left.equalTo(self.agreeSwitch.mas_right).offset(15/WScale);
            make.top.equalTo(self.repeatpasswordTF.mas_bottom).offset(30/HScale);
        }];
    }
    return _agreeLabel;
}

- (UIButton *)RegisterBtn{
    if (!_RegisterBtn) {
        _RegisterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_RegisterBtn setTitle:LocalString(@"Register") forState:UIControlStateNormal];
        [_RegisterBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_RegisterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_RegisterBtn setBackgroundColor:[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:0.6]];
        [_RegisterBtn addTarget:self action:@selector(registerLogin) forControlEvents:UIControlEventTouchUpInside];
        _RegisterBtn.enabled = YES;
        [self.view addSubview:_RegisterBtn];
        [_RegisterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(280/WScale, 40/HScale));
            make.top.equalTo(self.repeatpasswordTF.mas_bottom).offset(45/HScale);
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        
        _RegisterBtn.layer.borderWidth = 1.0;
        _RegisterBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _RegisterBtn.layer.cornerRadius = 10.f/HScale;
        
        
    }
    return _RegisterBtn;
}

//监听文本框事件
- (void)textFieldTextChange:(UITextField *)textField{
    if ( _repeatpasswordTF.text.length > 0 && _passwordTF.text.length > 0){
        [_RegisterBtn setBackgroundColor:[UIColor colorWithRed:71/255.0 green:120/255.0 blue:204/255.0 alpha:1]];
        _RegisterBtn.enabled = YES;
    }else{
        [_RegisterBtn setBackgroundColor:[UIColor colorWithRed:71/255.0 green:120/255.0 blue:204/255.0 alpha:0.4]];
        _RegisterBtn.enabled = NO;
    }
}

#pragma mark - resign keyboard control

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.emailTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
    [self.repeatpasswordTF resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

// 实现回调
- (void)wifiSDK:(GizWifiSDK *)wifiSDK didRegisterUser:(NSError *)result uid:(NSString *)uid token:(NSString *)token {
    if(result.code == GIZ_SDK_SUCCESS) {
        // 注册成功
        NSLog(@"注册成功");
        [NSObject showHudTipStr:LocalString(@"Registration successful")];
        //返回上一级视图
        UIViewController *viewCtl =self.navigationController.viewControllers[1];
        [self.navigationController popToViewController:viewCtl animated:YES];
        
    } else {
        // 注册失败
        NSLog(@"注册失败");
        [NSObject showHudTipStr:LocalString(@"Registration failed")];
        NSLog(@"注册失败%@",result);
        //[NSObject showHudTipStr3:[NSString stringWithFormat:@"%@",result]];
        
    }
    
}

-(void)switchAction{
    
    NSLog(@"tt");
    
}

-(void)registerLogin{
    NSLog(@"注册");
    if (!(_passwordTF.text == _repeatpasswordTF.text)) {
        [NSObject showHudTipStr:LocalString(@"Two input is inconsistent")];
    }else{
        [[GizWifiSDK sharedInstance] registerUser:_emailTF.text password:_passwordTF.text verifyCode:nil accountType:GizUserEmail];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}
@end
