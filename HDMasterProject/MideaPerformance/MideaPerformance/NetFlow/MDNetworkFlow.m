//
//  MDNetworkFlow.m
//  MideaPerformanceDemo
//
//  Created by ZhangJingHao48 on 2019/7/9.
//  Copyright © 2019 ZhangJingHao48. All rights reserved.
//

#import "MDNetworkFlow.h"
#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>
#include <net/if_dl.h>

@implementation MDNetFlowModel

+ (NSString *)convertBytes:(long)bytes {
    if (bytes < 1024) {
        return [NSString stringWithFormat:@"%.3fKB", (double)bytes / 1024];
    }
    return [NSString stringWithFormat:@"%.1fKB", (double)bytes / 1024];
}

@end


@implementation MDNetworkFlow

/**
 *  WiFiSent WiFi发送流量
 *  WiFiReceived WiFi接收流量
 *  WWANSent 移动网络发送流量
 *  WWANReceived 移动网络接收流量
 */
+ (MDNetFlowModel *)getTrafficMonitorings {
    BOOL success;
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    const struct if_data *networkStatisc;
    long WiFiSent = 0;
    long WiFiReceived = 0;
    long WWANSent = 0;
    long WWANReceived = 0;
    NSString *name=[[NSString alloc]init];
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            name=[NSString stringWithFormat:@"%s",cursor->ifa_name];
            
            if (cursor->ifa_addr->sa_family == AF_LINK) {
                //wifi消耗流量
                if ([name hasPrefix:@"en"]) {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WiFiSent+=networkStatisc->ifi_obytes;
                    WiFiReceived+=networkStatisc->ifi_ibytes;
                }
                
                //移动网络消耗流量
                if ([name hasPrefix:@"pdp_ip0"]) {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WWANSent+=networkStatisc->ifi_obytes;
                    WWANReceived+=networkStatisc->ifi_ibytes;
                }
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    
    MDNetFlowModel *model = [MDNetFlowModel new];
    model.WiFiSent = WiFiSent;
    model.WiFiReceived = WiFiReceived;
    model.WiFiTotalTraffic = WiFiSent + WiFiReceived;
    model.WWANSent = WWANSent;
    model.WWANReceived = WWANReceived;
    model.WWANTotalTraffic = WWANSent+WWANReceived;
    return model;
}

@end
