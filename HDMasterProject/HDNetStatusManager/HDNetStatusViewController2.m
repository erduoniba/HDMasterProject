//
//  HDNetStatusViewController2.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2018/10/27.
//  Copyright © 2018年 HarryDeng. All rights reserved.
//

#import "HDNetStatusViewController2.h"

#import "HDNetStatusManager.h"

@interface HDNetStatusViewController2 ()

@end

@implementation HDNetStatusViewController2

- (void)dealloc {
    NSLog(@"HDNetStatusViewController2 dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];

    HDNetStatusManager *manager = [HDNetStatusManager sharedInstance];
    NSLog(@"HDNetStatusViewController2 - currenntStauts %d", (int)manager.currenntStauts);
    [manager addNetworkChangeObserver:self networkStatus:^(HDNetStatusManager *mm, AFNetworkReachabilityStatus status) {
        NSLog(@"HDNetStatusViewController2 - status %d", (int)mm.currenntStauts);
    }];
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
