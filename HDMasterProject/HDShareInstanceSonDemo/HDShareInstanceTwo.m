//
//  HDShareInstanceTwo.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2018/6/7.
//  Copyright © 2018年 HarryDeng. All rights reserved.
//

#import "HDShareInstanceTwo.h"

@implementation HDShareInstanceTwo

+ (instancetype)sharedInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

@end
