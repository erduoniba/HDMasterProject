//
//  HDMaskLayerVC.m
//  HDMasterProject
//
//  Created by denglibing on 2017/3/28.
//  Copyright © 2017年 HarryDeng. All rights reserved.
//

#import "HDMaskLayerVC.h"

@interface HDMaskLayerVC ()

@end

@implementation HDMaskLayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    UIImageView *imageView = [[UIImageView alloc] init];//这里就是我们需要显示的图片
    UIImage *image = [UIImage imageNamed:@"loading"];
    imageView.image = image;
    imageView.frame = CGRectMake(50, 100, image.size.width / 1, image.size.height / 1);
    [self.view addSubview:imageView];

    UIImage *mask = [UIImage imageNamed:@"MessageBubble_Sender"];//pic.png就是不规则的图片
    CALayer* maskLayer = [CALayer layer];
    maskLayer.contentsScale = [UIScreen mainScreen].scale;

    // 拉伸设置 contentsCenter(x, y, width, height) https://my.oschina.net/u/2438875/blog/512736
    maskLayer.contentsCenter = CGRectMake(.5f, .5f, .1f, .1f);
    maskLayer.frame = imageView.bounds;
    maskLayer.contents = (__bridge id _Nullable)[mask CGImage];
    imageView.layer.mask = maskLayer;


    UIImageView *imageView2 = [[UIImageView alloc] init];//这里就是我们需要显示的图片
    image = [UIImage imageNamed:@"123.jpg"];
    imageView2.image = image;
    imageView2.frame = CGRectMake(50, 300, image.size.width / 2, image.size.height / 2);
    [self.view addSubview:imageView2];

    UIImage *mask2 = [UIImage imageNamed:@"MessageBubble_Reviceder"];//pic.png就是不规则的图片
    CALayer *maskLayer2 = [CALayer layer];
    maskLayer2.contentsScale = [UIScreen mainScreen].scale;

    // 拉伸设置 contentsCenter(x, y, width, height) https://my.oschina.net/u/2438875/blog/512736
    maskLayer2.contentsCenter = CGRectMake(.5f, .5f, .1f, .1f);
    maskLayer2.frame = imageView2.bounds;
    maskLayer2.contents = (__bridge id _Nullable)[mask2 CGImage];
    imageView2.layer.mask = maskLayer2;
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
