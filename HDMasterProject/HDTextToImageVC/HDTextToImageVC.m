//
//  HDTextToImageVCViewController.m
//  HDMasterProject
//
//  Created by denglibing on 2017/4/5.
//  Copyright © 2017年 HarryDeng. All rights reserved.
//

#import "HDTextToImageVC.h"

@interface HDTextToImageVC ()

@end

@implementation HDTextToImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(20, 100, 40, 40)];
    [self.view addSubview:imgview];

    UILabel *temptext  = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    temptext.text = @"好";
    temptext.layer.cornerRadius = 20;
    temptext.layer.masksToBounds = YES;
    temptext.backgroundColor = [UIColor orangeColor];
    temptext.textColor = [UIColor whiteColor];
    temptext.textAlignment = NSTextAlignmentCenter;
    UIImage *image  = [self imageForView:temptext];
    imgview.image = image;


    UIImageView *imgview2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 200, 40, 40)];
    imgview2.layer.cornerRadius = 20;
    imgview2.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:imgview2];

    NSString *string = @"字";
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    [paragraphStyle setLineSpacing:15.f];  //行间距
    [paragraphStyle setParagraphSpacing:2.f];//字符间距

    NSDictionary *attributes = @{NSFontAttributeName            : [UIFont systemFontOfSize:16],
                                 NSForegroundColorAttributeName : [UIColor blueColor],
                                 NSBackgroundColorAttributeName : [UIColor clearColor],
                                 NSParagraphStyleAttributeName : paragraphStyle, };


    UIImage *image1  = [self imageFromString:string attributes:attributes size:imgview2.bounds.size];
    imgview2.image = image1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIImage *)imageFromString:(NSString *)string attributes:(NSDictionary *)attributes size:(CGSize)size
{
    NSMutableParagraphStyle *paragraphStyle = attributes[NSParagraphStyleAttributeName];
    UIFont *font = attributes[NSFontAttributeName];
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [string drawInRect:CGRectMake(0, (size.height - font.pointSize) / 2.0 - paragraphStyle.paragraphSpacing, size.width, size.height) withAttributes:attributes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}


- (UIImage *)imageForView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);

    if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    else
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
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
