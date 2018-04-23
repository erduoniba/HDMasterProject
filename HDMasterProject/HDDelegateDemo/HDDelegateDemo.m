//
//  HDDelegateDemo.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2018/4/23.
//  Copyright © 2018年 HarryDeng. All rights reserved.
//

#import "HDDelegateDemo.h"

#import "HDDelegateObject1.h"
#import "HDDelegateObject2.h"

#import "HDProtocol.h"

@interface HDDelegateDemo () <HDProtocol>

@property (nonatomic, strong) HDDelegateObject1 *obj1;
@property (nonatomic, strong) HDDelegateObject2 *obj2;

@end

@implementation HDDelegateDemo

- (void)viewDidLoad {
    [super viewDidLoad];

    _obj1 = [HDDelegateObject1 new];
    _obj1.hdDemoProtocol = self;

    _obj2 = [HDDelegateObject2 new];
    _obj2.hdDemoProtocol = self;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_obj1 action];
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_obj2 action];
    });
}

- (NSString *)hdDoSomething:(id)obj {
    return NSStringFromClass([obj class]);
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
