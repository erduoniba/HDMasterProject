//
//  PGDanglingPointSDK.m
//  pgBFoundationModule
//
//  Created by 邓立兵 on 2020/11/6.
//

#import "PGDanglingPointSDK.h"

#import <objc/runtime.h>
#import "PGDanglingPointService.h"

@implementation PGDanglingPointSDK

BOOL defaultSwizzlingOCMethod(Class self, SEL origSel_, SEL altSel_) {
    Method origMethod = class_getInstanceMethod(self, origSel_);
    if (!origMethod) {
        return NO;
    }
    
    Method altMethod = class_getInstanceMethod(self, altSel_);
    if (!altMethod) {
        return NO;
    }
    
    class_addMethod(self,
                    origSel_,
                    class_getMethodImplementation(self, origSel_),
                    method_getTypeEncoding(origMethod));
    class_addMethod(self,
                    altSel_,
                    class_getMethodImplementation(self, altSel_),
                    method_getTypeEncoding(altMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, origSel_), class_getInstanceMethod(self, altSel_));
    return YES;
}

+ (void)registerStabilityClassNames:(nonnull NSArray<NSString *> *)classNames maxRetainCount:(NSInteger)maxRetainCount {
    NSMutableArray *avaibleList = classNames.mutableCopy;
    for (NSString *className in classNames) {
        NSBundle *classBundle = [NSBundle bundleForClass:NSClassFromString(className)];
        if (classBundle != [NSBundle mainBundle]) {
            [avaibleList removeObject:className];
        }
    }
    PGDanglingPointService.shared.classArr = avaibleList;
    PGDanglingPointService.shared.maxRetainCount = maxRetainCount;
    defaultSwizzlingOCMethod([NSObject class], NSSelectorFromString(@"dealloc"), @selector(pg_danglingPointer_dealloc));
}

+ (void)registerRecordHandler:(nonnull id<PGDanglingPointRecordProtocol>)record {
    [PGDanglingPointRecord registerRecordHandler:record];
}


@end
