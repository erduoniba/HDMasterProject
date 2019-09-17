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

    
    CFAbsoluteTime startNSLog = CFAbsoluteTimeGetCurrent();
    for (int i = 0; i < 10000; i++) {
        NSLog(@"%d", i);
    }
    CFAbsoluteTime endNSLog = CFAbsoluteTimeGetCurrent();
    
    CFAbsoluteTime startPrintf = CFAbsoluteTimeGetCurrent();
    for (int i = 0; i < 10000; i++) {
        printf("%d\n", i);
    }
    CFAbsoluteTime endPrintf = CFAbsoluteTimeGetCurrent();
    
    CFAbsoluteTime startDDLog = CFAbsoluteTimeGetCurrent();
    for (int i = 0; i < 10000; i++) {
        DDLogVerbose(@"DDLogVerbose %d", (int)i);
    }
    CFAbsoluteTime endDDLog = CFAbsoluteTimeGetCurrent();
    
    // NSLog time: 1.741361, printf time: 0.047443 (36.7) DDLog time: 0.752042 (2.3)
    NSLog(@"NSLog time: %lf, printf time: %lf DDLog time: %lf", endNSLog - startNSLog, endPrintf - startPrintf, endDDLog - startDDLog);
    

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
