//
//  PGDanglingPointRecord.m
//  pgBFoundationModule
//
//  Created by 邓立兵 on 2020/11/6.
//

#import "PGDanglingPointRecord.h"

@implementation PGDanglingPointRecord

static id<PGDanglingPointRecordProtocol> _record;
+ (void)registerRecordHandler:(nullable id<PGDanglingPointRecordProtocol>)record {
    _record = record;
}

+ (void)recordFatalWithReason:(nullable NSString *)reason {
    NSDictionary<NSString *, id> *errorInfo = @{ NSLocalizedDescriptionKey : (reason.length ? reason : @"未标识原因" )};
    NSError *error = [NSError errorWithDomain:@"com.360buy.jdpingou.danglingpoint" code:-1 userInfo:errorInfo];
    [_record recordWithReason:error];
}

@end
