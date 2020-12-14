//
//  PGDanglingPointRecord.h
//  pgBFoundationModule
//
//  Created by 邓立兵 on 2020/11/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PGDanglingPointRecordProtocol <NSObject>

- (void)recordWithReason:(NSError *)reason;

@end


/// 野指针注册汇报中心
@interface PGDanglingPointRecord : NSObject

+ (void)registerRecordHandler:(nullable id<PGDanglingPointRecordProtocol>)record;
+ (void)recordFatalWithReason:(nullable NSString *)reason;

@end

NS_ASSUME_NONNULL_END
