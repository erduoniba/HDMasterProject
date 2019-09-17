//
//  MideaPerformanceMgr.m
//  MideaPerformanceDemo
//
//  Created by ZhangJingHao48 on 2019/7/6.
//  Copyright © 2019 ZhangJingHao48. All rights reserved.
//

#import "MideaPerformance.h"
#import "MDPerformanceView.h"
#import "MDFloatingBall.h"
#import "MDPerformanceViewController.h"
#import "MDFloatingBallManager.h"

@implementation MideaPerformance

+ (void)showMonitorView {
    [MDFloatingBallManager shareManager].appKeyWindow =
    [UIApplication sharedApplication].keyWindow;
    
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat pWH = 100;
    CGFloat pY = height - pWH - 100;
    CGRect pFrame = CGRectMake(100, pY, pWH, pWH);
    MDPerformanceView *performanceView = [[MDPerformanceView alloc] initWithFrame:pFrame];
    performanceView.layer.cornerRadius = pFrame.size.width / 2;
    performanceView.layer.masksToBounds = YES;
    
    MDFloatingBall *floating = [[MDFloatingBall alloc] initWithFrame:pFrame];
    floating.edgePolicy = MDFloatingBallEdgePolicyLeftRight;
    floating.autoCloseEdge = YES;
    [floating setContent:performanceView contentType:MDFloatingBallContentTypeCustomView];
    [floating show];
    floating.clickHandler = ^(MDFloatingBall * _Nonnull floatingBall) {
        [self dealClickHanderWithPerformanceView:performanceView];
    };
}

+ (void)dealClickHanderWithPerformanceView:(MDPerformanceView *)performanceView {
    if ([MDFloatingBallManager shareManager].isShowSettingView) {
        return;
    }
    [MDFloatingBallManager shareManager].isShowSettingView = YES;
    
    UIViewController *topVC = [self getCurrentViewController];
    MDPerformanceViewController *pVc = [[MDPerformanceViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pVc];
    [topVC presentViewController:nav animated:YES completion:nil];
    pVc.clickCloseBlock = ^{
        [MDFloatingBallManager shareManager].isShowSettingView = NO;
    };
    
    performanceView.timerBlock = pVc.timerBlock;
    pVc.settingChangeBlock = performanceView.settingChangeBlock;
}

// 获取当前所在的视图
+ (UIViewController *)getCurrentViewController {
    UIViewController *topController = [UIApplication sharedApplication].delegate.window.rootViewController;
    while ([topController presentedViewController]) {
        topController = [topController presentedViewController];
    }
    if ([topController isKindOfClass:[UITabBarController class]]) {
        topController = [(UITabBarController *)topController selectedViewController];
    }
    while ([topController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topController topViewController])
        topController = [(UINavigationController*)topController topViewController];
    
    return topController;
}


@end
