//
//  HDNextPresentDemo.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2019/9/24.
//  Copyright © 2019 HarryDeng. All rights reserved.
//

#import "HDNextPresentDemo.h"

@interface HDNextPresentDemo ()

@property (nonatomic, strong) UIViewController *parentVC;

@end

@implementation HDNextPresentDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeInfoDark];
    bt.frame = CGRectMake(200, 100, 40, 40);
    [bt addTarget:self action:@selector(modalAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
}

- (void)modalAction {
    
    self.parentVC = [self.class currentVC];
    
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

+ (UIViewController *)currentVC {
    if (![[UIApplication sharedApplication].windows.lastObject isKindOfClass:[UIWindow class]]) {
        NSAssert(0, @"未获取到当前控制器");
        return nil;
    }
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self getCurrentNCFrom:rootViewController];
}

//递归
+ (UIViewController *)getCurrentNCFrom:(UIViewController *)vc {
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UINavigationController *nc = ((UITabBarController *)vc).selectedViewController;
        return [self getCurrentNCFrom:nc];
    }
    else if ([vc isKindOfClass:[UINavigationController class]]) {
        if (((UINavigationController *)vc).presentedViewController) {
            return [self getCurrentNCFrom:((UINavigationController *)vc).presentedViewController];
        }
        return [self getCurrentNCFrom:((UINavigationController *)vc).topViewController];
    }
    else if ([vc isKindOfClass:[UIViewController class]]) {
        if (vc.presentedViewController) {
            return [self getCurrentNCFrom:vc.presentedViewController];
        }
        else {
            return vc;
        }
    }
    else {
        NSAssert(0, @"未获取到当前控制器");
        return nil;
    }
}


@end
