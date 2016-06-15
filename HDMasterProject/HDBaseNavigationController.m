//
//  HDBaseNavigationController.m
//  HDMasterProject
//
//  Created by Harry on 16/6/15.
//  Copyright © 2016年 HarryDeng. All rights reserved.
//

#import "HDBaseNavigationController.h"

@interface HDBaseNavigationController ()

@end

@implementation HDBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
