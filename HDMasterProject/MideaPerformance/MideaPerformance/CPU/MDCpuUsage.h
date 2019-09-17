//
//  MDCpuUsage.h
//  MideaPerformanceDemo
//
//  Created by ZhangJingHao48 on 2019/7/6.
//  Copyright © 2019 ZhangJingHao48. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDCpuUsage : NSObject

/// 获取当前应用在CPU中的占有率
+ (double)getCpuUsage;

@end

NS_ASSUME_NONNULL_END
