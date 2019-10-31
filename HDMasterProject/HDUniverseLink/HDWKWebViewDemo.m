//
//  HDWKWebViewDemo.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2019/10/24.
//  Copyright © 2019 HarryDeng. All rights reserved.
//

#import "HDWKWebViewDemo.h"

#import <WebKit/WebKit.h>

@interface HDWKWebViewDemo () <WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, assign) BOOL shouldUL;

@end

@implementation HDWKWebViewDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _shouldUL = YES;
    if (random() % 2 == 0) {
        _shouldUL = NO;
    }
    
    WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
    WKUserContentController *userContentController =[[WKUserContentController alloc]init];
    configuration.userContentController = userContentController;

    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"jingxi.html" withExtension:nil];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@",[[NSBundle mainBundle] pathForResource:@"jingxi" ofType:@"html"]]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{

}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{

}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{

}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{

}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{

}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{

    NSLog(@"decidePolicyForNavigationResponse %@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{

     NSLog(@"decidePolicyForNavigationAction %@",navigationAction.request.URL.absoluteString);
    
    
    NSURL *url = navigationAction.request.URL;
    NSString *urlString = (url) ? url.absoluteString : @"";
    
    // iTunes: App Store link
    // 例如，微信的下载链接: https://itunes.apple.com/cn/app/id414478124?mt=8
    // 京喜：itms-apps://itunes.apple.com/cn/app/京东拼购/id1453661340?l=zh&ls=1&mt=8
    if ([urlString containsString:@"//itunes.apple.com/"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    
    if (_shouldUL) {
        //允许跳转
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    else {
        // 允许跳转 但是UL不能进行跳转
        // http://awhisper.github.io/2018/01/08/wechatkilluniversallink/
        decisionHandler(WKNavigationActionPolicyAllow + 2);
    }

    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}


#pragma mark - WKUIDelegate
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    return [[WKWebView alloc]init];
}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    completionHandler(@"http");
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    completionHandler(YES);
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@",message);
    completionHandler();
}

@end
