//
//  NSObject+Messages.m
//  HDMasterProject
//
//  Created by Harry on 16/5/16.
//  Copyright © 2016年 HarryDeng. All rights reserved.
//

#import "NSObject+Messages.h"

@implementation NSObject (Messages)

- (void)performSelectorHD:(SEL)aSeletor, ...{
    if (![self respondsToSelector:aSeletor]) {
        return ;
    }
    
    NSMethodSignature *ms = [self methodSignatureForSelector:aSeletor];
    if (!ms) {
        return ;
    }
    
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:ms];
    if (!inv) {
        return ;
    }
    
    inv.target = self;
    inv.selector = aSeletor;
    NSUInteger totalArgs = ms.numberOfArguments;
    
    va_list arglist;
    va_start(arglist, aSeletor);
    
    // 注意：1、这里设置参数的Index 需要从2开始，因为前两个被selector和target占用。
    for (int i=2; i<totalArgs; i++) {
        
        id argument = va_arg(arglist, id);
        NSLog(@"%@", argument);
        
        [inv setArgument:&argument atIndex:i];
    }
    
    va_end(arglist);
    
    [inv retainArguments];
    [inv invoke];
}

@end
