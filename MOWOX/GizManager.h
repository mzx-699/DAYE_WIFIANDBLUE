//
//  GizManager.h
//  MOWOX
//
//  Created by 杭州轨物科技有限公司 on 2018/12/19.
//  Copyright © 2018年 yusz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GizManager : NSObject <GizWifiDeviceDelegate>
///单例模式
+ (instancetype)shareInstance;

///@brief 获取当前Wi-Fi的ssid
+ (NSString *)getCurrentWifi;

///@brief 机智云登录信息
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) GizWifiDevice *device;
@property (nonatomic, strong) NSString *did;

///@brief 配网wifi ssid key
@property (nonatomic, strong) NSString *ssid;
@property (nonatomic, strong) NSString *key;


- (void)sendTransparentDataByGizWifiSDK:(NSDictionary *)sendData;
- (void)setGizDevice:(GizWifiDevice *)device;
@end

NS_ASSUME_NONNULL_END
