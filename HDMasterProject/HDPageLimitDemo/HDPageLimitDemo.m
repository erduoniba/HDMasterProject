//
//  HDPageLimitDemo.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2020/3/3.
//  Copyright © 2020 HarryDeng. All rights reserved.
//

#import "HDPageLimitDemo.h"

#import "PGPageLimitSetting.h"

@interface HDPageLimitDemo ()

@end

@implementation HDPageLimitDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PGPageLimitSetting.shareInstance.currentPdNum = 0;
    PGPageLimitSetting.shareInstance.currentAllNum = 2;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
