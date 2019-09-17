//
//  SPModalViewDemo.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2019/9/17.
//  Copyright © 2019 HarryDeng. All rights reserved.
//

#import "SPModalViewDemo.h"

#import "SPModalView.h"

@interface SPModalViewDemo ()

// 这个view添加了addressView，采用动画的形式从下往上弹出
@property (nonatomic, strong) SPModalView *modalView;

@end

@implementation SPModalViewDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 400)];
    view.backgroundColor = [UIColor yellowColor];
    
    // SPModalView是一个弹出视图
    self.modalView = [[SPModalView alloc] initWithView:view inBaseViewController:self];
    
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeInfoDark];
    bt.frame = CGRectMake(200, 100, 40, 40);
    [bt addTarget:self action:@selector(modalAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
}

- (void)modalAction {
    if (rand() % 2 == 1) {
        self.modalView.narrowedOff = YES;
    }
    else {
        self.modalView.narrowedOff = NO;
    }
    [self.modalView show];
}

@end
