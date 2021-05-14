//
//  WelcomeViewController.m
//  MOWOX
//
//  Created by 安建伟 on 2018/12/19.
//  Copyright © 2018 yusz. All rights reserved.
//

#import "WelcomeViewController.h"
#import "LoginViewController.h"
#import "addLandroidDeviceViewController.h"
#import "connectViewController.h"
#import "LandroidListCell.h"
#import "RDVViewController.h"
#import "LMPopInputPasswordView.h"
#import <NetworkExtension/NEHotspotConfigurationManager.h>

NSString *const CellIdentifier_landroid = @"CellID_landroid";


@interface WelcomeViewController () <UITableViewDelegate, UITableViewDataSource, GizWifiSDKDelegate,LMPopInputPassViewDelegate>

///@brife ui和功能各模块
@property (strong, nonatomic)  UILabel *deviceLabel;
@property (strong, nonatomic)  UIButton *addButton;

@property (nonatomic, strong) UITableView *deviceTable;
@property (nonatomic, strong) NSArray *deviceArray;

@property (strong, nonatomic)  UILabel *resultLabel;
@property (strong, nonatomic)  LMPopInputPasswordView *popView;

@property (strong, nonatomic)  BluetoothDataManage *bluetoothDataManage;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *backImage = [UIImage imageNamed:@"loginView"];
    self.view.layer.contents = (id)backImage.CGImage;
    [self setNavItem];
    
    self.deviceLabel = [self deviceLabel];
    self.addButton = [self addButton];
    self.deviceTable = [self deviceTable];
    [self setMowerTime];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.bluetoothDataManage = [BluetoothDataManage shareInstance];
    GizManager *manager = [GizManager shareInstance];
    [GizWifiSDK sharedInstance].delegate = self;
    [[GizWifiSDK sharedInstance] getBoundDevices:manager.uid token:manager.token];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePinCode) name:@"updatePinCode" object:nil];
  
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updatePinCode" object:nil];
}

#pragma mark - Lazy load
- (void)setNavItem{
    self.navigationItem.title = LocalString(@"Device List");
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"Cancel";
    self.navigationItem.backBarButtonItem = backItem;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 30, 30);
    [rightButton.widthAnchor constraintEqualToConstant:30].active = YES;
    [rightButton.heightAnchor constraintEqualToConstant:30].active = YES;
    [rightButton setImage:[UIImage imageNamed:@"ic_nav_more_white"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;

}

- (UILabel *)deviceLabel{
    if (!_deviceLabel) {
        _deviceLabel = [[UILabel alloc] init];
        _deviceLabel.font = [UIFont systemFontOfSize:15.f];
        _deviceLabel.backgroundColor = [UIColor clearColor];
        _deviceLabel.textColor = [UIColor whiteColor];
        _deviceLabel.textAlignment = NSTextAlignmentCenter;
        _deviceLabel.text = LocalString(@"Please select a device or add a new one");
//        //自动折行设置
//        [_deviceLabel setLineBreakMode:NSLineBreakByWordWrapping];
//        _deviceLabel.numberOfLines = 0;
//        _deviceLabel.textAlignment = NSTextAlignmentLeft;
        _deviceLabel.adjustsFontSizeToFitWidth = YES;
        [self.view addSubview:_deviceLabel];
        [_deviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(280/WScale, 50/HScale));
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.top.equalTo(self.view.mas_top).offset(getRectNavAndStatusHight + 10/HScale);
        }];
    }
    return _deviceLabel;
}

- (UITableView *)deviceTable{
    if (!_deviceTable) {
        _deviceTable = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,getRectNavAndStatusHight + 70/HScale, ScreenWidth,ScreenHeight - yAutoFit(280)) style:UITableViewStylePlain];
            
            tableView.backgroundColor = [UIColor clearColor];
            tableView.dataSource = self;
            tableView.delegate = self;
            tableView.separatorColor = [UIColor clearColor];
            [tableView registerClass:[LandroidListCell class] forCellReuseIdentifier:CellIdentifier_landroid];
            [self.view addSubview:tableView];
            tableView.estimatedRowHeight = 0;
            tableView.estimatedSectionHeaderHeight = 0;
            tableView.estimatedSectionFooterHeight = 0;
            
            
            tableView.tableFooterView = [[UIView alloc] init];
            
            tableView;
        });
    }
    return _deviceTable;
}

