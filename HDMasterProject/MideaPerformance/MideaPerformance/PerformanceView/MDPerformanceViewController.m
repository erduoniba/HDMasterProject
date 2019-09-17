//
//  MDPerformanceViewController.m
//  MideaPerformanceDemo
//
//  Created by ZhangJingHao48 on 2019/7/9.
//  Copyright © 2019 ZhangJingHao48. All rights reserved.
//

#import "MDPerformanceViewController.h"
#import "MDFileManagerTool.h"
#import "SandBoxPreviewTool.h"
#import "LJ_HomeDirViewController.h"
#import "MDFloatingBallManager.h"

@interface MDPerformanceViewController ()

@property (nonatomic ,strong) MDNetFlowModel *flowModel;
@property (nonatomic ,strong) NSArray *samplingArr;
@property (nonatomic, strong) UISwitch *swtView;

@property (nonatomic, weak) UITableViewCell *wifiCell;
@property (nonatomic, weak) UITableViewCell *wwanCell;

@end

@implementation MDPerformanceViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        __weak typeof(self) wkSelf = self;
        self.timerBlock = ^(MDNetFlowModel * _Nonnull flowModel) {
            [wkSelf dealTimerActionWith:flowModel];
        };
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"监控设置";
    
    self.view.backgroundColor =
    [UIColor colorWithRed:((0xF9F9F9 >> 16) & 0xFF)/255.0
                    green:((0xF9F9F9 >> 8) & 0xFF)/255.0
                     blue:(0xF9F9F9 & 0xFF)/255.0
                    alpha:1];
    
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"关闭"
                                     style:UIBarButtonItemStyleDone
                                    target:self
                                    action:@selector(clickQuitBtn)];
    
    self.samplingArr = @[@"5秒", @"4秒", @"3秒", @"2秒", @"1秒", @"不采样", @"取消"];
}

- (void)clickQuitBtn {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.clickCloseBlock) {
        self.clickCloseBlock();
    }
}

- (void)dealTimerActionWith:(MDNetFlowModel *)flowModel {
    self.flowModel = flowModel;
    
    NSString *str1 = [MDNetFlowModel convertBytes:self.flowModel.WiFiSent];
    NSString *str2 = [MDNetFlowModel convertBytes:self.flowModel.WiFiReceived];
    NSString *str3 = [MDNetFlowModel convertBytes:self.flowModel.WiFiTotalTraffic];
    self.wifiCell.detailTextLabel.text =
    [NSString stringWithFormat:@"发送:%@ 接收:%@ 总共:%@", str1, str2, str3];
    
    NSString *str4 = [MDNetFlowModel convertBytes:self.flowModel.WWANSent];
    NSString *str5 = [MDNetFlowModel convertBytes:self.flowModel.WWANReceived];
    NSString *str6 = [MDNetFlowModel convertBytes:self.flowModel.WWANTotalTraffic];
    self.wwanCell.detailTextLabel.text =
    [NSString stringWithFormat:@"发送:%@ 接收:%@ 总共:%@", str4, str5, str6];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 3;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cell_Id = [NSString stringWithFormat:@"cell_id_%ld", indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_Id];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cell_Id];
        if (self.view.frame.size.width < 375) {
            cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
        }
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.wifiCell = cell;
            cell.textLabel.text = @"Wi-Fi流量";
        } else {
            self.wwanCell = cell;
            cell.textLabel.text = @"移动网络流量";
        }
        [self dealTimerActionWith:self.flowModel];
    }
    
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"采样间隔时间";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSInteger samplingInterval = [user integerForKey:@"MideaPerformanceSamplingInterval"];
            cell.detailTextLabel.text = self.samplingArr[5-samplingInterval];
        } else if (indexPath.row == 1)  {
            cell.textLabel.text = @"是否保存控制台日志";
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.detailTextLabel.text = @"切换开关后，需重启应用才有效；Xcode调试不保存";
            
            [cell addSubview:self.swtView];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            self.swtView.on = [user boolForKey:@"MideaPerformanceConsoleSwitch"];
        } else {
            cell.textLabel.text = nil;
            cell.detailTextLabel.numberOfLines = 0;
            cell.detailTextLabel.text = @"每次启动会新建一个文件\n采样文件路径:Documents/MideaPerformance/Sampling\n日志文件路径:Documents/MideaPerformance/Console";
        }
    }
    
    else {
        cell.textLabel.text = @"沙盒文件";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 采样时间间隔
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self alertSelectTimeInterval];
    }
    
    if (indexPath.section == 2) {
        LJ_HomeDirViewController * homeDir = [[LJ_HomeDirViewController alloc] init];
        homeDir.isHomeDir = YES;
        [self.navigationController pushViewController:homeDir animated:YES];
    }
}

#pragma mark - private

// 选择采样时间间隔
- (void)alertSelectTimeInterval {
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"采样时间间隔"
                                        message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int i = 0; i < self.samplingArr.count; i++) {
        NSString *str = self.samplingArr[i];
        UIAlertActionStyle style = UIAlertActionStyleDefault;
        if (i == self.samplingArr.count - 1) {
            style = UIAlertActionStyleCancel;
        }
        NSInteger tag = self.samplingArr.count - i - 2;
        UIAlertAction *action =
        [UIAlertAction actionWithTitle:str style:style handler:^(UIAlertAction* action) {
            if (action.style != UIAlertActionStyleCancel) {
                [self dealSelectTimeIntervalWithTag:tag];
            }
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:action];
    }
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)dealSelectTimeIntervalWithTag:(NSInteger)tag {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setInteger:tag forKey:@"MideaPerformanceSamplingInterval"];
    [user synchronize];
    if (self.settingChangeBlock) {
        self.settingChangeBlock();
    }
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

- (void)clikSwitchView:(UISwitch *)swt {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setBool:swt.on forKey:@"MideaPerformanceConsoleSwitch"];
    [user synchronize];
    
    [[MDFloatingBallManager shareManager] redirectNSlogToDocumentFolder];
}

#pragma mark - 懒加载

- (UISwitch *)swtView {
    if (!_swtView) {
        UISwitch *swt = [UISwitch new];
        CGFloat swtW = swt.frame.size.width;
        CGFloat swtH = swt.frame.size.height;
        CGFloat height = 55;
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat swtY = (height - swtH) / 2;
        CGFloat swtX = width - swtW - 15;
        swt.frame = CGRectMake(swtX, swtY, swtW, swtH);
        [swt addTarget:self
                action:@selector(clikSwitchView:)
      forControlEvents:UIControlEventValueChanged];
        _swtView = swt;
    }
    return _swtView;
}


@end
