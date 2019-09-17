//
//  MDNetworkFlow.h
//  MideaPerformanceDemo
//
//  Created by ZhangJingHao48 on 2019/7/9.
//  Copyright © 2019 ZhangJingHao48. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDNetFlowModel : NSObject

/// WiFi发送流量
@property (nonatomic, assign) long WiFiSent;
/// WiFiReceived WiFi接收流量
@property (nonatomic, assign) long WiFiReceived;
/// WiFi 传输总流量
@property (nonatomic, assign) long WiFiTotalTraffic;

/// WWANSent 移动网络发送流量
@property (nonatomic, assign) long WWANSent;
/// WWANReceived 移动网络接收流量
@property (nonatomic, assign) long WWANReceived;
/// WWAN传输总流量
@property (nonatomic, assign) long WWANTotalTraffic;

+ (NSString *)convertBytes:(long)bytes;

@end

NS_ASSUME_NONNULL_BEGIN

@interface MDNetworkFlow : NSObject

+ (MDNetFlowModel *)getTrafficMonitorings;

@end

NS_ASSUME_NONNULL_END
