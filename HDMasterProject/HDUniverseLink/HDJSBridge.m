//
//  HDJSBridge.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2020/6/15.
//  Copyright © 2020 HarryDeng. All rights reserved.
//

#import "HDJSBridge.h"

#import <objc/message.h>

static NSString *hdjsobjname = @"hdjsobj";

@implementation HDJSBridge

+ (void)addCustomJS:(WKWebView *)wkWebView scriptMessageHandler:(id <WKScriptMessageHandler>)controller {
    NSString *jsPath = [NSBundle.mainBundle pathForResource:@"hdjssdk" ofType:@"js"];
    if (!jsPath) {
        NSLog(@"js路径不存在");
        return;
    }
    
    NSError *error = nil;
    NSString *injectJS = [NSString stringWithContentsOfFile:jsPath encoding:NSUTF8StringEncoding error:&error];
    if (!injectJS) {
        NSLog(@"获取js文件失败");
        return;
    }
    
    WKUserScript *script = [[WKUserScript alloc] initWithSource:injectJS injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [wkWebView.configuration.userContentController addUserScript:script];
    [wkWebView.configuration.userContentController addScriptMessageHandler:controller name:hdjsobjname];
}

+ (BOOL)disposeHDJSObj:(WKScriptMessage *)message wkWebView:(WKWebView *)wkWebView controller:(UIViewController *)controller {
    if (![message.name isEqualToString:hdjsobjname]) {
        return NO;
    }
    
    NSDictionary *body = [self disposeMessageBody:message.body];
    if (![body isKindOfClass:NSDictionary.class]) {
        return NO;
    }
    
    NSString *method = body[@"method"];
    if (!method) {
        return NO;
    }
    
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@:wkWebView:controller:", method]);
    if (![self respondsToSelector:selector]) {
        return NO;
    }
    ((void(*)(id, SEL, NSString *, WKWebView *, UIViewController *))objc_msgSend)(self, selector, body[@"params"], wkWebView, controller);
    return YES;
}

+ (void)hdWantSleep:(NSString *)params wkWebView:(WKWebView *)wkWebView controller:(UIViewController *)controller {
    NSLog(@"hdWantSleep : %@", params);
}


+ (NSDictionary *)disposeMessageBody:(id)body {
    if (body == nil) {
        return nil;
    }
    NSDictionary *params;
    if ([body isKindOfClass:NSString.class]) {
        NSData *jsonData = [body dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *parmdic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
        params = parmdic;
    }
    else if ([body isKindOfClass:NSDictionary.class]) {
        params = (NSDictionary *)body;
    }
    return params;
}

@end

