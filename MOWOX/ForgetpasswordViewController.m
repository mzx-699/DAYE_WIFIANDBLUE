//
//  ForgetpasswordViewController.m
//  MOWOX
//
//  Created by 安建伟 on 2018/12/18.
//  Copyright © 2018 yusz. All rights reserved.
//

#import "ForgetpasswordViewController.h"
#import <objc/runtime.h>

@interface ForgetpasswordViewController () <UITextFieldDelegate,GizWifiSDKDelegate>

@property (nonatomic, strong) UITextField *emailTF;
@property (nonatomic, strong) UITextField *NewpasswordTF;
@property (nonatomic, strong) UIButton *OKBtn;

@end

@implementation ForgetpasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *backImage = [UIImage imageNamed:@"loginView"];
    self.view.layer.contents = (id)backImage.CGImage;
    
    [self setNavItem];
    _emailTF = [self emailTF];
    //_NewpasswordTF = [self NewpasswordTF];
    _OKBtn = [self OKBtn];
    [GizWifiSDK sharedInstance].delegate = self;
}

- (void)setNavItem{
    self.navigationItem.title = LocalString(@"Forget Password");
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
    }
    return _emailTF;
}

//监听文本框事件
- (void)textFieldTextChange{
    if (_emailTF.text.length > 0){
        [_OKBtn setBackgroundColor:[UIColor colorWithRed:71/255.0 green:120/255.0 blue:204/255.0 alpha:1]];
        _OKBtn.enabled = YES;
    }else{
        [_OKBtn setBackgroundColor:[UIColor colorWithRed:71/255.0 green:120/255.0 blue:204/255.0 alpha:0.4]];
        _OKBtn.enabled = NO;
    }
}

#pragma mark - resign keyboard control

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.emailTF resignFirstResponder];
    [self.NewpasswordTF resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

// 实现回调
- (void)wifiSDK:(GizWifiSDK *)wifiSDK didChangeUserPassword:(NSError *)result {
    if(result.code == GIZ_SDK_SUCCESS) {
        //重置密码邮件发送成功，提示用户查收
        NSLog(@"重置密码邮件发送成功");
        [NSObject showHudTipStr:LocalString(@"Reset message has been sent to your mailbox")];
    } else {
        //重置密码邮件发送失败，弹出错误信息
        [NSObject showHudTipStr:LocalString(@"Reset password mail failed to send")];
    }
}
- (UIButton *)OKBtn{
    if (!_OKBtn) {
        _OKBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_OKBtn setTitle:LocalString(@"OK") forState:UIControlStateNormal];
        [_OKBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_OKBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_OKBtn setBackgroundColor:[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:0.6]];
        [_OKBtn addTarget:self action:@selector(OK) forControlEvents:UIControlEventTouchUpInside];
        _OKBtn.enabled = YES;
        [self.view addSubview:_OKBtn];
        [_OKBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(280/WScale, 40/HScale));
            make.top.equalTo(self.view.mas_top).offset(300/HScale);
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        
        _OKBtn.layer.borderWidth = 1.0;
        _OKBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _OKBtn.layer.cornerRadius = 10.f/HScale;
        
    }
    return _OKBtn;
}
-(void)OK{
    
    [[GizWifiSDK sharedInstance] resetPassword:_emailTF.text verifyCode:nil newPassword:_NewpasswordTF.text accountType:GizUserEmail];
}
@end
