//
//  HDPageBaseViewController.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2020/3/3.
//  Copyright © 2020 HarryDeng. All rights reserved.
//

#import "HDPageBaseViewController.h"

#import "PGPageLimitSetting.h"

@interface HDPageBaseViewController ()

@end

@implementation HDPageBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeInfoDark];
    bt.frame = CGRectMake(200, 100, 40, 40);
    [bt addTarget:self action:@selector(modalAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
    
    CGFloat red = (arc4random()%255) / 255.0;
    CGFloat green = (arc4random()%255) / 255.0;
    CGFloat blue = (arc4random()%255) / 255.0;
    self.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

- (void)modalAction {
    NSArray *array = @[@"PGProductDetailController", @"HDPageBaseViewController", @"HDPageBaseViewController", @"HDPageBaseViewController", @"WareInfoBViewController"];
    UIViewController *vc = [NSClassFromString(array[rand()%array.count]) new];
    
    PGPageLimitSetting.shareInstance.currentAllNum++;
    if ([vc isKindOfClass:NSClassFromString(@"WareInfoBViewController")] ||
        [vc isKindOfClass:NSClassFromString(@"PGProductDetailController")]) {
        PGPageLimitSetting.shareInstance.currentPdNum++;
        vc.title = [NSString stringWithFormat:@"%@_%d_%d", NSStringFromClass(vc.class), (int)PGPageLimitSetting.shareInstance.currentAllNum, (int)PGPageLimitSetting.shareInstance.currentPdNum];
    }
    else {
        vc.title = [NSString stringWithFormat:@"%@_%d", NSStringFromClass(vc.class), (int)PGPageLimitSetting.shareInstance.currentAllNum];
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
