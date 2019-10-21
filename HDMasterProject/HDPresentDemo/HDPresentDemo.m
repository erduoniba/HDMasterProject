//
//  HDPresentDemo.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2019/9/24.
//  Copyright © 2019 HarryDeng. All rights reserved.
//

#import "HDPresentDemo.h"

#import "HDNextPresentDemo.h"

@interface HDPresentDemo ()

@end

@implementation HDPresentDemo {
    BOOL isFirst;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeInfoDark];
    bt.frame = CGRectMake(200, 100, 40, 40);
    [bt addTarget:self action:@selector(modalAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
    
    isFirst = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (isFirst) {
        [self modalAction];
    }
    isFirst = NO;
}

- (void)modalAction {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:HDNextPresentDemo.new];
    [[self.class currentVC] presentViewController:nav animated:NO completion:^{
        
    }];
    
    [self setLocal:@"xxx" item:@"UINavigationControllerUINavigationControllerUINavigationControllerUINavigationController"];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"localValue : %@", [self getLocal:@"xxx"]);
    });
}

- (void)setLocal:(NSString *)key item:(NSString *)item{
    [[NSUserDefaults standardUserDefaults] setValue:item forKey:key];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSUserDefaults standardUserDefaults] synchronize];
    });
}

- (NSString *)getLocal:(NSString *)key{
    NSString *localValue = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    return localValue;
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
