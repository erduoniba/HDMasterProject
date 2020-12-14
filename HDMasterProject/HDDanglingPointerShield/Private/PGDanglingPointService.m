//
//  PGDanglingPointService.m
//  pgBFoundationModule
//
//  Created by 邓立兵 on 2020/11/6.
//

#import "PGDanglingPointService.h"

@implementation PGDanglingPointService

+ (instancetype)shared {
    static PGDanglingPointService *service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[PGDanglingPointService alloc] init];
    });
    return service;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _classArr = @[];
        _maxRetainCount = 100;
    }
    return self;
}

@end
