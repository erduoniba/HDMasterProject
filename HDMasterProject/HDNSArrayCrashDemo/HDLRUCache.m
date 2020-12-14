//
//  HDLRUCache.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2020/12/12.
//  Copyright © 2020 HarryDeng. All rights reserved.
//

#import "HDLRUCache.h"

@interface HDLRUCache ()

@property (nonatomic, copy) NSMutableDictionary *lruDict;
@property (nonatomic, copy) NSMutableArray *lruKeys;
@property (nonatomic, assign) NSUInteger maxCountLRU;


@end

@implementation HDLRUCache

-(instancetype)initWithMaxCountLRU:(NSUInteger)maxCountLRU {
    self = [super init];
    if (self) {
        _lruDict = [NSMutableDictionary dictionaryWithCapacity:maxCountLRU];
        _lruKeys = [NSMutableArray arrayWithCapacity:maxCountLRU];
        _maxCountLRU = maxCountLRU;
    }
    return self;
}

- (NSUInteger)count {
    return _lruKeys.count;
}

- (void)removeAllObjects {
    [_lruKeys removeAllObjects];
    [_lruDict removeAllObjects];
}

- (void)removeObjectsForKeys:(NSArray<id<NSCopying>> *)keys {
    if (keys.count > 0) {
        [_lruDict removeObjectsForKeys:keys];
        [_lruKeys removeObjectsInArray:keys];
    }
}

- (void)removeObjectForKey:(id<NSCopying>)aKey {
    [_lruDict removeObjectForKey:aKey];
    [_lruKeys removeObject:aKey];
}

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (anObject && aKey) {
        // 判断是否超过最大值，如果是则删除最久的key值
        id firstLRUKey = [self adjustPassLRUCount:aKey];
        if (firstLRUKey) {
            [_lruDict removeObjectForKey:firstLRUKey];
        }
        [_lruDict setObject:anObject forKey:aKey];
    }
}

- (id)objectForKey:(id<NSCopying>)aKey {
    if (aKey) {
        // 如果aKey是之前有的，则将aKey替换到最后面
        if ([_lruKeys containsObject:aKey]) {
            [_lruKeys exchangeObjectAtIndex:[_lruKeys indexOfObject:aKey] withObjectAtIndex:_lruKeys.count-1];
        }
        return _lruDict[aKey];
    }
    return nil;
}

- (id<NSCopying>)adjustPassLRUCount:(id<NSCopying>)aKey {
    if (aKey) {
        // 如果aKey是之前有的，则将aKey替换到最后面
        if ([_lruKeys containsObject:aKey]) {
            [_lruKeys removeObject:aKey];
        }
        [_lruKeys addObject:aKey];
        
        // 判断是否超过阈值，如果是的话则需要删除第一个元素
        if (_lruKeys.count > _maxCountLRU) {
            id firstLRUKey = _lruKeys.firstObject;
            [_lruKeys removeObject:firstLRUKey];
            return firstLRUKey;
        }
        else {
            return nil;
        }
    }
    return nil;
}

- (id)lruDict {
    return _lruDict;
}

- (NSArray<id<NSCopying>> *)lruKeys {
    return _lruKeys;
}

@end
