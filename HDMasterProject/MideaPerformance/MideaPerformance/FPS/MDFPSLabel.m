//
//  MDFPSLabel.m
//  MideaPerformanceDemo
//
//  Created by ZhangJingHao48 on 2019/7/6.
//  Copyright © 2019 ZhangJingHao48. All rights reserved.
//


#import "MDFPSLabel.h"
#import "MDWeakProxy.h"

@implementation MDFPSLabel {
    CADisplayLink *_link;
    NSUInteger _count;
    NSTimeInterval _lastTime;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.textAlignment = NSTextAlignmentCenter;
    
    // 创建CADisplayLink，设置代理和回调
    _link = [CADisplayLink displayLinkWithTarget:[MDWeakProxy proxyWithTarget:self]
                                        selector:@selector(tick:)];
    // 并添加到当前runloop的NSRunLoopCommonModes
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    return self;
}

- (void)dealloc {
    [_link invalidate];
}

// 计算 fps
- (void)tick:(CADisplayLink *)link {
    
    if (_lastTime == 0) { // 当前时间戳
        _lastTime = link.timestamp;
        return;
    }
    
    _count++; // 执行次数
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    float fps = _count / delta; // fps
    _count = 0;
    
    // 更新 fps
    CGFloat progress = fps / 60.0;
    self.text = [NSString stringWithFormat:@"%d",(int)round(fps)];
    self.textColor = [UIColor colorWithHue:0.27 * (progress - 0.2)
                                saturation:1
                                brightness:0.9
                                     alpha:1];
}

@end

