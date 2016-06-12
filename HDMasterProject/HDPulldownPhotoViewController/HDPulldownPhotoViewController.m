//
//  HDPulldownPhotoViewController.m
//  HDMasterProject
//
//  Created by Harry on 16/6/12.
//  Copyright © 2016年 HarryDeng. All rights reserved.
//

#import "HDPulldownPhotoViewController.h"
#import "HDTouchControlView.h"
#import "HDPhotoViewController.h"

@interface HDPulldownPhotoViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>{
    UITableView *tableView;
    BOOL    shouldScroll;
    HDTouchControlView *customView;
    
    CGFloat navHeight;
    UIColor *navColor;
}

@property (nonatomic, strong) HDPhotoViewController *photoVC;

@end

@implementation HDPulldownPhotoViewController

- (void)loadView{
    
    navHeight = 64;
    
    //该类作为 手势传递作用，具体见内部
    customView = [[HDTouchControlView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    customView.navHeight = navHeight;
    self.view = customView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _photoVC = [[HDPhotoViewController alloc] init];
    [self.view addSubview:_photoVC.view];
    [self addChildViewController:_photoVC];
    
    tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    //tableView 向下偏移200px，用来展示下面的_photoVC.view
    tableView.contentInset = UIEdgeInsetsMake(200 + navHeight, 0, 0, 0);
    [self.view addSubview:tableView];
    
    //tableView是否可以执行 scrollViewDidScroll 方法，当tableView 下拉超过一定（－280）值，执行tableView消失动画，不需要处理scrollViewDidScroll
    shouldScroll = YES;
    
    // 改手势处理，当tableView消失时，上拉出现tableView
    UIPanGestureRecognizer *upSwipe = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToShowMainTView:)];
    upSwipe.delegate = self;
    [self.view addGestureRecognizer:upSwipe];
    
    customView.topView = tableView;
    customView.bottomView = _photoVC.view;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    navColor = self.navigationController.navigationBar.barTintColor;

    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.barTintColor = navColor;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return nil;
    }
    return [NSString stringWithFormat:@"HHH_%d", (int)section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView1 dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    CGFloat red = (arc4random()%255) / 255.0;
    CGFloat green = (arc4random()%255) / 255.0;
    CGFloat blue = (arc4random()%255) / 255.0;
    cell.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat contentY = scrollView.contentOffset.y;
//    NSLog(@"contentY : %0.2f", contentY);
    
    CGFloat yy = contentY + 264;
    CGFloat red = (255 - yy) / 255.0;
    CGFloat green = (155 - yy) / 255.0;
    CGFloat blue = (155 - yy) / 255.0;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:red green:green blue:blue alpha:red];
    
    if (!shouldScroll) {
        //tableView下拉消失时，不需要执行下面的代码
        return ;
    }
    
    
    if (contentY > 0) {
        //当tableView 滑到0位置，需要把 向下偏移200px 的还原，为了实现 header 粘性效果效果
        tableView.contentInset = UIEdgeInsetsMake(navHeight, 0, 0, 0);
    }
    else {
        tableView.contentInset = UIEdgeInsetsMake(200 + navHeight, 0, 0, 0);
    }
    
    // 下拉滑动到一定位置(下拉280px)，直接 界面切换
    if (contentY < - 200 - navHeight - 80) {
        [UIView animateWithDuration:0.3 animations:^{
            
            shouldScroll = NO;
            
            tableView.frame = CGRectMake(0, tableView.frame.size.height - 200 - navHeight, scrollView.frame.size.width, scrollView.frame.size.height);
            
            //tableView消失时，不允许tableView滑动
            tableView.scrollEnabled = NO;
            
            _photoVC.view.frame = CGRectMake(0, kScreenHeight / 2 - 150, _photoVC.tableView.frame.size.width, _photoVC.tableView.frame.size.height);
        }];
        
    }
    else {
        
        //其它情况，随着tableView滑动来 控制_photoVC的移动，为了实现效果差，使用1.4倍速率
        _photoVC.view.frame = CGRectMake(0, (- contentY - 200 - navHeight) / 2, _photoVC.tableView.frame.size.width, _photoVC.tableView.frame.size.height);
    }
}


- (void)swipeToShowMainTView:(UIPanGestureRecognizer *)panGes{
    
    shouldScroll = YES;
    
    CGPoint center = [panGes translationInView:self.view];    //获取点击self.view的中点
    
    if (center.y > 0) {
        
        //        NSLog(@"%0.2f  %0.2f", tableView.frame.origin.y, tableView.frame.size.height);
        
        //因为在该代码会return，会导致手势不会执行到UIGestureRecognizerStateEnded,所以要添加该代码处理位置
        [self panResult];
        
        //不允许下拉动画
        return ;
    }
    
    [tableView setCenter:CGPointMake(tableView.center.x, center.y + tableView.center.y)];
    
    [_photoVC.view setCenter:CGPointMake(_photoVC.view.center.x, _photoVC.view.center.y + center.y / 3)];
    
    //  注意一旦你完成上述的移动，将translation重置为0十分重要。否则translation每次都会叠加，很快你的view就会移除屏幕！
    [panGes setTranslation:CGPointMake(0, 0) inView:self.view];
    
    //    NSLog(@"%0.2f  %0.2f", tableView.frame.origin.y, tableView.frame.size.height);
    
    if(panGes.state == UIGestureRecognizerStateEnded) {
        [self panResult];
    }
    
}

- (void)panResult{
    
    //当tableView向上移动超过40px，执行tableView显示动画
    if (tableView.frame.origin.y < tableView.frame.size.height - 200 - navHeight - 40) {
        [UIView animateWithDuration:0.3 animations:^{
            tableView.frame = CGRectMake(0, 0, tableView.frame.size.width, tableView.frame.size.height);
            _photoVC.view.frame = CGRectMake(0, 0, _photoVC.tableView.frame.size.width, _photoVC.tableView.frame.size.height);
            tableView.scrollEnabled = YES;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            tableView.frame = CGRectMake(0, tableView.frame.size.height - 200 - navHeight, tableView.frame.size.width, tableView.frame.size.height);
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
