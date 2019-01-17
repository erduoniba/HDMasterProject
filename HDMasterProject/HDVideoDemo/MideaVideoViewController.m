//
//  MideaVideoViewController.m
//  BHSmartHome
//
//  Created by 邓立兵 on 2019/1/14.
//

#import "MideaVideoViewController.h"

@interface MideaVideoViewController ()

@end

@implementation MideaVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"videoAllowRotation"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"videoAllowRotation"];
}

// 支持设备自动旋转
- (BOOL)shouldAutorotate {
    return YES;
}

// 支持横竖屏显示
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape | UIInterfaceOrientationMaskPortrait;;
}
@end