- (UIButton *)addButton{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setTitle:LocalString(@"➕") forState:UIControlStateNormal];
        [_addButton.titleLabel setFont:[UIFont systemFontOfSize:24.f]];
        [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addButton setBackgroundColor:[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:0.6]];
        [_addButton addTarget:self action:@selector(addlandroid) forControlEvents:UIControlEventTouchUpInside];
        _addButton.enabled = YES;
        [self.view addSubview:_addButton];
        [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(280/WScale, 50/HScale));
            make.top.equalTo(self.deviceTable.mas_bottom);
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        
        _addButton.layer.borderWidth = 1.0;
        _addButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _addButton.layer.cornerRadius = 10.f/HScale;
        
        
    }
    return _addButton;
}

#pragma mark - uitableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.deviceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50/HScale;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LandroidListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_landroid];
    if (cell == nil) {
        cell = [[LandroidListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier_landroid];
    }
    GizWifiDevice *device = _deviceArray[indexPath.row];
    cell.landroidLabel.text = device.productName;

    return cell;
}
//左滑删除 设备绑定
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:LocalString(@"delete") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击了删除");
         GizWifiDevice *device = self.deviceArray[indexPath.row];
            //提示框
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:LocalString(@"Are you sure to delete ?")preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:LocalString(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                  NSLog(@"action = %@",action);
                  GizManager *manager = [GizManager shareInstance];
                  [[GizWifiSDK sharedInstance] unbindDevice:manager.uid token:manager.token did:device.did];
    
                }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LocalString(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    NSLog(@"action = %@",action);
                }];
            [alert addAction:okAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
           }];
//    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        NSLog(@"点击了编辑");
//    }];
//    editAction.backgroundColor = [UIColor grayColor];
    return @[deleteAction];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    editingStyle = UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GizWifiDevice *device = _deviceArray[indexPath.row];
    [[GizManager shareInstance] setGizDevice:device];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults integerForKey:@"pincode"]) {
        [BluetoothDataManage shareInstance].pincode = (int)[defaults integerForKey:@"pincode"];
        
        //解决如果机器不发请求 默认之前保存密码 进入页面。
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *password = [userDefaults objectForKey:@"password"];
        if ([password integerValue] == [userDefaults integerForKey:@"pincode"]) {
            RDVViewController *rdvView = [[RDVViewController alloc] init];
            rdvView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:rdvView animated:YES completion:nil];
        }
        //子线程延时1s
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self getPINData];
        });
        
    }else{
        //子线程延时1s
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self getPINData];
        });
    }
}

- (void)getPINData{
    
    NSMutableArray *dataContent = [[NSMutableArray alloc] init];
    [dataContent addObject:[NSNumber numberWithUnsignedInteger:0x00]];
    [dataContent addObject:[NSNumber numberWithUnsignedInteger:0x00]];
    [dataContent addObject:[NSNumber numberWithUnsignedInteger:0x00]];
    [dataContent addObject:[NSNumber numberWithUnsignedInteger:0x00]];
    [dataContent addObject:[NSNumber numberWithUnsignedInteger:0x00]];
    [dataContent addObject:[NSNumber numberWithUnsignedInteger:0x00]];
    [dataContent addObject:[NSNumber numberWithUnsignedInteger:0x00]];
    [dataContent addObject:[NSNumber numberWithUnsignedInteger:0x00]];
    
    [self.bluetoothDataManage setDataType:0x0c];
    [self.bluetoothDataManage setDataContent: dataContent];
    [self.bluetoothDataManage sendBluetoothFrame];
}

//接收通知
- (void)updatePinCode{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *password = [userDefaults objectForKey:@"password"];
    if ([password integerValue] == [userDefaults integerForKey:@"pincode"]) {
        RDVViewController *rdvView = [[RDVViewController alloc] init];
        rdvView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:rdvView animated:YES completion:nil];
    }else{
        _resultLabel = [[UILabel alloc] init];
        _popView = [[LMPopInputPasswordView alloc]init];
        _popView.frame = CGRectMake((self.view.frame.size.width - 250)*0.5, 50, 250, 150);
        _popView.delegate = self;
        [_popView pop];
    }
}

#pragma mark - Giz delegate

