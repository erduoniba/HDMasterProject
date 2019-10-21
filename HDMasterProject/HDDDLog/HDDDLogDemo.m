//
//  HDDDLogDemo.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2019/9/11.
//  Copyright © 2019 HarryDeng. All rights reserved.
//

#import "HDDDLogDemo.h"

#import <CocoaLumberjack/CocoaLumberjack.h>
#import "HDDDLog.h"

static const int ddLogLevel = DDLogLevelVerbose;


@interface HDDDLogObj : NSObject

@property (nonatomic, assign) NSString *serverUrl;

@end

@implementation HDDDLogObj

@end


@interface HDDDLogDemo ()

@property (nonatomic, assign) BOOL shouldStop;
@property (nonatomic, assign) NSInteger index;

@end

@implementation HDDDLogDemo

- (void)dealloc {
    _shouldStop = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _index = 0;
    _shouldStop = NO;
//    [self ddlog];

   
    DDLogVerbose(@"DDLogVerbose %d", (int)_index);
    
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeInfoDark];
    bt.frame = CGRectMake(200, 100, 40, 40);
    [bt addTarget:self action:@selector(modalAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 150, 20)];
    label.text = @"hhh\tggg";
    [self.view addSubview:label];
    
    // iOS12及以上 \t相当于6个空格 iOS12以下 \t 就是一个空格
    label = [[UILabel alloc] initWithFrame:CGRectMake(100, 230, 150, 20)];
    label.text = @"hhh      ggg";
    [self.view addSubview:label];
}

- (void)modalAction {
    NSLog(@"modalAction--");
    
    if (_index == 0) {
        _index++;
        
        HDDDLogObj *obj = [HDDDLogObj new];
        {
            obj.serverUrl = @"https://jd.com";
        }
        
        CFAbsoluteTime startNSLog = CFAbsoluteTimeGetCurrent();
        for (int i = 0; i < 10000; i++) {
            NSLog(@"NSLog %d", i);
        }
        CFAbsoluteTime endNSLog = CFAbsoluteTimeGetCurrent();
        
        CFAbsoluteTime startPrintf = CFAbsoluteTimeGetCurrent();
        for (int i = 0; i < 10000; i++) {
            printf("printf %d\n", i);
        }
        CFAbsoluteTime endPrintf = CFAbsoluteTimeGetCurrent();
        
        
        CFAbsoluteTime startDDLog = CFAbsoluteTimeGetCurrent();
        for (int i = 0; i < 10000; i++) {
            DDLogVerbose(@"DDLogVerbose %d serverUrl: %@", i, obj.serverUrl);
        }
        CFAbsoluteTime endDDLog = CFAbsoluteTimeGetCurrent();
        
        
        //模拟器       NSLog time: 2.325112, printf time: 0.066460（35倍） DDLog time: 0.592609（3.92倍）
        //真机iPhone7  NSLog time: 0.550554, printf time: 0.014978（36倍） DDLog time: 0.730435（0.75倍）
        //真机iPhone5s NSLog time: 3.471712, printf time: 0.052889（65倍） DDLog time: 1.867238（1.86倍）
        NSLog(@"NSLog time: %lf, printf time: %lf DDLog time: %lf", endNSLog - startNSLog, endPrintf - startPrintf, endDDLog - startDDLog);
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
//    _shouldStop = YES;
}

- (void)ddlog {
    if (_shouldStop) {
        return;
    }
    DDLogVerbose(@"DDLogVerbose %d", (int)self.index);
    self.index++;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self ddlog];
    });
}

@end
