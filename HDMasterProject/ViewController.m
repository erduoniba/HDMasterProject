//
//  ViewController.m
//  HDMasterProject
//
//  Created by Harry on 16/4/27.
//  Copyright © 2016年 HarryDeng. All rights reserved.
//

#import "ViewController.h"

#import "HDDelegateTaget.h"

#include <libkern/OSAtomic.h>
#include <execinfo.h>

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) HDDelegateTaget *delegateTaget;

@end

@implementation ViewController

__weak id reference = nil;
- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *str;
    @autoreleasepool {
        str = [NSString stringWithFormat:@"sunnyxx"];
        reference = str;
        NSLog(@"----------------reference1:%@", reference);
    }
    NSLog(@"----------------reference2:%@", reference);
    NSLog(@"----------------str:%@", str);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"dispatch_get_main_queue1");
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"dispatch_get_main_queue2");
        });
    });

    _delegateTaget = [HDDelegateTaget sharedInstance];
    
    _tableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
    _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(40, 0, 0, 0);
    
//    [self methodSync1];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//       [self methodSync2];
//    });
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self methodSync3];
//    });
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ddd) name:@"xx" object:nil];
    
}

- (void)ddd {
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//    });
    NSLog(@"%@ %@", [NSThread currentThread], [NSThread mainThread]);
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请开启手机蓝牙" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (NSInteger)methodSync1 {
    NSLog(@"methodSync1 开始");
    NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
    __block NSInteger result = 0;

    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [self methodAsync:^(NSInteger value) {
        result = value;
        NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
        NSLog(@"methodSync1 中 result:%ld duration: %ld", (long)result, (long)(end - start));

        dispatch_group_leave(group);
    }];
    dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)));

    NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
    NSLog(@"methodSync1 结束 result:%ld duration: %ld", (long)result, (long)(end - start));
    return result;
}

- (NSInteger)methodSync2 {
    NSLog(@"methodSync2 开始");
    NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
    __block NSInteger result = 0;
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [self methodAsync:^(NSInteger value) {
        result = value;
        NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
        NSLog(@"methodSync2 中 result:%ld duration: %ld", (long)result, (long)(end - start));
        
        dispatch_group_leave(group);
    }];
    dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)));
    
    NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
    NSLog(@"methodSync2 结束 result:%ld duration: %ld", (long)result, (long)(end - start));
    return result;
}

- (void)methodSync3 {
    NSLog(@"methodSync3 开始");
    NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
    __block NSInteger result = 0;
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [self methodAsync:^(NSInteger value) {
        result = value;
        NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
        NSLog(@"methodSync3 中 result:%ld duration: %ld", (long)result, (long)(end - start));
        
        dispatch_group_leave(group);
    }];
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
        NSLog(@"methodSync3 结束 result:%ld duration: %ld", (long)result, (long)(end - start));
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
        NSLog(@"methodSync3 结束 result:%ld duration: %ld", (long)result, (long)(end - start));
    });
}

- (void)methodAsync:(void (^)(NSInteger))cc {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(5);
        cc(2);
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;

    NSLog(@"----------------reference3:%@", reference);

    NSLog(@"%d", _delegateTaget.index);
    _delegateTaget.index ++;

    CFAbsoluteTime StartTime = CFAbsoluteTimeGetCurrent();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //删除里面的对象之后，里面的对象将自动dealloc
        //[_delegateTaget.delegates removeAllObjects];
        
        double launchTime = (CFAbsoluteTimeGetCurrent() - StartTime);
        printf("launchTime : %0.3f", launchTime);
    });
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    NSLog(@"----------------reference4:%@", reference);
}

+ (void)dddd{
    NSLog(@" +++ ddddd");
}


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
//    _tableView.frame = self.view.bounds;
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
        [_dataArr addObject:@"HDLoadDemo"];
        [_dataArr addObject:@"HDSSCrollViewDemoViewController"];
        [_dataArr addObject:@"HDBaseUIWebViewController"];
        [_dataArr addObject:@"HDPageLimitDemo"];
        [_dataArr addObject:@"HDNSArrayCrashDemo"];
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
    NSString *className = _dataArr[_dataArr.count - indexPath.row - 1];
    Class vcClass = NSClassFromString(className);
    if (!vcClass) {
        // swift获取正确的Class
        vcClass = [self swiftClassFromString:className];
    }
    UIViewController *nextVC = [vcClass new];
    
    NSArray *titles = [NSStringFromClass(vcClass) componentsSeparatedByString:@"ViewController"];
    if (titles.count > 0) {
        nextVC.title = titles[0];
    }
    else{
        nextVC.title = NSStringFromClass(vcClass);
    }
    
    [self.navigationController pushViewController:nextVC animated:YES];
    
    CGFloat red = (arc4random()%255) / 255.0;
    CGFloat green = (arc4random()%255) / 255.0;
    CGFloat blue = (arc4random()%255) / 255.0;
    nextVC.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

- (Class)swiftClassFromString:(NSString *)className {
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    appName = [appName stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
    NSString *classStringName = [NSString stringWithFormat:@"_TtC%lu%@%lu%@", (unsigned long)appName.length, appName, (unsigned long)className.length, className];
    return NSClassFromString(classStringName);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
