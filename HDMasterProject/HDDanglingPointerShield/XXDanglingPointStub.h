//
//  ForwordingCenterForDanglingPoint.h
//  XXShield
//
//  Created by nero on 2017/1/18.
//  Copyright © 2017年 XXShield. All rights reserved.
//


#import <Foundation/Foundation.h>

/// 中间类，将调用野指针对象方法转移到XXShieldStubObject类去实现，然后抛出异常。
@interface XXDanglingPointStub : NSProxy

- (instancetype)init;

@end
