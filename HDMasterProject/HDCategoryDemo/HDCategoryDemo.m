//
//  HDCategoryDemo.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2018/4/23.
//  Copyright © 2018年 HarryDeng. All rights reserved.
//

#import "HDCategoryDemo.h"

#import "HDCategory.h"
//#import "HDCategory+One.h"
//#import "HDCategory+Two.h"
#import <HDCagegoryFramework/HDCagegoryFramework.h>

@interface HDCategoryDemo ()

@end

@implementation HDCategoryDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [[HDCategory new] dosome];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
