//
//  HDSwitchDemo.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2018/8/27.
//  Copyright © 2018年 HarryDeng. All rights reserved.
//

#import "HDSwitchDemo.h"

#import "GYSwitch.h"
#import "HDSwitch.h"

@interface HDSwitchDemo ()

@end

@implementation HDSwitchDemo

- (void)viewDidLoad {
    [super viewDidLoad];

    
    GYSwitch *sw = [[GYSwitch alloc] initWithFrame:CGRectMake(50, 100, 100, 40)];
    [self.view addSubview:sw];

    HDSwitch *ss = [[HDSwitch alloc] initWithOnImage:[UIImage imageNamed:@"public_ic_switchon"] offImage:[UIImage imageNamed:@"public_ic_switchoff"] frame:CGRectMake(50, 200, 200, 40)];
    ss.backgroundColor = [UIColor clearColor];
    [ss addTarget:self action:@selector(switchClicked:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:ss];

    //UITextView的文字布局不是从最左边开始的
    UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(100, 300, 200, 100)];
    [self.view addSubview:tv];
}

static int j = 0;
- (void)switchClicked:(HDSwitch *)ss {
//    ss.isOn = !ss.isOn;
//    [ss sendActionsForControlEvents:UIControlEventValueChanged];
    NSLog(@"sss : %d", ss.isOn);
    
    static int i = 0;
    i++;
    j++;
    NSLog(@"iii %d jjj %d", i, j);
    
    NSMutableDictionary *dd = [@{
                                 @"x" : @"y",
                                 } mutableCopy];
    NSLog(@"dd %@", dd);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.view.backgroundColor = [UIColor whiteColor];
    //self.view.backgroundColor = [UIColor blackColor];
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
