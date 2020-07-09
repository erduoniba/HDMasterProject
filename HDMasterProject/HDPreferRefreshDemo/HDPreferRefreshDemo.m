//
//  HDPreferRefreshDemo.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2020/7/2.
//  Copyright © 2020 HarryDeng. All rights reserved.
//

#import "HDPreferRefreshDemo.h"

@interface HDPreferRefreshDemo ()

@end

@implementation HDPreferRefreshDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addRefreshView];
    [self addLoadMoreView];
    
    // ignoredScrollViewContentInsetBottom
}

- (void)refresh {
    self.dataArr = [NSMutableArray array];
    for (int i=0; i<10; i++) {
        [self.dataArr addObject:@"1"];
    }
    [self.tableView reloadData];
    [self refreshEnd];
}

- (void)loadMore {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i=0; i<10; i++) {
            [self.dataArr addObject:@"1"];
        }
        [self.tableView reloadData];
        [self refreshEnd];
    });

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%d", (int)indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return random() % 100 + 40;
}

@end
