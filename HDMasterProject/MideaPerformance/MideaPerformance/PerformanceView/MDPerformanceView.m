//
//  MDPerformanceView.m
//  MideaPerformanceDemo
//
//  Created by ZhangJingHao48 on 2019/7/6.
//  Copyright © 2019 ZhangJingHao48. All rights reserved.
//

#import "MDPerformanceView.h"
#import "MDCpuUsage.h"
#import "MDAppMemory.h"
#import "MDFPSLabel.h"
#import "MDFloatingBall.h"
#import "MDWeakProxy.h"
#import "MDFileManagerTool.h"
#import "MDFloatingBallManager.h"

@interface MDPerformanceView ()

@property (nonatomic, weak) UILabel *cpuLab;
@property (nonatomic, weak) UILabel *memoryLab;
@property (nonatomic, weak) MDFPSLabel *fpsLab;
@property (nonatomic ,strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger samplingInterval;
@property (nonatomic, assign) NSInteger samplingCount;

@property (nonatomic, copy) NSString *samplingPath;

@end

@implementation MDPerformanceView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化文件夹
        [MDFileManagerTool setupFile];
        [[MDFloatingBallManager shareManager] redirectNSlogToDocumentFolder];
        
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
        [self setupUI];
        
        __weak typeof(self) wkSelf = self;
        self.settingChangeBlock = ^{
            [wkSelf dealSettingChange];
        };
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        self.samplingInterval = [user integerForKey:@"MideaPerformanceSamplingInterval"];
    }
    return self;
}

- (void)setupUI {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGFloat fpsStrX = width * 0.15;
    CGFloat fpsStrW = width - fpsStrX * 2;
    UILabel *fpsStrLab = [[UILabel alloc] initWithFrame:CGRectMake(fpsStrX, 0, fpsStrW, height)];
    fpsStrLab.textColor = [UIColor whiteColor];
    fpsStrLab.font = [UIFont systemFontOfSize:9];
    fpsStrLab.text = @"FPS";
    fpsStrLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:fpsStrLab];
    
    MDFPSLabel *fpsLab = [[MDFPSLabel alloc] initWithFrame:self.bounds];
    fpsLab.font = [UIFont systemFontOfSize:20];
    [self addSubview:fpsLab];
    self.fpsLab = fpsLab;
    
    CGFloat cpuH = height * 0.5;
    UILabel *cpuLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, cpuH)];
    cpuLab.textColor = [UIColor whiteColor];
    cpuLab.font = [UIFont systemFontOfSize:9];
    cpuLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:cpuLab];
    self.cpuLab = cpuLab;
    
    CGFloat memY = height - cpuH;
    UILabel *memoryLab = [[UILabel alloc] initWithFrame:CGRectMake(0, memY, width, cpuH)];
    memoryLab.textColor =cpuLab.textColor;
    memoryLab.font = cpuLab.font;
    memoryLab.textAlignment = cpuLab.textAlignment;
    [self addSubview:memoryLab];
    self.memoryLab = memoryLab;

    _timer = [NSTimer timerWithTimeInterval:1.0
                                     target:[MDWeakProxy proxyWithTarget:self]
                                   selector:@selector(timerAction)
                                   userInfo:nil
                                    repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)timerAction {
    double cpu = [MDCpuUsage getCpuUsage];
    self.cpuLab.text = [NSString stringWithFormat:@"CPU: %.2f%%", cpu];
    
    double mem = [MDAppMemory getMemoryUsage];
    self.memoryLab.text = [NSString stringWithFormat:@"Mem: %.2f",mem];
    
    MDNetFlowModel *flowModel = nil;
    if (self.timerBlock) {
        flowModel = [MDNetworkFlow getTrafficMonitorings];
        self.timerBlock(flowModel);
    }
    
    if (!self.samplingInterval) {
        return;
    }
 
    self.samplingCount++;
    if (self.samplingCount >= self.samplingInterval) {
        self.samplingCount = 0;
        
        // 时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"]; //每次启动后都保存一个新的日志文件中
        NSString *dateStr = [formatter stringFromDate:[NSDate date]];
        
        // CPU
        NSString *cpuStr = self.cpuLab.text;
        
        // 内存
        NSString *memStr = [NSString stringWithFormat:@"内存: %.2fMB",mem];
        
        // FPS
        NSString *fpsStr = [NSString stringWithFormat:@"FPS：%@", self.fpsLab.text];
        
        // 电量
        [UIDevice currentDevice].batteryMonitoringEnabled = YES;
        double deviceLevel = [UIDevice currentDevice].batteryLevel;
        NSString *batteryStr = [NSString stringWithFormat:@"电量：%.2f", deviceLevel];
        
        // wifi流量
        if (!flowModel) {
            flowModel = [MDNetworkFlow getTrafficMonitorings];
        }
        NSString *WiFitTotal =  [MDNetFlowModel convertBytes:flowModel.WiFiTotalTraffic];
        NSString *wifiStr = [NSString stringWithFormat:@"WiFi：%@",WiFitTotal];
        
        // 移动网络流量
        NSString *WWANTotal =  [MDNetFlowModel convertBytes:flowModel.WWANTotalTraffic];
        NSString *WWANStr = [NSString stringWithFormat:@"WWAN：%@",WWANTotal];
        
        // 拼接字符串
        NSArray *strArr = @[dateStr, cpuStr, fpsStr, memStr, batteryStr, wifiStr, WWANStr];
        NSMutableString *mutStr = [NSMutableString new];
        for (NSString *str in strArr) {
            [mutStr appendFormat:@"%@  ", str];
        }
        
        // 存储字符串
        NSString *samplingStr = [NSString stringWithFormat:@"%@\n", mutStr];
        [MDFileManagerTool writeSamplingSting:samplingStr filePath:self.samplingPath];
        NSLog(@"%@", samplingStr);
    }
}

- (void)dealSettingChange {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    self.samplingInterval = [user integerForKey:@"MideaPerformanceSamplingInterval"];
}

- (NSString *)samplingPath {
    if (!_samplingPath) {
        // 每次启动后都保存一个新的日志文件中
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateStr = [formatter stringFromDate:[NSDate date]];
        _samplingPath = [[MDFileManagerTool samplingPath] stringByAppendingFormat:@"/%@.txt",dateStr];
    }
    return _samplingPath;
}

@end
