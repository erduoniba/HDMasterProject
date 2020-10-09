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
#import "MideaPerformance.h"

#import <IQKeyboardManager/IQKeyboardManager.h>

#import "HDNetStatusManager/HDNetStatusManager.h"

static NSString *const leancloudAppId = @"0MekiRXH3vAPyw6SI3Uc6FSY-gzGzoHsz";
static NSString *const leancloudClientKey = @"iQXXT7muTw32op7OlF10YrmH";


@interface AppDelegate ()

@end

@implementation AppDelegate

-(void)setup3DTouch{
    //    UIApplicationShortcutIcon *icon0 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeAdd];
    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeCompose];
    UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeAdd];
    UIApplicationShortcutIcon *icon3 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeHome];
    UIApplicationShortcutIcon *icon4 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeLove];
    
    //    UIMutableApplicationShortcutItem *item0 = [[UIMutableApplicationShortcutItem alloc]initWithType:@"add" localizedTitle:@"进入add" localizedSubtitle:nil icon:icon0 userInfo:nil];
    
    UIMutableApplicationShortcutItem *item1 = [[UIMutableApplicationShortcutItem alloc]initWithType:@"pic1" localizedTitle:@"进入pic1" localizedSubtitle:@"自定义图标pic1" icon:icon1 userInfo:nil];
    UIMutableApplicationShortcutItem *item2 = [[UIMutableApplicationShortcutItem alloc]initWithType:@"pic2" localizedTitle:@"进入pic2" localizedSubtitle:@"自定义图标pic2" icon:icon2 userInfo:nil];
    UIMutableApplicationShortcutItem *item3 = [[UIMutableApplicationShortcutItem alloc]initWithType:@"pic3" localizedTitle:@"进入pic3" localizedSubtitle:@"自定义图标pic3" icon:icon3 userInfo:nil];
    UIMutableApplicationShortcutItem *item4 = [[UIMutableApplicationShortcutItem alloc]initWithType:@"pic4" localizedTitle:@"进入pic4" localizedSubtitle:@"自定义图标pic4" icon:icon4 userInfo:nil];
    //
    //
    UIMutableApplicationShortcutItem *item5 = [[UIMutableApplicationShortcutItem alloc]initWithType:@"pic1" localizedTitle:@"进入pic1" localizedSubtitle:@"自定义图标pic5" icon:icon1 userInfo:nil];
    UIMutableApplicationShortcutItem *item6 = [[UIMutableApplicationShortcutItem alloc]initWithType:@"pic2" localizedTitle:@"进入pic2" localizedSubtitle:@"自定义图标pic6" icon:icon2 userInfo:nil];
    UIMutableApplicationShortcutItem *item7 = [[UIMutableApplicationShortcutItem alloc]initWithType:@"pic3" localizedTitle:@"进入pic3" localizedSubtitle:@"自定义图标pic7" icon:icon3 userInfo:nil];
    UIMutableApplicationShortcutItem *item8 = [[UIMutableApplicationShortcutItem alloc]initWithType:@"pic4" localizedTitle:@"进入pic4" localizedSubtitle:@"自定义图标pic8" icon:icon4 userInfo:nil];
    
    // 以info.plist为准
    [[UIApplication sharedApplication] setShortcutItems:@[item1,item2,item3,item4,item5,item6,item7,item8]];
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    NSString *videoAllowRotation = [[NSUserDefaults standardUserDefaults] objectForKey:@"videoAllowRotation"];
    if ([videoAllowRotation isEqualToString:@"1"]) {
        //菜谱视频跟随系统横竖屏播放
        return UIInterfaceOrientationMaskAll;
    }
    return UIInterfaceOrientationMaskPortrait;
}

