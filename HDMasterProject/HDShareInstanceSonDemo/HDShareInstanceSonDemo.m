//
//  HDShareInstanceSonDemo.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2018/6/7.
//  Copyright © 2018年 HarryDeng. All rights reserved.
//

#import "HDShareInstanceSonDemo.h"

#import "HDShareInstanceOne.h"
#import "HDShareInstanceTwo.h"

@interface HDShareInstanceSonDemo ()

@end

@implementation HDShareInstanceSonDemo

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"HDShareInstanceFather %@", [HDShareInstanceFather sharedInstance]);
    NSLog(@"HDShareInstanceFather %@", [HDShareInstanceFather sharedInstance]);

    NSLog(@"HDShareInstanceOne %@", [HDShareInstanceOne sharedInstance]);
    NSLog(@"HDShareInstanceOne %@", [HDShareInstanceOne sharedInstance]);

    NSLog(@"HDShareInstanceTwo %@", [HDShareInstanceTwo sharedInstance]);
    NSLog(@"HDShareInstanceTwo %@", [HDShareInstanceTwo sharedInstance]);
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
