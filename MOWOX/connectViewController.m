//
//  connectViewController.m
//  MOWOX
//
//  Created by 安建伟 on 2018/12/17.
//  Copyright © 2018 yusz. All rights reserved.
//

#import "connectViewController.h"
#import "finishViewController.h"
#import "addLandroidDeviceViewController.h"

@interface connectViewController () <UITextViewDelegate>

@property (strong, nonatomic) UIImageView *deviceImage;
@property (strong, nonatomic) UITextView *LandroidTextView;

@property (nonatomic, strong) UIButton *connectBtn;

@end

@implementation connectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavItem];
    
    UIImage *backImage = [UIImage imageNamed:@"loginView"];
    self.view.layer.contents = (id)backImage.CGImage;

    _connectBtn = [self connectBtn];
    _LandroidTextView = [self LandroidTextView];
    _deviceImage = [self deviceImage];
}

- (void)setNavItem{
    self.navigationItem.title = LocalString(@"Add Robot");
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"Back";
    self.navigationItem.backBarButtonItem = backItem;
}

- (UIImageView *)deviceImage{
    if (!_deviceImage) {
        _deviceImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Robot"]];
        [self.view addSubview:_deviceImage];
        
        [_deviceImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth * 0.9, ScreenHeight * 0.3));
            make.top.equalTo(self.view.mas_top).offset(80/HScale);
            make.centerX.equalTo(self.view.mas_centerX);
        }];
    }
    return _deviceImage;
}

- (UITextView *)LandroidTextView{
   
    if (!_LandroidTextView) {
        _LandroidTextView = [[UITextView alloc] init];
        _LandroidTextView.backgroundColor = [UIColor clearColor];
        _LandroidTextView.text = LocalString(@"1.Turn on your Robot.\n2.Move the cursor to\"WIFI Setting\",then press OK;the text Network Configuration……will appear.\n3.Press the connection buttton and wait for the process to complete.");
        _LandroidTextView.textAlignment = NSTextAlignmentLeft;
        _LandroidTextView.textColor = [UIColor whiteColor];
        _LandroidTextView.font = [UIFont boldSystemFontOfSize:15];
        //_LandroidTextView.dataDetectorTypes = UIDataDetectorTypeAll;
        // 禁止编辑.设置为只读，不再能输入内容
        _LandroidTextView.editable = NO;
        //禁止选择.禁止选中文本，此时文本也禁止编辑
        _LandroidTextView.selectable = NO;
        // 禁止滚动
        _LandroidTextView.scrollEnabled = NO;
        // 设置可以对选中的文字加粗。选中文字时可以对选中的文字加粗
        _LandroidTextView.allowsEditingTextAttributes = YES;
        _LandroidTextView.delegate = self;
        
        [self.view addSubview:_LandroidTextView];
        [_LandroidTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(300/WScale,200/HScale));
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.top.equalTo(self.view.mas_top).offset(300/HScale);
        }];
    }
    return _LandroidTextView;
}

- (UIButton *)connectBtn{
    if (!_connectBtn) {
        _connectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_connectBtn setTitle:LocalString(@"Connect") forState:UIControlStateNormal];
        [_connectBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [_connectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_connectBtn setBackgroundColor:[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:0.6]];
        [_connectBtn addTarget:self action:@selector(ConnectWifi) forControlEvents:UIControlEventTouchUpInside];
        _connectBtn.enabled = YES;
        [self.view addSubview:_connectBtn];
        [_connectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(280/WScale, 40/HScale));
            make.top.equalTo(self.LandroidTextView.mas_bottom).offset(30/HScale);
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];

        _connectBtn.layer.borderWidth = 1.0;
        _connectBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _connectBtn.layer.cornerRadius = 10.f/HScale;


    }
    return _connectBtn;
}

-(void)ConnectWifi{
    /*
     *在App内连接ap热点
     */
//    NSString *wifiName = @"XPG-";
//    NSLog(@"wifiName%@",[[GizManager getCurrentWifi] substringWithRange:NSMakeRange(0, 4)]);
//    if ([[[GizManager getCurrentWifi] substringWithRange:NSMakeRange(0, 4)] isEqualToString:wifiName]) {
//        finishViewController *VC = [[finishViewController alloc] init];
//        [self.navigationController pushViewController:VC animated:YES];
//    }else{
//        [self showAlert];
//    }

    NSString *wifiName = @"XPG-GAgent";
    if ([[GizManager getCurrentWifi] hasPrefix:wifiName]) {
        finishViewController *VC = [[finishViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        [self showAlert];
    }
}

- (void)showAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalString(@"Jump prompt") message:LocalString(@"Connect hotspots “XPG-GAgent” in settings,Password:123456789") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:LocalString(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LocalString(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
