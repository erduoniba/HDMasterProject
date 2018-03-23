//
//  HDEyeViewDemo.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2018/3/22.
//  Copyright © 2018年 HarryDeng. All rights reserved.
//

#import "HDEyeViewDemo.h"

#import "HDEyeView.h"
#import "HDEyeAnimateView.h"

@interface HDEyeViewDemo ()
{
    HDEyeView *eyeView;

    HDEyeAnimateView *animateView;
    HDEyeAnimateView *customAnimateView;
}

@end

@implementation HDEyeViewDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // 方式一
    eyeView = [[HDEyeView alloc] initWithFrame:CGRectMake(40, 100, kScreenWidth - 80, 100)];
    eyeView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:eyeView];

    //方式二
    animateView = [[HDEyeAnimateView alloc] initWithFrame:CGRectMake(40, 220, kScreenWidth - 80, 100)];
    animateView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:animateView];

    //方式二，自定义眼睛
    customAnimateView = [[HDEyeAnimateView alloc] initWithFrame:CGRectMake(40, 340, kScreenWidth - 80, 100)];
    customAnimateView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    [customAnimateView setEyeImage:[UIImage imageNamed:@"eye"]];
    [customAnimateView setCoverColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]];
    [self.view addSubview:customAnimateView];

    // 模拟滑动
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(40, 460, kScreenWidth - 80, 30)];
    [slider addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    slider.maximumValue = 100;
    slider.minimumValue = 0;
    [self.view addSubview:slider];
}

- (void)valueChange:(UISlider *)slider {
    NSLog(@"valueChange : %0.2f", slider.value);
    [eyeView changeFloat:-slider.value * 1.5];

    CGFloat percent = slider.value / 90.0f;
    animateView.percent = percent;
    customAnimateView.percent = percent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
