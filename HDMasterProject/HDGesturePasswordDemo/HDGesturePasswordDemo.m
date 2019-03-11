//
//  HDGesturePasswordDemo.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2019/3/11.
//  Copyright © 2019 HarryDeng. All rights reserved.
//

#import "HDGesturePasswordDemo.h"

#import "HDPasswordView.h"

@interface HDGesturePasswordDemo ()

@end

@implementation HDGesturePasswordDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.view.backgroundColor = [UIColor whiteColor];
    });
    
    HDPasswordView *passwordView = [[HDPasswordView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.width)];
    passwordView.passwordBlock = ^(NSString * _Nonnull pswString) {
        NSLog(@"设置密码成功-----你的密码为 = 【%@】\n\n", pswString);
    };
    [self.view addSubview:passwordView];
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
