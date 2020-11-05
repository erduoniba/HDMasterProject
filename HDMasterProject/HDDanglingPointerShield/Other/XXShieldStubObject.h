//
//  XXShieldStubObject.h
//  XXShield
//
//  Created by nero on 2017/1/19.
//  Copyright © 2017年 XXShield. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 当一个类被释放的情况下，dealloc方法将释放类的方法转移到该类去处理。
@interface XXShieldStubObject : NSObject

- (instancetype)init __unavailable;

+ (XXShieldStubObject *)shareInstance;

- (BOOL)addFunc:(SEL)sel;

+ (BOOL)addClassFunc:(SEL)sel;

@end
