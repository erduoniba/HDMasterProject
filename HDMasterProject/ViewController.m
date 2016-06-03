//
//  ViewController.m
//  HDMasterProject
//
//  Created by Harry on 16/4/27.
//  Copyright © 2016年 HarryDeng. All rights reserved.
//

#import "ViewController.h"
#import "HDMessageWaysViewController.h"
#import "HDFriendCycleViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    _tableView.frame = self.view.bounds;
}

- (NSMutableArray *) dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        [_dataArr addObject:@"HDMessageWaysViewController"];
        [_dataArr addObject:@"HDProxyDemoViewController"];
        [_dataArr addObject:@"HDFriendCycleViewController"];
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
    cell.textLabel.text = _dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Class vcClass = NSClassFromString(_dataArr[indexPath.row]);
    UIViewController *nextVC = [vcClass new];
    
    NSArray *titles = [NSStringFromClass(vcClass) componentsSeparatedByString:@"ViewController"];
    if (titles.count > 0) {
        nextVC.title = titles[0];
    }
    else{
        nextVC.title = NSStringFromClass(vcClass);
    }
    
    
    CGFloat red = (arc4random()%255) / 255.0;
    CGFloat green = (arc4random()%255) / 255.0;
    CGFloat blue = (arc4random()%255) / 255.0;
    nextVC.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
