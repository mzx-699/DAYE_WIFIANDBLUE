//
//  GizManager.m
//  MOWOX
//
//  Created by 杭州轨物科技有限公司 on 2018/12/19.
//  Copyright © 2018年 yusz. All rights reserved.
//

#import "GizManager.h"
#import <SystemConfiguration/CaptiveNetwork.h>

static GizManager *_gizManager = nil;

@implementation GizManager

+ (instancetype)shareInstance{
    if (_gizManager == nil) {
        _gizManager = [[self alloc] init];
    }
    return _gizManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t oneToken;
    
    dispatch_once(&oneToken, ^{
        if (_gizManager == nil) {
            _gizManager = [super allocWithZone:zone];
        }
    });
    
    return _gizManager;
}

#pragma mark - set
- (void)setGizDevice:(GizWifiDevice *)device{
    if (self.device) {
        self.device.delegate = nil;
    }
    self.device = device;
    self.device.delegate = self;
    if (self.device.isSubscribed) {
        return;
    }
    [self.device setSubscribe:NULL subscribed:YES];
}

#pragma mark - Giz Control
- (void)sendTransparentDataByGizWifiSDK:(NSDictionary *)sendData{
    if (!self.device) {
        return;
    }
    NSLog(@"发送透传数据---%@",sendData);
    [self.device write:sendData withSN:100];
}

#pragma mark - Giz delegate
- (void)device:(GizWifiDevice *)device didSetSubscribe:(NSError *)result isSubscribed:(BOOL)isSubscribed{
    NSLog(@"subscribeResult---- %@",result);
}

- (void)device:(GizWifiDevice *)device didReceiveAttrStatus:(NSError *)result attrStatus:(NSDictionary *)attrStatus adapterAttrStatus:(NSDictionary *)adapterAttrStatus withSN:(NSNumber *)sn{
    if (result.code == GIZ_SDK_SUCCESS) {
        NSLog(@"设备透传返回信息: %@",attrStatus);
        NSLog(@"设备透传返回sn: %@",sn);
        
        NSData *data = [attrStatus objectForKey:@"binary"];
        
        NSMutableArray *dataArray = [NSMutableArray new];
        NSData *recvBuffer = [NSData dataWithData:data];
        NSUInteger recvLen = [recvBuffer length];
        UInt8 *recv = (UInt8 *)[recvBuffer bytes];
        //把接收到的数据存放在recvData数组中
        NSUInteger j = 0;
        while (j < recvLen) {
            [dataArray addObject:[NSNumber numberWithUnsignedChar:recv[j]]];
            j++;
        }
        [[BluetoothDataManage shareInstance] handleData:dataArray];
        
    }else{
        NSLog(@"result---- %@",result);
    }
}

#pragma 获取设备当前连接的WIFI的SSID
+ (NSString *)getCurrentWifi{
    
    NSString * wifiName = @"";
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces) {
        wifiName = @"";
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    for (NSString *interfaceName in interfaces) {
        
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        if (dictRef) {
            
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            CFRelease(dictRef);
        }
    }
    
    //CFRelease(wifiInterfaces);
    return wifiName;
}

@end
