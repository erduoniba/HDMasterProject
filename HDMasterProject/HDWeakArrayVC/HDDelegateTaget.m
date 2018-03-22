//
//  HDDelegateTaget.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2018/1/23.
//  Copyright © 2018年 HarryDeng. All rights reserved.
//

#import "HDDelegateTaget.h"

@implementation NSMutableArray (WeakReferences)
+ (id)mutableArrayUsingWeakReferences {
    return [self mutableArrayUsingWeakReferencesWithCapacity:0];
}

+ (id)mutableArrayUsingWeakReferencesWithCapacity:(NSUInteger)capacity {
    CFArrayCallBacks callbacks = {0, NULL, NULL, CFCopyDescription, CFEqual};
    // We create a weak reference array
    return (__bridge id)(CFArrayCreateMutable(0, capacity, &callbacks));
}
@end


@implementation HDDelegateTaget

+ (instancetype)sharedInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _delegates = [NSMutableArray array];
        _delegates2 = [NSMutableArray mutableArrayUsingWeakReferences];
        _delegates3 = [NSPointerArray weakObjectsPointerArray];

    }
    return self;
}

- (void)doSomething {
    NSLog(@"_delegates.count : %lu", (unsigned long)_delegates.count);
    if (_delegates.count > 0) {
        [_delegates enumerateObjectsUsingBlock:^(NSValue *value, NSUInteger idx, BOOL * _Nonnull stop) {
            id<HDDelegate> obj = value.nonretainedObjectValue;
            if (obj && [obj respondsToSelector:@selector(hdDelegateTaget:)]) {
                [obj hdDelegateTaget:self];
            }
        }];
    }
}

- (void)doSomething2 {
    NSLog(@"_delegates2.count : %lu", (unsigned long)_delegates2.count);
    if (_delegates2.count > 0) {
        [_delegates2 enumerateObjectsUsingBlock:^(id<HDDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj && [obj respondsToSelector:@selector(hdDelegateTaget:)]) {
                [obj hdDelegateTaget:self];
            }
        }];
    }
}

- (void)doSomething3 {
    NSLog(@"_delegates3.count : %lu", (unsigned long)_delegates3.count);
    if (_delegates3.count > 0) {
        [[_delegates3 allObjects] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@" ==== obj: %@ idx: %lu", obj, (unsigned long)idx);
            if (obj && [obj respondsToSelector:@selector(hdDelegateTaget:)]) {
                [obj hdDelegateTaget:self];
            }
        }];
    }
}

@end
