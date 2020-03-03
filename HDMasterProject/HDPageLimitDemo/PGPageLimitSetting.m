//
//  PGPageLimitSetting.m
//  pgLibrariesModule
//
//  Created by 邓立兵 on 2020/3/3.
//

#import "PGPageLimitSetting.h"

@implementation PGPageLimitSetting

+ (instancetype)shareInstance {
    static PGPageLimitSetting *sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _pd = @"1";
        _pdNum = @"3";
        _all = @"1";
        _allNum = @"10";
        
        _currentPdNum = 0;
        _currentAllNum = 0;
    }
    return self;
}

- (void)pageNumLimit:(NSDictionary *)params {
    if ([params isKindOfClass:NSDictionary.class]) {
        _pd = params[@"pd"];
        if ([params[@"pdNum"] integerValue] > 1) {
            _pdNum = params[@"pdNum"];
        }
        _all = params[@"all"];
        if ( [params[@"allNum"] integerValue] > 1) {
            _allNum = params[@"allNum"];
        }
    }
}

@end
