//
//  HDRemindDemoViewController.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2021/3/8.
//  Copyright © 2021 HarryDeng. All rights reserved.
//

#import "HDRemindDemoViewController.h"

#import "PGRemindManager.h"

@interface HDRemindDemoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation HDRemindDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (NSMutableArray *) dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        [_dataArr addObject:@"queryRemindPermission"];
        [_dataArr addObject:@"requestRemindPermission"];
        [_dataArr addObject:@"addRemindTitle"];
        [_dataArr addObject:@"queryAllReminds"];
        [_dataArr addObject:@"queryCustomReminds"];
        [_dataArr addObject:@"removeRemind"];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SEL selector = NSSelectorFromString(_dataArr[indexPath.row]);
    if ([self respondsToSelector:selector]) {
        [self performSelector:selector];
    }
}

- (void)queryRemindPermission {
    NSLog(@"[PGRemindManager queryRemindPermission] : %d", [PGRemindManager queryRemindPermission]);
}

- (void)requestRemindPermission {
    [PGRemindManager requestRemindPermission];
}

- (void)addRemindTitle {
    if ([PGRemindManager queryRemindPermission]) {
        NSString *eventIdentifier = [PGRemindManager addRemindTitle:@"我来添加事件吧-HD" time:1615284889000 forwardAlarmTime:180 url:@"https://st.jingxi.com"];
        NSLog(@"event.eventIdentifier : %@", eventIdentifier);
    }
    else {
        [PGRemindManager requestRemindPermission];
    }
}

- (void)queryAllReminds {
    for (NSString *rid in PGRemindManager.queryAllReminds) {
        NSLog(@"queryRemind: %@ %d", rid, [PGRemindManager queryRemind:rid]);
    }
}

- (void)queryCustomReminds {
    for (NSString *rid in [PGRemindManager queryAllReminds:1615094889000 endTime:1615294889000]) {
        NSLog(@"queryCustomReminds: %@ %d", rid, [PGRemindManager queryRemind:rid]);
    }
}

- (void)removeRemind {
    for (NSString *rid in PGRemindManager.queryAllReminds) {
        NSInteger index = [PGRemindManager.queryAllReminds indexOfObject:rid];
        if (random() % index == 3) {
            NSLog(@"removeRemind: %@ %d", rid, [PGRemindManager removeRemind:rid]);
        }
    }
}

@end
