//
//  MDFloatingBallManager.h
//  MideaPerformanceDemo
//
//  Created by ZhangJingHao48 on 2019/7/9.
//  Copyright © 2019 ZhangJingHao48. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDFloatingBallManager : NSObject

@property (nonatomic, weak) UIWindow *appKeyWindow;
@property (nonatomic, assign) BOOL canRuntime;
@property (nonatomic,   weak) UIView *superView;

@property (nonatomic, assign) BOOL isShowSettingView;

+ (instancetype)shareManager;

// 将NSlog打印信息保存到Document目录下的文件中
- (void)redirectNSlogToDocumentFolder;

@end

NS_ASSUME_NONNULL_END
