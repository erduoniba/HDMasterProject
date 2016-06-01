//
//  NHProxy.m
//  HDMasterProject
//
//  Created by Harry on 16/5/31.
//  Copyright © 2016年 HarryDeng. All rights reserved.
//

#import "HDProxy.h"

@implementation HDProxy{
    NSMutableArray *objects;
}

- (void)addFatherObject:(NSObject *)anObject{
    if (!objects) {
        objects = [NSMutableArray array];
    }
    
    if (![objects containsObject:anObject]) {
        [objects addObject:anObject];
    }
}

- (void)doSomeThing{
    
}

- (void)forwardInvocation:(NSInvocation *)invocation{
    
    [objects enumerateObjectsUsingBlock:^(id  _Nonnull object, NSUInteger idx, BOOL * _Nonnull stop) {
        [invocation setTarget:object];
        [invocation invoke];
        *stop = YES;
    }];
    
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    __block NSMethodSignature *sig;
    
    [objects enumerateObjectsUsingBlock:^(id  _Nonnull object, NSUInteger idx, BOOL * _Nonnull stop) {
        if (object) {
            // object实现了这个方法，就不再执行 forwardInvocation: 方法了
            sig = [object methodSignatureForSelector:sel];
        }
        else {
            sig = [super methodSignatureForSelector:sel];
        }
    }];
    
    return sig;
}

@end
