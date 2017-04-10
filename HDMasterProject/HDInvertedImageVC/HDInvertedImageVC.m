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
#import "UINavigationBar+Awesome.h"
#import "AllAroundPullView.h"
#import "NHSelectBar.h"

#define NAVBAR_CHANGE_POINT 50

@interface HDInvertedImageVC () <UIGestureRecognizerDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, NHSelectBarDelegate>

@property (nonatomic, strong) NSArray   *imageNames;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AllAroundPullView *rightPullView;

@property (nonatomic, strong) NHSelectBar *topView;

@property (nonatomic, assign) CGFloat tableViewEdgeInsetTop;

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
    self.navigationController.navigationBar.frame = CGRectMake(0, 20, kScreenWidth, 44);

    _tableViewEdgeInsetTop = kScreenHeight / 2 - 150;
    _imageNames = @[@"2222.jpg", @"3333", @"4444", @"4444"];

    [self.view addSubview:self.tableView];
    [self.view addSubview:self.topView];

    [self testOne];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    _tableView.delegate = self;
    [self scrollViewDidScroll:_tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    self.tableView.delegate = nil;
    [self.navigationController.navigationBar lt_reset];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(_tableViewEdgeInsetTop, 0, 0, 0);
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = self.scrollView;
    }
    return _tableView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth + 0, kScreenHeight / 2 + 200)];
        _scrollView.contentSize = CGSizeMake(_imageNames.count * (kScreenWidth + 0), kScreenHeight / 2);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        [_scrollView.panGestureRecognizer requireGestureRecognizerToFail:[self screenEdgePanGestureRecognizer]];

        _rightPullView = [[AllAroundPullView alloc] initWithScrollView:_scrollView position:AllAroundPullViewPositionRight action:^(AllAroundPullView *view){
            [self performSelector:@selector(finishedLoading) withObject:nil afterDelay:0.3];
        }];
        [self.scrollView addSubview:_rightPullView];
    }
    return _scrollView;
}

- (void)finishedLoading {
    [_rightPullView finishedLoading];
    [self.topView selectAtIndex:2];
}

- (NHSelectBar *)topView {
    if (!_topView) {
        _topView = [[NHSelectBar alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 36)];
        [_topView setData:@[@"楼盘", @"户型", @"详情", @"点评"] delegate:self];
        _topView.alpha = 0;
    }
    return _topView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 230;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (indexPath.row == 0) {
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = @"\n四号楼：40-70平 框架结构 41㎡\n参考总价：143万起 房贷计算器\n户型均价：35000元/㎡\n参考月供：7575元/月；首付72万\n装修情况：毛坯|\n得房率：70%|朝向：南\n推荐理由： 统一运营6年，带租赁现铺，约5.6米挑高。";
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.numberOfLines = 0;
    }
    else {
        cell.textLabel.text = [NSString stringWithFormat:@"%d", (int)indexPath.row];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark -  NHSelectBarDelegate
- (void)NHSelectBar:(NHSelectBar *)selectBar selectAtIndex:(NSInteger)index {
    if (index == 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:20 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    else if (index == 1) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:30 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    else if (index == 2) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:40 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    else if (index == 3) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:50 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
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

        CGFloat width = kScreenWidth + 0;

        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0 + i * width, 0, width, kScreenHeight / 2 + 200)];
        bgView.clipsToBounds = YES;

        UIImage *realImage = [UIImage imageNamed:_imageNames[i]];
        UIImageView *realIView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                               0,
                                                                               width,
                                                                               kScreenHeight / 4 + 70)];
        realIView.contentMode = UIViewContentModeScaleAspectFill;
        realIView.image = realImage;
        realIView.clipsToBounds = YES;
        [bgView addSubview:realIView];

        UIImage *invertedImage = [self blureImage:realImage withInputRadius:10];
        invertedImage = [invertedImage reflectedImageWithHeight:kScreenHeight * 0.7 fromAlpha:1 toAlpha:1];
        CGFloat originY = realIView.frame.size.height + realIView.frame.origin.y - 55;
        UIImageView *invertedIView = [[UIImageView alloc] initWithFrame:CGRectMake(-50,
                                                                                   originY,
                                                                                   kScreenWidth + 100,
                                                                                   kScreenHeight / 2 - originY + 130)];
        invertedIView.clipsToBounds = YES;
        invertedIView.image = invertedImage;
        [bgView addSubview:invertedIView];

        UIView *bgView2 = [[UIView alloc] initWithFrame:invertedIView.bounds];
        [invertedIView addSubview:bgView2];

        // 渐变图层
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = bgView2.bounds;

        // 设置颜色
        gradientLayer.colors = @[(id)[[UIColor blackColor] colorWithAlphaComponent:0.0f].CGColor,
                                 (id)[[UIColor blackColor] colorWithAlphaComponent:0.7f].CGColor];
        gradientLayer.locations = @[[NSNumber numberWithFloat:0.0f],
                                    [NSNumber numberWithFloat:0.7f]];

        // 添加渐变图层
        [bgView2.layer addSublayer:gradientLayer];

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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //NSLog(@"scrollView.contentOffset.y: %0.2f", scrollView.contentOffset.y);
    if (scrollView == _tableView) {

        UIColor * color = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
        CGFloat offsetY = scrollView.contentOffset.y + _tableViewEdgeInsetTop + NAVBAR_CHANGE_POINT;
        if (offsetY > NAVBAR_CHANGE_POINT) {
            CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 200 - offsetY) / 200));
            [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
            self.topView.alpha = alpha;
        } else {
            [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
            self.topView.alpha = 0;
        }


        if (scrollView.contentOffset.y < -250) {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, -250);
        }

        offsetY = -offsetY + NAVBAR_CHANGE_POINT;
        if (offsetY < 0) {
            offsetY = 0;
        }
        //NSLog(@"originY: %0.2f", offsetY);

        self.scrollView.transform = CGAffineTransformMakeScale(1 + offsetY / 800, 1 + offsetY / 800);
        self.scrollView.center = CGPointMake(self.view.center.x, self.scrollView.center.y);
    }
    else if (scrollView == _scrollView) {
        //self.scrollView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
