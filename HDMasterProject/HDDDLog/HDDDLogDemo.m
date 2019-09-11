//
//  HDDDLogDemo.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2019/9/11.
//  Copyright © 2019 HarryDeng. All rights reserved.
//

#import "HDDDLogDemo.h"

#import <CocoaLumberjack/CocoaLumberjack.h>

static const int ddLogLevel = DDLogLevelVerbose;
//
//#ifdef DEBUG
//static const int ddLogLevel = DDLogLevelVerbose;
//#else
//static const int ddLogLevel = DDLogLevelError;
//#endif

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
    [self ddlog];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    _shouldStop = YES;
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
