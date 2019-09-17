//
//  MDAppMemory.h
//  MideaPerformanceDemo
//
//  Created by ZhangJingHao48 on 2019/7/6.
//  Copyright © 2019 ZhangJingHao48. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDAppMemory : NSObject

/// 获取当前应用的内存占用情况，和Xcode数值相差较大
+ (double)getResidentMemory;

/// 获取当前应用的内存占用情况，和Xcode数值相近
+ (double)getMemoryUsage;

@end

NS_ASSUME_NONNULL_END
