//
//  HDTableViewHeaderDemo.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2019/10/31.
//  Copyright © 2019 HarryDeng. All rights reserved.
//

#import "HDTableViewHeaderDemo.h"

@interface HDTableViewHeaderDemo () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *headerView;

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation HDTableViewHeaderDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    _headerView.backgroundColor = [UIColor orangeColor];
    self.tableView.tableHeaderView = _headerView;
    
    [self.tableView reloadData];
}

- (NSMutableArray *) dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        [_dataArr addObject:@"HDMessageWaysViewController"];
        [_dataArr addObject:@"HDProxyDemoViewController"];
        [_dataArr addObject:@"HDFriendCycleViewController"];
        [_dataArr addObject:@"HDPulldownPhotoViewController"];
        [_dataArr addObject:@"HDLogServiceViewController"];
        [_dataArr addObject:@"HDMaskLayerVC"];
        [_dataArr addObject:@"HDTextToImageVC"];
        [_dataArr addObject:@"HDInvertedImageVC"];
        [_dataArr addObject:@"HDGCDTestVC"];
        [_dataArr addObject:@"HDSortVC"];
        [_dataArr addObject:@"UIDocumentViewController"];
        [_dataArr addObject:@"HDWeakArrayVC"];
        [_dataArr addObject:@"HDBarChartsViewController"];
        [_dataArr addObject:@"HDEyeViewDemo"];
        [_dataArr addObject:@"HDDelegateDemo"];
        [_dataArr addObject:@"HDCategoryDemo"];
        [_dataArr addObject:@"HDShareInstanceSonDemo"];
        [_dataArr addObject:@"HDAddressBookDemo"];
        [_dataArr addObject:@"HDTextFieldDemo"];
        [_dataArr addObject:@"HDSwitchDemo"];
        [_dataArr addObject:@"HDNetStatusViewController1"];
        [_dataArr addObject:@"HDVideoDemoViewController"];
        [_dataArr addObject:@"HDRangeDemoViewController"];
        [_dataArr addObject:@"HDGCDTimeDemo"];
        [_dataArr addObject:@"HDMideaScanCodeDemo"];
        [_dataArr addObject:@"HDGesturePasswordDemo"];
        [_dataArr addObject:@"HDDDLogDemo"];
        [_dataArr addObject:@"SPModalViewDemo"];
        [_dataArr addObject:@"HDPresentDemo"];
        [_dataArr addObject:@"HDXibLayerDemo"];
        [_dataArr addObject:@"HDSwiftDemo"];
        [_dataArr addObject:@"HDWKWebViewDemo"];
        [_dataArr addObject:@"HDTableViewHeaderDemo"];
    }
    return _dataArr;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hd_cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hd_cell"];
    }
    cell.textLabel.text = _dataArr[_dataArr.count - indexPath.row - 1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView beginUpdates];
    _headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 200 + random() % 400);
    [self.tableView endUpdates];
}

- (void)injected {
    _headerView.backgroundColor = [UIColor redColor];
    [self.tableView beginUpdates];
    _headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 300 + random() % 400);
    [self.tableView endUpdates];
}

@end
