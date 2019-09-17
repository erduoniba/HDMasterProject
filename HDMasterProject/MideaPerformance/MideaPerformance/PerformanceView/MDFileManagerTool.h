//
//  MDFileManagerTool.h
//  MideaPerformanceDemo
//
//  Created by ZhangJingHao48 on 2019/7/9.
//  Copyright © 2019 ZhangJingHao48. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDFileManagerTool : NSObject

/// 创建文件夹
+ (void)setupFile;

/// Sampling 文件夹
+ (NSString *)samplingPath;

/// Console 文件夹
+ (NSString *)consolePath;

/// 拼接文件内容
+ (void)writeSamplingSting:(NSString *)string filePath:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
