//
//  HDSSCrollViewDemoViewController.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2019/12/3.
//  Copyright © 2019 HarryDeng. All rights reserved.
//

#import "HDSSCrollViewDemoViewController.h"

#import "HDSScrollTableViewCell.h"


@interface HDSSCrollViewDemoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) HDSScrollTableViewCell *scell;

@end

@implementation HDSSCrollViewDemoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // NSObject+zombieDealloc.m 生效，则下面的代码会因为野指针问题而crash
    UIView *testObj = [[UIView alloc] init];
    [testObj release];
    for (int i=0; i<100; i++) {
        UIView *testObj = [[UIView alloc] init];
        testObj.frame = CGRectZero;
        [self.view addSubview:testObj];
    }
    [testObj setNeedsLayout];
    
    
    _dataArr = [@[] mutableCopy];
    for (int i=0; i<20; i++) {
        [_dataArr addObject:@(i)];
    }
    
    UITableView *t = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    t.delegate = self;
    t.dataSource = self;
    [self.view addSubview:t];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataArr.count - 1 == indexPath.row) {
        return self.view.frame.size.height - 44 - 34 - 100;
    }
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_scell) {
        _scell = [[HDSScrollTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%d-%d", (int)indexPath.section, (int)indexPath.row]];
        _scell.backgroundColor = [UIColor orangeColor];
    }
    if (indexPath.row == _dataArr.count - 1) {
        return _scell;
    }
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%d-%d", (int)indexPath.section, (int)indexPath.row]];
    CGFloat hh = random()%(10 * (indexPath.row+10))/255.0;
    cell.backgroundColor = [UIColor colorWithRed:hh green:hh blue:hh alpha:1];
    
    return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"father scrollViewDidScroll");
    
    
    CGFloat contentOffset = _scell.frame.size.height;

    if (!_tableViewCanScroll) {
        // 这里通过固定contentOffset的值，来实现不滚动
        scrollView.contentOffset = CGPointMake(0, contentOffset);
    } else if (scrollView.contentOffset.y >= contentOffset) {
        scrollView.contentOffset = CGPointMake(0, contentOffset);
        self.tableViewCanScroll = NO;
    }
    scrollView.showsVerticalScrollIndicator = _tableViewCanScroll;
}


@end