/*
 **# didFinishLaunchingWithOptions      初始化
 **# applicationDidBecomeActive         进入前台
 **# applicationWillResignActive        即将离开前台
 **# applicationDidEnterBackground      已经进入后台
 **# applicationWillEnterForeground     即将进入前台
 **# applicationDidBecomeActive         已经进入前台
 */

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //    [JSPatch startWithAppKey:@"fa85a64ff99a5290"];
    //
    //    [JSPatch setupRSAPublicKey:@"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDpHyYFneEdiA1KmWQtr9WL7+UD\nEtqAG9eC3S1PR2ttxQs6XXMtuEEJCcsTSHazN54Q0+jZO0W1CXZABPn2wuAT44n3\nTZ9ocQP6cgFPvs0+b0eqx3Dy1sisypA8Ifr8feTDV7CVwqIrjnCdPl7qlYcpUINy\nfedwf5vAt8PhiGd8eQIDAQAB\n-----END PUBLIC KEY-----"];
    
    [HDSubProjectMethodOne hdSubProjectMethodOne];
    [HDSubProjectMethodTwo hdSubProjectMethodTwo];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    [self startLaunchingAnimation];
    
    // 网络监控
    [[HDNetStatusManager sharedInstance] startMonitoring];
    
    // 日志信息
    [HDDDLog configurationDDLog:@"HDLogs"];
    
    [MideaPerformance showMonitorView];
    
    // 首先判断是否支持3DTouch
    if(self.window.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        
    }
    
    [self setup3DTouch];
    [self testRegular];
    
    [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle"] load];
    
    NSLog(@"**# didFinishLaunchingWithOptions");
    
    
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
    
    NSLog(@"**# applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //
    NSLog(@"**# applicationDidEnterBackground");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    //
    NSLog(@"**# applicationWillEnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [JSPatch sync];
    
    [self doIt];
    [self.class doIt2];
    
    [ViewController dddd];
    
    NSLog(@"**# applicationDidBecomeActive");
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

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    //不管APP在后台还是进程被杀死，只要通过主屏快捷操作进来的，都会调用这个方法
    NSLog(@"name:%@\ntype:%@", shortcutItem.localizedTitle, shortcutItem.type);
}

- (void)testRegular {
    NSString *url = @"https://wqs.jd.com/pingou/account/index.html?showFootNav=0&sceneVal=2&key=value";
     NSString *urlReg = @"^https?:[/]{2}((st[.]jingxi[.]com)|(wqs[.]jd[.]com))[/]pingou[/]account[/]index[.]html[?]showFootNav=0.*";
    
    // 正则替换
    NSString *reg = @"(^https:[/][/])wqs.jd.com(.*)&sceneVal=2(.*)";
    NSString *replace = @"$1st.jingxi.com$2$3";
    
//    [self url:url urlReg:urlReg reg:reg replace:replace];
    
    url = @"https://wqs.jd.com/jxlive/detail.html?id=123&&cover=indexImage&origin=origin&ptag=ptag";
    urlReg = @"^https?:[/]{2}((st[.]jingxi[.]com)|(wqs[.]jd[.]com))[/](pglive|jxlive)[/]detail[.]html[-A-Za-z0-9+&@#/%?=~_|!:,.;]*";
    BOOL reuslt = [self regexMatching:urlReg forString:url];
    NSLog(@"reuslt : %d", reuslt);
    
    NSLog(@"=================================");
    [self testRegular2];
}

- (void)testRegular2 {
    NSString *url = @"http://wqs.jd.com/pingou/account/index.html?showFootNav=0&sceneVal=2&key=value";
     NSString *urlReg = @"^https?:[/]{2}((st[.]jingxi[.]com)|(wqs[.]jd[.]com))[/]pingou[/]account[/]index[.]html[?]showFootNav=0.*";
    
    // 正则替换
    NSString *reg = @"(^https?:[/][/])wqs[.]jd[.]com(.*)&sceneVal=2(.*)";
    NSString *replace = @"$1st.jingxi.com$2$3";
    
    [self url:url urlReg:urlReg reg:reg replace:replace];
}

- (BOOL)regexMatching:(NSString *)regex forString:(NSString *)sourceStr {
    NSPredicate *predURL = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL result = [predURL evaluateWithObject:sourceStr];
    return result;
}

- (NSString *)url:(NSString *)url urlReg:(NSString *)urlReg reg:(NSString *)reg replace:(NSString *)replace {
    BOOL result = [self regexMatching:urlReg forString:url];
     if (result) {
         // 正则替换
         NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:reg options:NSRegularExpressionCaseInsensitive error:nil];
         NSString *resultStr = [regExp stringByReplacingMatchesInString:url
                                                      options:NSMatchingReportProgress
                                                        range:NSMakeRange(0, url.length)
                                                 withTemplate:replace];
         NSLog(@"resultStr: %@", resultStr);
         return resultStr;
     }
    NSLog(@"resultStr: %@", url);
    return url;
}

@end
