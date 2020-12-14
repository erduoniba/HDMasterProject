//
//  HDNetDemoViewController.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2020/10/22.
//  Copyright © 2020 HarryDeng. All rights reserved.
//

#import "HDNetDemoViewController.h"

#import <WebKit/WebKit.h>

#import "HDNetMonitor.h"

@interface HDNetDemoViewController ()

@end

@implementation HDNetDemoViewController {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        for (int i=0; i<10000000; i++) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * 1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                // 有问题
//                [[[HDNetMonitor alloc] init] getInternetface];
//                
//                NSURL *url = [NSURL URLWithString:@"https://jd.com/"];
//                NSURLRequest *request = [NSURLRequest requestWithURL:url];
//                [[[WKWebView alloc] init] loadRequest:request];
//            });
//        }
//    });
    
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(100, 200, 200, 30)];
    tf.secureTextEntry = YES;
    [self.view addSubview:tf];
    
    UITextField *tf2 = [[UITextField alloc] initWithFrame:CGRectMake(100, 230, 200, 30)];
    tf2.secureTextEntry = NO;
    [self.view addSubview:tf2];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