// 设备解绑实现回调
- (void)wifiSDK:(GizWifiSDK *)wifiSDK didUnbindDevice:(NSError *)result did:(NSString *)did {
    if(result.code == GIZ_SDK_SUCCESS) {
        // 解绑成功
        NSLog(@"解绑成功");
    } else {
        // 解绑失败
         NSLog(@"解绑失败");
    }
}

- (void)wifiSDK:(GizWifiSDK *)wifiSDK didDiscovered:(NSError *)result deviceList:(NSArray<GizWifiDevice *> *)deviceList{
    // 提示错误原因
    if(result.code != GIZ_SDK_SUCCESS) {
        NSLog(@"result--- %@", result.localizedDescription);
    }
   
    [self refreshTableView:deviceList];
    //NSLog(@"dasdadas%@",deviceList);
}

#pragma mark - Actions
- (void)refreshTableView:(NSArray *)listArray{
    NSLog(@"设备数量%lu",(unsigned long)listArray.count);
    NSArray *deviceList = listArray;
    NSMutableArray *deviceArray = [[NSMutableArray alloc] init];
    for (GizWifiDevice *device in deviceList) {
        if (device.isBind) {
            NSLog(@"绑定设备%@",device.productName);
        }
        if (device.netStatus == GizDeviceOnline && device.isBind) {
            [deviceArray addObject:device];
        }
    }
    self.deviceArray = deviceArray;
    [self.deviceTable reloadData];
}

