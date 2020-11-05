//
//  HDNetMonitor.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2020/10/22.
//  Copyright © 2020 HarryDeng. All rights reserved.
//

#import "HDNetMonitor.h"

#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

@interface HDNetMonitor ()

@property (nonatomic, assign)long long int lastBytes;
@property (nonatomic, assign)BOOL isFirstRate;

@end

@implementation HDNetMonitor

- (long long) getInterfaceBytes {
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1) {
        return 0;
    }

    uint32_t iBytes = 0;//下行
    uint32_t oBytes = 0;//上行
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next) {
        if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;

        if (ifa->ifa_data == 0)
            continue;
        
        /* Not a loopback device. */
        if (strncmp(ifa->ifa_name, "lo", 2)) {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            iBytes += if_data->ifi_ibytes;
            oBytes += if_data->ifi_obytes;
        }
    }
    
    freeifaddrs(ifa_list);
    
    NSLog(@"\n[getInterfaceBytes-Total]%d,%d",iBytes, oBytes);
    return iBytes;
    
}

- (void)getInternetface {
    long long int currentBytes = [self getInterfaceBytes];
    //用上当前的下行总流量减去上一秒的下行流量达到下行速录
    long long int rate = currentBytes -self.lastBytes;
    
    //保存上一秒的下行总流量
    self.lastBytes = [self getInterfaceBytes];
    //格式化一下
    NSString*rateStr = [self formatNetWork:rate];
    
    NSLog(@"当前网速%@",rateStr);
}

- (NSString*)formatNetWork:(long long int)rate {
    
    if(rate <1024) {
        
        return[NSString stringWithFormat:@"%lldB/秒", rate];
        
    }else if(rate >=1024&& rate <1024*1024) {
        
        return[NSString stringWithFormat:@"%.1fKB/秒", (double)rate /1024];
        
    }else if(rate >=1024*1024 && rate <1024*1024*1024){
        
        return[NSString stringWithFormat:@"%.2fMB/秒", (double)rate / (1024*1024)];
        
    }else{
        return@"10Kb/秒";
    };
}

@end
