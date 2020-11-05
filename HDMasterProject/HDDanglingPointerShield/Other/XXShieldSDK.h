//
//  XXShieldSDK.h
//  XXShield
//
//  Created by nero on 2017/1/18.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, EXXShieldType) {
    EXXShieldTypeDangLingPointer = 1 << 7,
};

@protocol XXRecordProtocol <NSObject>

- (void)recordWithReason:(NSError *)reason;

@end


/// 野指针防止crash
@interface XXShieldSDK : NSObject

/**
 ///注册EXXShieldTypeDangLingPointer需要传入存储类名的array，不支持系统框架类。
 
 @param ability ability description
 @param classNames 野指针类列表
 */
+ (void)registerStabilityClassNames:(nonnull NSArray<NSString *> *)classNames;

@end

NS_ASSUME_NONNULL_END

