//
//  PGDanglingPointStub.h
//  pgBFoundationModule
//
//  Created by 邓立兵 on 2020/11/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 中间类，将调用野指针对象方法转移到XXShieldStubObject类去实现，然后抛出异常。
@interface PGDanglingPointStub : NSProxy

- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
