//
//  HDNetStatusViewController1.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2018/10/27.
//  Copyright © 2018年 HarryDeng. All rights reserved.
//

#import "HDNetStatusViewController1.h"
#import "HDNetStatusViewController2.h"

#import "HDNetStatusManager.h"

static NSString *test = nil;

@interface HDNetStatusViewController1 ()

@property (nonatomic, copy) NSString *ttt;

@end

@implementation HDNetStatusViewController1

- (void)dealloc {
    NSLog(@"HDNetStatusViewController1 dealloc");
}

+ (instancetype)sharedInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    HDNetStatusManager *manager = [HDNetStatusManager sharedInstance];
    NSLog(@"HDNetStatusViewController1 - networkReachabilityStatus %d", (int)manager.networkReachabilityStatus);
    [manager addNetworkChangeObserver:self networkStatus:^(HDNetStatusManager *mm, AFNetworkReachabilityStatus status) {
        NSLog(@"HDNetStatusViewController1 - status %d", (int)mm.networkReachabilityStatus);
    }];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoDark];
    button.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:button];
    [button addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *colorView = [[UIView alloc] init];
    [colorView setFrame:CGRectMake(20, 160,
                                   self.view.frame.size.width - 40, self.view.frame.size.height - 320)];
    [self.view addSubview:colorView];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = colorView.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[UIColor grayColor].CGColor,
                       (id)[UIColor orangeColor].CGColor, nil];
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1, 0);
    [colorView.layer addSublayer:gradient];
    
    [self.class testFunction];
}

- (void)nextAction {
    [self.navigationController pushViewController:HDNetStatusViewController2.new animated:YES];
}

+ (void)testFunction {
    for (int i=0; i<10000; i++) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *temp = [NSString stringWithFormat:@"temp_%d", (int)i];
            test = temp;
            [HDNetStatusViewController1 sharedInstance].ttt = temp;
        });

    }
}

@end
