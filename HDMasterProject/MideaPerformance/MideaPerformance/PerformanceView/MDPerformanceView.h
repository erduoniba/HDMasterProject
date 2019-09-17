//
//  MDPerformanceView.h
//  MideaPerformanceDemo
//
//  Created by ZhangJingHao48 on 2019/7/6.
//  Copyright © 2019 ZhangJingHao48. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDNetworkFlow.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDPerformanceView : UIView


@property (nonatomic, copy) void (^timerBlock)(MDNetFlowModel *flowModel);

@property (nonatomic, copy) void (^settingChangeBlock)(void);


@end

NS_ASSUME_NONNULL_END