- (void)addlandroid {
    addLandroidDeviceViewController *VC = [[addLandroidDeviceViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
  
//    if (@available(iOS 11.0, *)) {
//        NEHotspotConfiguration *hotspotConfig = [[NEHotspotConfiguration alloc] initWithSSID:wifiName passphrase:@"123456789" isWEP:NO];
//        // 开始连接 (调用此方法后系统会自动弹窗确认)
//
//        //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        [[NEHotspotConfigurationManager sharedManager] applyConfiguration:hotspotConfig completionHandler:^(NSError * _Nullable error) {
//            NSLog(@"aaaaa");
//            if ([[GizManager getCurrentWifi] isEqualToString:wifiName]) {
//                //[MBProgressHUD hideHUDForView:self.view animated:YES];//隐藏加载UI
//                if (error) {
//                    //无法加入网络，需移除
//                    [[NEHotspotConfigurationManager sharedManager] removeConfigurationForSSID:wifiName];
//                    [NSObject showHudTipStr:@"Can't connect hotspots"];
//                    NSLog(@"无法连接热点%@",error);
//                    [self showAlert];
//                }else{
//                    //连接wifi成功
//                    NSLog(@"连接WiFi成功");
//                    [NSObject showHudTipStr:@"Successfully connected to hotspots"];
//                    addLandroidDeviceViewController *VC = [[addLandroidDeviceViewController alloc] init];
//                    [self.navigationController pushViewController:VC animated:YES];
//                }
//            }else{
//                [self showAlert];
//            }
//        }];
//
//    }else{
//        [self showAlert];
//    }
   
}

#pragma mark ---LMPopInputPassViewDelegate
-(void)buttonClickedAtIndex:(NSUInteger)index withText:(NSString *)text
{
    NSLog(@"buttonIndex = %li password=%@",(long)index,text);
    if(index == 1){
        if(text.length == 0){
            NSLog(@"密码长度不正确Incorrect password length");
            [NSObject showHudTipStr:LocalString(@"Incorrect PIN code length")];
            [[GizManager shareInstance].device setSubscribe:GizAppproductSecret subscribed:NO]; //解除订阅
        }else if(text.length < 4){
            NSLog(@"密码长度不正确");
            [NSObject showHudTipStr:LocalString(@"Incorrect PIN code length")];
            [[GizManager shareInstance].device setSubscribe:GizAppproductSecret subscribed:NO]; //解除订阅
        }else{
            _resultLabel.text = text;
            if ([text intValue] == [BluetoothDataManage shareInstance].pincode) {
                
                RDVViewController *rdvView = [[RDVViewController alloc] init];
                rdvView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                [self presentViewController:rdvView animated:YES completion:nil];
            }else{
                NSMutableArray *dataContent = [[NSMutableArray alloc] init];
                [dataContent addObject:[NSNumber numberWithUnsignedInteger:0x00]];
                [dataContent addObject:[NSNumber numberWithUnsignedInteger:0x00]];
                [dataContent addObject:[NSNumber numberWithUnsignedInteger:0x00]];
                [dataContent addObject:[NSNumber numberWithUnsignedInteger:0x00]];
                [dataContent addObject:[NSNumber numberWithUnsignedInteger:0x00]];
                [dataContent addObject:[NSNumber numberWithUnsignedInteger:0x00]];
                [dataContent addObject:[NSNumber numberWithUnsignedInteger:0x00]];
                [dataContent addObject:[NSNumber numberWithUnsignedInteger:0x00]];
                
                [self.bluetoothDataManage setDataType:0x0c];
                [self.bluetoothDataManage setDataContent: dataContent];
                [self.bluetoothDataManage sendBluetoothFrame];
                
                [NSObject showHudTipStr:LocalString(@"Incorrect PIN code")];
                [[GizManager shareInstance].device setSubscribe:GizAppproductSecret subscribed:NO]; //解除订阅
            }
            /*if ([_resultLabel.text isEqualToString:@"1234"]) {
             RDVViewController *rdvView = [[RDVViewController alloc] init];
             rdvView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
             [self presentViewController:rdvView animated:YES completion:nil];
             }*/
        }
    }else{
         [[GizManager shareInstance].device setSubscribe:GizAppproductSecret subscribed:NO]; //解除订阅
    }
}

-(void)deviceOrientationDidChange:(NSObject*)sender{
    UIDevice* device = [sender valueForKey:@"object"];
    if(device.orientation==UIInterfaceOrientationLandscapeLeft||device.orientation==UIInterfaceOrientationLandscapeRight)
    {
        _popView.frame = CGRectMake((self.view.frame.size.width - 250)*0.5, 50, 250, 150);
    }
    else if(device.orientation==UIInterfaceOrientationPortrait||device.orientation==UIInterfaceOrientationPortraitUpsideDown)
    {
        _popView.frame = CGRectMake((self.view.frame.size.width - 250)*0.5, 50, 250, 150);
    }
}

//校准机器时间
- (void)setMowerTime{
    NSDate *date = [NSDate date];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];    //IOS 8 之后
    NSUInteger integer = NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *dataCom = [currentCalendar components:integer fromDate:date];
    
    NSMutableArray *dataContent = [[NSMutableArray alloc] init];
    [dataContent addObject:[NSNumber numberWithUnsignedInteger:[dataCom year] / 100]];
    [dataContent addObject:[NSNumber numberWithUnsignedInteger:[dataCom year] % 100]];
    [dataContent addObject:[NSNumber numberWithUnsignedInteger:[dataCom month]]];
    [dataContent addObject:[NSNumber numberWithUnsignedInteger:[dataCom day]]];
    [dataContent addObject:[NSNumber numberWithUnsignedInteger:[dataCom hour]]];
    [dataContent addObject:[NSNumber numberWithUnsignedInteger:[dataCom minute]]];
    [dataContent addObject:[NSNumber numberWithUnsignedInteger:0x00]];
    [dataContent addObject:[NSNumber numberWithUnsignedInteger:0x00]];
    
    [self.bluetoothDataManage setDataType:0x02];
    [self.bluetoothDataManage setDataContent: dataContent];
    [self.bluetoothDataManage sendBluetoothFrame];
}

- (void)logout{
    NSLog(@"注销登录");
//    //提示框
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalString(@"Alerts")message:LocalString(@"Are you sure to log out?")preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:LocalString(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//          [self dismissViewControllerAnimated:YES completion:nil];
//          NSLog(@"action = %@",action);
//        }];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LocalString(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
//            [self.navigationController popToRootViewControllerAnimated:YES];
//            NSLog(@"action = %@",action);
//        }];
//    [alert addAction:okAction];
//    [alert addAction:cancelAction];
//    [self presentViewController:alert animated:YES completion:nil];
//
        //显示弹出框列表选择
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:LocalString(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            //响应事件
            [self.navigationController popToRootViewControllerAnimated:YES];
            NSLog(@"action = %@", action);
        }];
        UIAlertAction* sureAction = [UIAlertAction actionWithTitle:LocalString(@"log out") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
            //响应事件
            [self dismissViewControllerAnimated:YES completion:nil];
            NSLog(@"action = %@", action);
        }];
    
        [alert addAction:cancelAction];
        [alert addAction:sureAction];
        [self presentViewController:alert animated:YES completion:nil];

}

@end
