//
//  HDBaseNavigationController.m
//  HDMasterProject
//
//  Created by Harry on 16/6/15.
//  Copyright © 2016年 HarryDeng. All rights reserved.
//

#import "HDBaseNavigationController.h"

#import "PGPageLimitSetting.h"

@interface HDBaseNavigationController ()

@end

@implementation HDBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return [[self topViewController] preferredStatusBarStyle];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    
    NSMutableArray *tempPdViewControllers = [NSMutableArray array];
    NSInteger currentAllNum = self.viewControllers.count;
    NSInteger currentPdNum = 0;
    for (UIViewController *vc in self.viewControllers) {
        // WareInfoBViewController 老商详
        // PGProductDetailController 新商详
        if ([vc isKindOfClass:NSClassFromString(@"WareInfoBViewController")] ||
            [vc isKindOfClass:NSClassFromString(@"PGProductDetailController")]) {
            currentPdNum ++;
            [tempPdViewControllers addObject:vc];
        }
    }
    NSLog(@"========================================================");
    NSLog(@"pushViewController currentPdNum : %d", (int)currentPdNum);
    NSLog(@"pushViewController currentAllNum : %d", (int)currentAllNum);
    
    if (![PGPageLimitSetting.shareInstance.pd isEqualToString:@"0"]) {
        NSInteger pdNum = PGPageLimitSetting.shareInstance.pdNum.integerValue;
        NSLog(@"pushViewController pdNum : %d", (int)pdNum);
        if (currentPdNum > pdNum) {
            UIViewController *vc = [tempPdViewControllers firstObject];
            NSMutableArray *tempvcs = [NSMutableArray arrayWithArray:self.viewControllers];
            [tempvcs removeObject:vc];
            [self setViewControllers:tempvcs];
            NSLog(@"pushViewController 删除第一个商详");
            return;
        }
    }
    
    if (![PGPageLimitSetting.shareInstance.all isEqualToString:@"0"]) {
        NSInteger allNum = PGPageLimitSetting.shareInstance.allNum.integerValue;
        NSLog(@"pushViewController allNum : %d", (int)allNum);
        if (currentAllNum > allNum && self.viewControllers.count > 1) {
            UIViewController *vc = self.viewControllers[1];
            NSMutableArray *tempvcs = [NSMutableArray arrayWithArray:self.viewControllers];
            [tempvcs removeObject:vc];
            [self setViewControllers:tempvcs];
            NSLog(@"pushViewController 删除第二个页面");
            return;
        }
    }
}

@end
