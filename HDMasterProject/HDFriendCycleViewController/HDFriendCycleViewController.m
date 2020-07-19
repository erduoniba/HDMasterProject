//
//  HDFriendCycleViewController.m
//  HDMasterProject
//
//  Created by Harry on 16/6/2.
//  Copyright © 2016年 HarryDeng. All rights reserved.
//

#import "HDFriendCycleViewController.h"
#import "HDFriendCycleModel.h"
#import "HDFriendCycleTableViewCell.h"

//#import "SDImageCache.h"
#import "HDPhotoGroupView.h"

@interface HDFriendCycleViewController () <UITableViewDelegate, UITableViewDataSource, HDFriendCycleTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) HDDynamicImageViewManager *dynamicImageViewManager;

@end

@implementation HDFriendCycleViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
//    [[SDImageCache sharedImageCache] clearMemory];
//    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
//        
//    }];
    
    [self.tableView registerClass:HDFriendCycleTableViewCell.class forCellReuseIdentifier:NSStringFromClass(HDFriendCycleTableViewCell.class)];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]){
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,10,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]){
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,10,0,0)];
    }
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControl];

    [refreshControl beginRefreshing];
    [self refresh:refreshControl];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (HDDynamicImageViewManager *)dynamicImageViewManager{
    if (!_dynamicImageViewManager) {
        _dynamicImageViewManager = [HDDynamicImageViewManager quickInstance];
    }
    return _dynamicImageViewManager;
}

- (void)refresh:(UIRefreshControl *)refreshControl{
    self.dataArr = [HDFriendCycleModel queryTestData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [refreshControl endRefreshing];
        [self.tableView reloadData];
    });
}


#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HDFriendCycleTableViewCell *cell = (HDFriendCycleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass(HDFriendCycleTableViewCell.class)];
    
    cell.dynamicImageViewManager = self.dynamicImageViewManager;
    cell.isDynamicDetail = YES;
    
    HDFriendCycleModel *model = self.dataArr[indexPath.row];
    [cell setData:model delegate:self];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [HDFriendCycleTableViewCell getCellHeight:self.dataArr[indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}


#pragma mark - HDFriendCycleTableViewCellDelegate
- (void)friendCycleTableViewCell:(HDFriendCycleTableViewCell *)cell shareDynamic:(id)shareEntity{
    
}

- (void)friendCycleTableViewCell:(HDFriendCycleTableViewCell *)cell tapImageView:(UIImageView *)imageView atIndex:(NSInteger)index{
    UIImageView *fromView = nil;
    NSMutableArray *items = [NSMutableArray new];
    NSArray <NSString *>*imageUrls = cell.dynamicImageView.imageUrls;
    NSMutableArray <UIImageView *>*imageViews = cell.dynamicImageView.imageViews;
    
    CGRect screenRect = [[UIScreen mainScreen]bounds];
    CGSize maxsize = CGSizeMake(CGRectGetWidth(screenRect) * 2, CGRectGetHeight(screenRect) * 2);
    for (NSUInteger i = 0, max = imageViews.count; i < max; i++) {
        UIImageView *imgView = imageViews[i];
        HDPhotoGroupItem *item = [HDPhotoGroupItem new];
        item.thumbView = imgView;
        NSURL *url = [NSURL URLWithString:imageUrls[i]];
        item.largeImageURL = url;
        item.largeImageSize = maxsize;
        [items addObject:item];
        if (i == index) {
            fromView = imgView;
        }
    }
    
    HDPhotoGroupView *v = [[HDPhotoGroupView alloc] initWithGroupItems:items];
    [v presentFromImageView:fromView toContainer:self.navigationController.view animated:YES completion:nil];
}

@end
