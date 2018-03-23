//
//  HDBarChartsElementManager.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2018/3/20.
//  Copyright © 2018年 HarryDeng. All rights reserved.
//

#import "HDBarChartsElementManager.h"

@implementation HDBarChartsElementManager {
    Class _eClass;
    NSMutableArray *_elements;
    dispatch_queue_t _elementQueue;
}

+ (instancetype)sharedInstanceClass:(Class)eClass {
    static HDBarChartsElementManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance->_eClass = eClass;
        instance->_elements = [NSMutableArray array];
        instance->_elementQueue = dispatch_queue_create("com.harry.deng.element", DISPATCH_QUEUE_CONCURRENT);
    });
    return instance;
}

- (id)getBarChartsElementView {
    id elementView;
    if (_elements.count > 0) {
        elementView = [self elements].firstObject;
        [self removeBarChartsElementView:elementView];
    }
    else {
        NSLog(@"getBarChartsElementView 需要重新生成新界面");
        elementView = [[_eClass alloc] init];
    }

    return elementView;
}

#pragma mark - 保证线程安全
- (void)saveBarChartsElementView:(id)elementView {
    if (elementView) {
        //添加写操作到自定义队列。当临界区在稍后执行时，这将是队列中唯一执行的条目(栅栏)
        dispatch_barrier_async(_elementQueue, ^{
            //这是添加对象到数组的实际代码。由于它是一个障碍 Block ，这个 Block 永远不会同时和其它 Block 一起在 _elementQueue 中执行。
            [_elements addObject:elementView];
        });
    }
}

- (void)removeBarChartsElementView:(id)elementView {
    if (elementView && [_elements containsObject:elementView]) {
        //添加写操作到自定义队列。当临界区在稍后执行时，这将是队列中唯一执行的条目(栅栏)
        dispatch_barrier_async(_elementQueue, ^{
            //这是添加对象到数组的实际代码。由于它是一个障碍 Block ，这个 Block 永远不会同时和其它 Block 一起在 _elementQueue 中执行。
            [_elements removeObject:elementView];
        });
    }
}

- (NSArray *)elements {
    __block NSArray *array;
    // 在 _elementQueue 上同步调度来执行读操作。
    dispatch_sync(_elementQueue, ^{
        array = [NSArray arrayWithArray:_elements];
    });
    return array;
}

@end
