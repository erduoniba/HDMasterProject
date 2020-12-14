//
//  HDJSBridge.h
//  HDMasterProject
//
//  Created by 邓立兵 on 2020/6/15.
//  Copyright © 2020 HarryDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <WebKit/WebKit.h>

extern NSString * _Nonnull const hdjsobjname;

NS_ASSUME_NONNULL_BEGIN

@interface HDJSBridge : NSObject

+ (void)addCustomJS:(WKWebView *)wkWebView scriptMessageHandler:(id <WKScriptMessageHandler>)controller;

+ (BOOL)disposeHDJSObj:(WKScriptMessage *)message wkWebView:(WKWebView *)wkWebView controller:(UIViewController *)controller;

@end

NS_ASSUME_NONNULL_END
