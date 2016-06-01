//
//  HDDog.m
//  HDMasterProject
//
//  Created by Harry on 16/5/31.
//  Copyright © 2016年 HarryDeng. All rights reserved.
//

#import "HDDog.h"

@implementation HDDog

- (NSString *)name {
    return @"狗";
}

- (NSString *)type {
    return @"哺乳动物";
}

- (void)call {
    NSLog(@"狗在叫...");
}

- (void)run {
    NSLog(@"狗在跑...");
}

@end
