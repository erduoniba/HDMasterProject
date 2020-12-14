//
//  HDLRUCache.h
//  HDMasterProject
//
//  Created by 邓立兵 on 2020/12/12.
//  Copyright © 2020 HarryDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDLRUCache <__covariant KeyType, __covariant ObjectType> : NSObject

@property (nonatomic, assign, readonly) NSUInteger count;

-(instancetype)initWithMaxCountLRU:(NSUInteger)maxCountLRU;

- (void)removeAllObjects;
- (void)removeObjectsForKeys:(NSArray<KeyType<NSCopying>> *)keys;

- (void)removeObjectForKey:(KeyType<NSCopying>)aKey;
- (void)setObject:(ObjectType)anObject forKey:(KeyType<NSCopying>)aKey;

- (ObjectType)objectForKey:(KeyType<NSCopying>)aKey;

- (ObjectType)lruDict;

- (NSArray<KeyType<NSCopying>> *)lruKeys;

@end

NS_ASSUME_NONNULL_END
