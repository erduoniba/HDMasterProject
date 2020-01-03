//
//  HDSScrollTableViewCell.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2019/12/3.
//  Copyright © 2019 HarryDeng. All rights reserved.
//

#import "HDSScrollTableViewCell.h"

@implementation HDSScrollTableViewCell {
    UITableView *t;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _dataArr = [@[] mutableCopy];
        for (int i=0; i<20; i++) {
            [_dataArr addObject:@(i)];
        }
        
        t = [[UITableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStylePlain];
        t.delegate = self;
        t.dataSource = self;
        [self.contentView addSubview:t];
    }
    return self;
}

- (void)layoutSubviews {
    t.frame = self.contentView.bounds;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%d-%d", (int)indexPath.section, (int)indexPath.row]];
    cell.backgroundColor = [UIColor colorWithRed:random()%100/255.0 green:random()%100/255.0 blue:random()%100/255.0 alpha:1];
//    cell.backgroundColor = [UIColor yellowColor];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"son scrollViewDidScroll : %0.2f" , scrollView.contentOffset.y);
    
    
    if (!_recommendCanScroll) {
        // 这里通过固定contentOffset，来实现不滚动
        scrollView.contentOffset = CGPointZero;
    } else if (scrollView.contentOffset.y <= 0) {
        _recommendCanScroll = NO;
        // 通知容器可以开始滚动
        _ttvc.tableViewCanScroll = YES;
    }
    scrollView.showsVerticalScrollIndicator = _recommendCanScroll;
}

@end
