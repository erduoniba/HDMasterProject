//
//  HDCat.m
//  HDMasterProject
//
//  Created by Harry on 16/5/31.
//  Copyright © 2016年 HarryDeng. All rights reserved.
//

#import "HDCat.h"

@implementation HDCat

- (NSString *)name {
    return @"猫";
}

- (NSString *)type {
    return @"哺乳动物";
}

- (void)call {
    NSLog(@"猫在叫...");
}

- (void)run {
    NSLog(@"猫在跑...");
}

@end
