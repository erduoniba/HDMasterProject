//
//  HDDelegateObject2.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2018/4/23.
//  Copyright © 2018年 HarryDeng. All rights reserved.
//

#import "HDDelegateObject2.h"

@implementation HDDelegateObject2

- (void)action {
    if (_hdDemoProtocol && [_hdDemoProtocol respondsToSelector:@selector(hdDoSomething:)]) {
        NSString *result = [_hdDemoProtocol hdDoSomething:self];
        NSLog(@"HDDelegateObject2 %@", result);
    }
}

@end
