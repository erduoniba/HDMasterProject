//
//  PGDanglingPointSDK.h
//  pgBFoundationModule
//
//  Created by 邓立兵 on 2020/11/6.
//  该代码从 https://github.com/ValiantCat/XXShield 抽离出野指针Crash相关代码

/*
 解决过程：
 1、建立白名单机制，由于系统的类基本不会出现野指针，而且 hook 所有的类开销较大。所以我们只过滤开发者自定义的类。
 2、hook dealloc 方法 这些需要保护的类我们并不让其释放，而是调用objc_desctructInstance 方法释放实例内部所持有属性的引用和关联对象。
 3、利用 object_setClass(id，Class) 修改 isa 指针将其指向一个Proxy 对象(类比�系统的 KVO 实现)，此 Proxy 实现了一个和前面所说的智能转发类一样的 return 0的函数。
 4、在 Proxy 对象内的 - (void)forwardInvocation:(NSInvocation *)anInvocation 中收集 Crash 信息。
 5、缓存的对象是有成本的，我们在缓存对象到达一定数量时候将其释放(object_dispose)。
 */

#import <Foundation/Foundation.h>

#import "PGDanglingPointRecord.h"

NS_ASSUME_NONNULL_BEGIN


@interface PGDanglingPointSDK : NSObject

/// 注册需要传入存储类名的array，不支持系统框架类。防止野指针导致crash
/// @param classNames 保留野指针类列表
/// @param maxRetainCount 保留野指针最大数量
+ (void)registerStabilityClassNames:(nonnull NSArray<NSString *> *)classNames maxRetainCount:(NSInteger)maxRetainCount;


/// 记录野指针异常情况，并且反馈到record
/// @param record 野指针记录回调对象
+ (void)registerRecordHandler:(nonnull id<PGDanglingPointRecordProtocol>)record;

@end

NS_ASSUME_NONNULL_END
