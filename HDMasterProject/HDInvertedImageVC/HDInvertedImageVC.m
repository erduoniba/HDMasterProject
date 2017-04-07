//
//  HDInvertedImageVC.m
//  HDMasterProject
//
//  Created by denglibing on 2017/4/7.
//  Copyright © 2017年 HarryDeng. All rights reserved.
//

#import "HDInvertedImageVC.h"

#import <NYXImagesKit/NYXImagesKit.h>
#import <Accelerate/Accelerate.h>

@interface HDInvertedImageVC () <UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSArray   *imageNames;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation HDInvertedImageVC

// 如果自定了back button或者隐藏了navigationBar，返回手势就失效了，自己实现该代理可以使返回手势有效
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.navigationController.viewControllers.count <= 1 ) {
        return NO;
    }

    return YES;
}

#pragma mark - UIGestureRecognizerDelegate
///<  默认这个方法返回No，返回Yes则运行同时运行(想要同时接收两个事件)
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{

    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        return YES;
    }

    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.view.clipsToBounds = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;

    _imageNames = @[@"3333", @"4444", @"3333", @"4444"];
    [self.view addSubview:self.scrollView];

    [self testOne];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _scrollView.contentSize = CGSizeMake(_imageNames.count * kScreenWidth, kScreenHeight);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        [_scrollView.panGestureRecognizer requireGestureRecognizerToFail:[self screenEdgePanGestureRecognizer]];
    }
    return _scrollView;
}

// 返回手势和UIScrollView有冲突： http://www.cnblogs.com/lexingyu/p/3702742.html
- (UIScreenEdgePanGestureRecognizer *)screenEdgePanGestureRecognizer
{
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
    if (self.navigationController.view.gestureRecognizers.count > 0)
    {
        for (UIGestureRecognizer *recognizer in self.navigationController.view.gestureRecognizers)
        {
            if ([recognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]])
            {
                screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)recognizer;
                break;
            }
        }
    }

    return screenEdgePanGestureRecognizer;
}


- (void)testOne {
    for (int i=0; i<_imageNames.count; i++) {

        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0 + i * kScreenWidth, 0, kScreenWidth, kScreenHeight)];
        bgView.clipsToBounds = YES;

        UIImage *realImage = [UIImage imageNamed:_imageNames[i]];
        UIImageView *realIView = [[UIImageView alloc] initWithFrame:CGRectMake(-20,
                                                                               0,
                                                                               kScreenWidth + 40,
                                                                               kScreenHeight / 2 + 20)];
        realIView.contentMode = UIViewContentModeScaleAspectFill;
        realIView.image = realImage;
        realIView.clipsToBounds = YES;
        [bgView addSubview:realIView];

        UIImage *invertedImage = [self blureImage:realImage withInputRadius:10];
        invertedImage = [invertedImage reflectedImageWithHeight:kScreenHeight * 0.7 fromAlpha:1 toAlpha:1];
        CGFloat originY = realIView.frame.size.height + realIView.frame.origin.y - 80;
        UIImageView *invertedIView = [[UIImageView alloc] initWithFrame:CGRectMake(-50,
                                                                                   originY,
                                                                                   kScreenWidth + 100,
                                                                                   kScreenHeight - originY)];
        invertedIView.clipsToBounds = YES;
        invertedIView.image = invertedImage;
        [bgView addSubview:invertedIView];

        [self.scrollView addSubview:bgView];
    }
}


- (UIImage *)blureImage:(UIImage *)originImage withInputRadius:(CGFloat)inputRadius {
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *image = [CIImage imageWithCGImage:originImage.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:image forKey:kCIInputImageKey];
    [filter setValue:@(inputRadius) forKey: @"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];

    //注意以下方法在模拟器上运行上会很卡，但真机仍然流畅！
    CGImageRef outImage = [context createCGImage:result fromRect:[result extent]];

    //下面方法可以去掉白边
    //CGImageRef outImage = [context createCGImage: result fromRect:[image extent]];
    UIImage * blurImage = [UIImage imageWithCGImage:outImage];
    return blurImage;
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
