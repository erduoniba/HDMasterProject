//
//  LJ_BaseViewController.m
//  MideaPerformanceDemo
//
//  Created by ZhangJingHao48 on 2019/9/3.
//  Copyright © 2019 ZhangJingHao48. All rights reserved.
//

#import "LJ_BaseViewController.h"
#import "MDFloatingBallManager.h"

@interface LJ_BaseViewController ()

@end

@implementation LJ_BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *item1 =
    [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                     style:UIBarButtonItemStyleDone
                                    target:self
                                    action:@selector(clickBackBtn)];
    UIBarButtonItem *item2 =
    [[UIBarButtonItem alloc] initWithTitle:@"关闭"
                                     style:UIBarButtonItemStyleDone
                                    target:self
                                    action:@selector(clickQuitBtn)];
    
    self.navigationItem.leftBarButtonItems = @[item1, item2];
}

- (void)clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickQuitBtn {
    [self dismissViewControllerAnimated:YES completion:nil];

    [MDFloatingBallManager shareManager].isShowSettingView = NO;
}


@end
