//
//  HDJSBridge.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2020/6/15.
//  Copyright © 2020 HarryDeng. All rights reserved.
//

#import "HDJSBridge.h"

#import <objc/message.h>

NSString * const hdjsobjname = @"hdjsobj";

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
    
    NSString *callback = body[@"callback"];
    
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@:message:controller:callback:", method]);
    if (![self respondsToSelector:selector]) {
        return NO;
    }
    ((void(*)(id, SEL, NSString *, WKScriptMessage *, UIViewController *, NSString *))objc_msgSend)(self, selector, body[@"params"], message, controller, callback);
    return YES;
}

+ (void)hdWantSleep:(NSString *)params message:(WKScriptMessage *)message controller:(UIViewController *)controller callback:(NSString *)callback {
    NSLog(@"[js to oc] hdWantSleep : %@", params);
    
    if (callback) {
        [self callbackMessage:message result:@{@"result" : @"already sleep"} callbackName:callback];
    }
}

+ (void)hdWantRun:(NSString *)params message:(WKScriptMessage *)message controller:(UIViewController *)controller callback:(NSString *)callback {
    NSLog(@"[js to oc] hdWantRun : %@", params);
    
    if (callback) {
        [self callbackMessage:message result:@{@"result" : @"already running"} callbackName:callback];
    }
}


+ (void)callbackMessage:(WKScriptMessage *)message result:(NSDictionary *)result callbackName:(NSString *)callbackName {
    if (!callbackName) {
        return;
    }
    
    NSDictionary *callbackMessage = @{
        @"result" : result ? : @{},
        @"callback" : callbackName,
    };
    NSString *json = [self disposeCallbackMessage:callbackMessage];
    NSString *jsString = [NSString stringWithFormat:@"hdjsobj.hdCallBack(%@)", json];
    [message.webView evaluateJavaScript:jsString completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"result: %@ error: %@", result, error);
    }];
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

+ (NSString *)disposeCallbackMessage:(NSDictionary *)messageDic {
    NSData *data =  [NSJSONSerialization dataWithJSONObject:messageDic options:NSJSONWritingPrettyPrinted error:nil];
    if (!data) {
        return @"";
    }
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return jsonString;
}

@end

