//
//  AppDelegate.m
//  HDMasterProject
//
//  Created by Harry on 16/4/27.
//  Copyright © 2016年 HarryDeng. All rights reserved.
//

#import "AppDelegate.h"

#import <HDSubProjectOne/HDSubProjectOne.h>
#import <HDSubProjectTwo/HDSubProjectTwo.h>

#import <JSPatch/JSPatch.h>
#import "ViewController.h"
#import "HDDDLog.h"

#import <IQKeyboardManager/IQKeyboardManager.h>

#import "HDNetStatusManager/HDNetStatusManager.h"

static NSString *const leancloudAppId = @"0MekiRXH3vAPyw6SI3Uc6FSY-gzGzoHsz";
static NSString *const leancloudClientKey = @"iQXXT7muTw32op7OlF10YrmH";


@interface AppDelegate ()

@end

@implementation AppDelegate

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    NSString *videoAllowRotation = [[NSUserDefaults standardUserDefaults] objectForKey:@"videoAllowRotation"];
    if ([videoAllowRotation isEqualToString:@"1"]) {
        //菜谱视频跟随系统横竖屏播放
        return UIInterfaceOrientationMaskAll;
    }
    return UIInterfaceOrientationMaskPortrait;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

//    [JSPatch startWithAppKey:@"fa85a64ff99a5290"];
//
//    [JSPatch setupRSAPublicKey:@"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDpHyYFneEdiA1KmWQtr9WL7+UD\nEtqAG9eC3S1PR2ttxQs6XXMtuEEJCcsTSHazN54Q0+jZO0W1CXZABPn2wuAT44n3\nTZ9ocQP6cgFPvs0+b0eqx3Dy1sisypA8Ifr8feTDV7CVwqIrjnCdPl7qlYcpUINy\nfedwf5vAt8PhiGd8eQIDAQAB\n-----END PUBLIC KEY-----"];

    [HDSubProjectMethodOne hdSubProjectMethodOne];
    [HDSubProjectMethodTwo hdSubProjectMethodTwo];

    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;

    [self startLaunchingAnimation];

    [[HDNetStatusManager sharedInstance] startMonitoring];
    
    [HDDDLog configurationDDLog:@"HDLogs"];

    return YES;
}

- (void)dispatch{
    /*
     dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
     dispatch_group_t group = dispatch_group_create();
     
     dispatch_group_async(group, queue, ^{
     [NSThread sleepForTimeInterval:3];
     NSLog(@"Group 1");
     });
     
     dispatch_group_async(group, queue, ^{
     [NSThread sleepForTimeInterval:2];
     NSLog(@"Group 2");
     });
     
     dispatch_group_async(group, queue, ^{
     [NSThread sleepForTimeInterval:1];
     NSLog(@"Group 3");
     });
     
     dispatch_group_notify(group, queue, ^{
     NSLog(@"Update UI");
     });*/
    
    
    /*
     dispatch_queue_t queue2 = dispatch_queue_create("c", DISPATCH_QUEUE_CONCURRENT);
     dispatch_async(queue2, ^{
     [NSThread sleepForTimeInterval:1];
     
     NSLog(@"dispatch_async 1");
     });
     
     dispatch_async(queue2, ^{
     [NSThread sleepForTimeInterval:2];
     NSLog(@"dispatch_async 2");
     });
     
     dispatch_barrier_async(queue2, ^{
     NSLog(@"dispatch_barrier_async");
     });
     
     dispatch_async(queue2, ^{
     [NSThread sleepForTimeInterval:1];
     NSLog(@"dispatch_async 3");
     }); */
    
    
    dispatch_queue_t queue =
    dispatch_queue_create("com.renren.songzengbin",   DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        sleep(1);
        NSLog(@"Thread1 read");
    });
    dispatch_async(queue, ^{
        sleep(1.5);
        NSLog(@"Thread2 read");
    });
    dispatch_async(queue, ^{
        sleep(0.5);
        NSLog(@"Thread3 read");
    });
    dispatch_barrier_async(queue, ^{
        sleep(5);
        NSLog(@"Thread is writing");
    });
    dispatch_async(queue, ^{
        sleep(1);
        NSLog(@"Thread4 is begin reading");
    });
    dispatch_async(queue, ^{
        sleep(1);
        NSLog(@"Thread5 is begin reading");
    });
}

- (void)doIt{
    NSLog(@" - do it");
}

+ (void)doIt2{
    NSLog(@" + do it");
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    //
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [JSPatch sync];
    
    [self doIt];
    [self.class doIt2];
    
    [ViewController dddd];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)startLaunchingAnimation {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LaunchScreen" bundle:[NSBundle mainBundle]];
    UIView *launchScreenView = sb.instantiateInitialViewController.view;
    launchScreenView.frame = window.bounds;
    [window.rootViewController.view addSubview:launchScreenView];

    [UIView animateWithDuration:0.3 delay:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
        launchScreenView.alpha = 0;
    } completion:^(BOOL finished) {
        [launchScreenView removeFromSuperview];
    }];
}

@end
