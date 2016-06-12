//
//  PhotoViewController.m
//  FDDPhotoDemo
//
//  Created by Harry on 16/4/13.
//  Copyright © 2016年 HarryDeng. All rights reserved.
//

#import "HDPhotoViewController.h"

#define ScreenWidth     CGRectGetWidth([UIScreen mainScreen].bounds)
#define ScreenHeight    CGRectGetHeight([UIScreen mainScreen].bounds)

@interface HDPhotoViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation HDPhotoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -25, self.view.frame.size.width, self.view.frame.size.height)];
    _tableView.backgroundColor = [UIColor blackColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
}

- (void)tap{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    UIScrollView *scView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 250)];
    scView.pagingEnabled = YES;
    scView.showsHorizontalScrollIndicator = NO;
    scView.showsVerticalScrollIndicator = NO;
    scView.contentSize = CGSizeMake(ScreenWidth * 20, 250);
    [cell.contentView addSubview:scView];
    
    
    NSArray *imageNames = @[@"123.jpg", @"222.png"];
    for (int i=0; i<20; i++) {
        UIImageView *iview = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth * i, 0, ScreenWidth, 250)];
        iview.image = [UIImage imageNamed:imageNames[i%2]];
        [scView addSubview:iview];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


@end
