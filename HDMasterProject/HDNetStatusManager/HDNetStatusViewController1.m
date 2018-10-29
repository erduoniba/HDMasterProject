//
//  HDNetStatusViewController1.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2018/10/27.
//  Copyright © 2018年 HarryDeng. All rights reserved.
//

#import "HDNetStatusViewController1.h"
#import "HDNetStatusViewController2.h"

#import "HDNetStatusManager.h"

@interface HDNetStatusViewController1 ()

@end

@implementation HDNetStatusViewController1

- (void)dealloc {
    NSLog(@"HDNetStatusViewController1 dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];

    HDNetStatusManager *manager = [HDNetStatusManager sharedInstance];
    NSLog(@"HDNetStatusViewController1 - currenntStauts %d", (int)manager.currenntStauts);
    [manager addNetworkChangeObserver:self networkStatus:^(HDNetStatusManager *mm, AFNetworkReachabilityStatus status) {
        NSLog(@"HDNetStatusViewController1 - status %d", (int)mm.currenntStauts);
    }];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoDark];
    button.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:button];
    [button addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)nextAction {
    [self.navigationController pushViewController:HDNetStatusViewController2.new animated:YES];
}

@end
