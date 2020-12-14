//
//  HDLoadObj.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2019/11/4.
//  Copyright © 2019 HarryDeng. All rights reserved.
//

#import "HDLoadObj.h"

@implementation HDLoadObj

+ (void)load {
    NSLog(@"^^^ HDLoadObj load");
}

+ (void)initialize {
    NSLog(@"^^^ HDLoadObj initialize");
}


+ (NSString *)isJDProxyOpened {
    BOOL isProxy = NO;
    CFDictionaryRef arrayRef = CFNetworkCopySystemProxySettings();
    CFURLRef urlref = (__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"http://api.m.jd.com"]);
    NSArray *proxies = CFBridgingRelease(CFNetworkCopyProxiesForURL(urlref, arrayRef));
    if (proxies.count > 0) {
        NSDictionary *settings = [proxies objectAtIndex:0];
        if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"]){
            isProxy = NO;
        }else{
            isProxy = YES;
        }
    }
    return isProxy ? @"1":@"0";
}

+ (NSString *)isJDProxyOpened2 {
    BOOL isProxy = NO;
    NSDictionary *proxySettings =  (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"http://api.m.jd.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    if (proxies.count > 0) {
        NSDictionary *settings = [proxies objectAtIndex:0];
        if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"]){
            isProxy = NO;
        }else{
            isProxy = YES;
        }
    }
    return isProxy ? @"1":@"0";
}


@end
