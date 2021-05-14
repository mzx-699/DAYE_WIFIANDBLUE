//
//  finishViewController.m
//  MOWOX
//
//  Created by 安建伟 on 2018/12/17.
//  Copyright © 2018 yusz. All rights reserved.
//

#import "finishViewController.h"

@interface finishViewController () <GizWifiSDKDelegate>

@property (strong, nonatomic)  UIImageView *deviceImage;
@property (nonatomic, strong) UILabel *Label;
@property (nonatomic, strong) UIButton *finishBtn;

@end

@implementation finishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *backImage = [UIImage imageNamed:@"loginView"];
    self.view.layer.contents = (id)backImage.CGImage;
    
    UIImage *image = [UIImage imageNamed:@"返回1"];
    [self addLeftBarButtonWithImage:image action:@selector(finishBackAction)];
    
    [self setNavItem];
    _Label = [self Label];
    _finishBtn = [self finishBtn];
    _deviceImage = [self deviceImage];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [GizWifiSDK sharedInstance].delegate = self;
    
    GizManager *manager = [GizManager shareInstance];
    NSLog(@"ssid---%@",manager.ssid);
    NSLog(@"key---%@",manager.key);
    //airlink配网模式
    //[[GizWifiSDK sharedInstance] setDeviceOnboardingDeploy:manager.ssid key:manager.key configMode:GizWifiAirLink softAPSSIDPrefix:nil timeout:60 wifiGAgentType:[NSArray arrayWithObjects:@(GizGAgentESP), nil] bind:NO];
    //ap配网模式
    [[GizWifiSDK sharedInstance] setDeviceOnboardingDeploy:manager.ssid key:manager.key configMode:GizWifiSoftAP softAPSSIDPrefix:@"XPG-GAgent-" timeout:60 wifiGAgentType:nil bind:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - Lazy load
- (void)setNavItem{
    self.navigationItem.title = LocalString(@"Add Robot");
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"Back";
    self.navigationItem.backBarButtonItem = backItem;
}

- (UIImageView *)deviceImage{
    if (!_deviceImage) {
        _deviceImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"finishdevice"]];
        [self.view addSubview:_deviceImage];
        
        [_deviceImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth * 0.9, ScreenHeight * 0.3));
            make.top.equalTo(self.view.mas_top).offset(100/HScale);
            make.centerX.equalTo(self.view.mas_centerX);
        }];
    }
    return _deviceImage;
}

//- (UILabel *)Label{
//    if (!_Label) {
//        _Label = [[UILabel alloc] init];
//        _Label.font = [UIFont systemFontOfSize:14.f];
//        _Label.backgroundColor = [UIColor clearColor];
//        _Label.textColor = [UIColor whiteColor];
//        _Label.textAlignment = NSTextAlignmentCenter;
//        _Label.text = LocalString(@"Connection with Robot was successful");
//        [self.view addSubview:_Label];
//        [_Label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(280/WScale, 20/HScale));
//            make.centerX.mas_equalTo(self.view.mas_centerX);
//            make.top.equalTo(self.view.mas_top).offset(400/HScale);
//        }];
//    }
//    return _Label;
//}

- (UIButton *)finishBtn{
    if (!_finishBtn) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishBtn setTitle:LocalString(@"Finish") forState:UIControlStateNormal];
        [_finishBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_finishBtn setBackgroundColor:[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:0.6]];
        [_finishBtn addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
        _finishBtn.enabled = YES;
        [self.view addSubview:_finishBtn];
        [_finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(280/WScale, 40/HScale));
            make.top.equalTo(self.deviceImage.mas_bottom).offset(130/HScale);
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        
        _finishBtn.layer.borderWidth = 1.0;
        _finishBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _finishBtn.layer.cornerRadius = 10.f/HScale;
        
        
    }
    return _finishBtn;
}

#pragma mark - Actions

-(void)finish{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// 实现回调  远程设备绑定
- (void)wifiSDK:(GizWifiSDK *)wifiSDK didBindDevice:(NSError *)result did:(NSString *)did {
    if(result.code == GIZ_SDK_SUCCESS) {
        // 绑定成功
        NSLog(@"绑定成功");
        NSLog(@"%@",result);
    } else {
        // 绑定失败
        NSLog(@"绑定失败");
    }
    
}

// 实现回调  配网终止
- (void)wifiSDK:(GizWifiSDK *)wifiSDK didSetDeviceOnboarding:(NSError *)result device:(GizWifiDevice *)device {
    if(result.code == GIZ_SDK_ONBOARDING_STOPPED) {
        // 配网终止
        NSLog(@"配网终止");
    }
    
}

#pragma mark - Giz delegate
-(void)wifiSDK:(GizWifiSDK *)wifiSDK didSetDeviceOnboarding:(NSError * _Nonnull)result mac:(NSString * _Nullable)mac did:(NSString * _Nullable)did productKey:(NSString * _Nullable)productKey{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (result.code == GIZ_SDK_SUCCESS) {
        //设备信息
        [GizManager shareInstance].did = did;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalString(@"Configue Result") message:LocalString(@"SUCCESSFUL!") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LocalString(@"I know") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"action = %@",action);
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
       
        [[GizWifiSDK sharedInstance] bindRemoteDevice:[GizManager shareInstance].uid token:[GizManager shareInstance].token mac:mac productKey:productKey productSecret:GizAppproductSecret beOwner:NO];
    }else{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalString(@"Configue Result") message:LocalString(@"FAILED!") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LocalString(@"I know") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            NSLog(@"action = %@",action);
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)finishBackAction{
    //返回上一级页面 取消配网功能
    [[GizWifiSDK sharedInstance] stopDeviceOnboarding];//停止配网
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIViewController *viewCtl =self.navigationController.viewControllers[2];
    [self.navigationController popToViewController:viewCtl animated:YES];
}

@end
