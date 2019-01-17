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

static NSString *hdhd = nil;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    HDNetStatusManager *manager = [HDNetStatusManager sharedInstance];
    NSLog(@"HDNetStatusViewController2 - networkReachabilityStatus %d", (int)manager.networkReachabilityStatus);
    [manager addNetworkChangeObserver:self networkStatus:^(HDNetStatusManager *mm, AFNetworkReachabilityStatus status) {
        NSLog(@"HDNetStatusViewController2 - status %d", (int)mm.networkReachabilityStatus);
    }];


    if (hdhd.length == 0) {
        hdhd = [[NSUserDefaults standardUserDefaults] stringForKey:@"hdhd"];

        if (hdhd.length == 0) {
            hdhd = [NSString stringWithFormat:@"hello %d", rand()];
            [[NSUserDefaults standardUserDefaults] setObject:hdhd forKey:@"hdhd"];
        }
    }

    NSLog(@"ssss : %@", hdhd);
    
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    view.image = [UIImage imageNamed:@"home_refresh"];
    [self.view addSubview:view];
    
    UISwitch *ss = [[UISwitch alloc] initWithFrame:CGRectMake(100, 300, 100, 100)];
    [self.view addSubview:ss];
    

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
