//
//  HDWKWebViewDemo.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2019/10/24.
//  Copyright © 2019 HarryDeng. All rights reserved.
//

#import "HDWKWebViewDemo.h"

#import <WebKit/WebKit.h>

#import "HDJSBridge.h"

@interface HDWKWebViewDemo () <WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, assign) BOOL shouldUL;

@end

@implementation HDWKWebViewDemo

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _shouldUL = YES;
    if (random() % 2 == 0) {
        _shouldUL = NO;
    }
    
    // 配置环境
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    // WKUserContentController实现js native交互。
    WKUserContentController *userContentController =[[WKUserContentController alloc] init];
    configuration.userContentController = userContentController;
    
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    // WKUIDelegate主要处理JS脚本，确认框、警告框等
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    
    // 注册一个name为sayHello的js方法
    [userContentController addScriptMessageHandler:self name:@"sayHello"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@",[[NSBundle mainBundle] pathForResource:@"jingxi" ofType:@"html"]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
    // 注册自定义的js方法到h5中，无需每个h5都去加载js，通过对象管理
    [HDJSBridge addCustomJS:_webView scriptMessageHandler:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 页面离开并且回到父视图下
    if (self.isMovingFromParentViewController) {
        // 这里需要注意，前面增加过的方法一定要remove掉。
        [_webView.configuration.userContentController removeScriptMessageHandlerForName:@"sayHello"];
        [_webView.configuration.userContentController removeScriptMessageHandlerForName:hdjsobjname];
    }
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"didStartProvisionalNavigation : %@", navigation);
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"didCommitNavigation : %@", navigation);
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"didFinishNavigation : %@", navigation);
    [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        NSLog(@"navigator.userAgent: %@", response);
    }];
    
    // oc调用JS方法
    [self.webView evaluateJavaScript:@"say()" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"[oc call js] result: %@", result);
    }];
}

// error
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    // 类似 UIWebView 的- webView:didFailLoadWithError:
    NSLog(@"webView:didFailProvisionalNavigation:withError: 启动时加载数据发生错误就会调用这个方法。  \n\n");
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"webView:didFailNavigation: 当一个正在提交的页面在跳转过程中出现错误时调用这个方法。  \n\n");
}


// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"didReceiveServerRedirectForProvisionalNavigation : %@", navigation);
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
    
    if ([urlString containsString:@"openapp.jdpingou"]) {
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

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    NSLog(@"webViewWebContentProcessDidTerminate 网页加载内容进程终止");
}


#pragma mark - WKUIDelegate
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    return [[WKWebView alloc] init];
}

// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    NSLog(@"runJavaScriptTextInputPanelWithPrompt");
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


#pragma mark - WKScriptMessageHandler
/// js调用oc代码在这里处理
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"[js to oc] didReceiveScriptMessage name:%@ \n body:%@ \n",message.name, message.body);
    if ([HDJSBridge disposeHDJSObj:message wkWebView:_webView controller:self]) {
        return;
    }
}

@end
