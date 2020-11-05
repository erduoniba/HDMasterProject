//
//  XXShieldSDK.m
//  XXShield
//
//  Created by nero on 2017/1/18.
//  Copyright © 2017年 XXShield. All rights reserved.
//


#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import "XXShieldSDK.h"
#import "NSObject+DanglingPointer.h"
#import "XXDanglingPonterService.h"
#import "XXRecord.h"

@implementation XXShieldSDK

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

+ (void)registerStabilityClassNames:(NSArray *)arr {
    if ([arr count]) {
        [self registerDanglingPointer:arr];
    }
}

+ (void)registerDanglingPointer:(NSArray *)arr {
    NSMutableArray *avaibleList = arr.mutableCopy;
    for (NSString *className in arr) {
        NSBundle *classBundle = [NSBundle bundleForClass:NSClassFromString(className)];
        if (classBundle != [NSBundle mainBundle]) {
            [avaibleList removeObject:className];
        }
    }
    [XXDanglingPonterService getInstance].classArr = avaibleList;
    defaultSwizzlingOCMethod([NSObject class], NSSelectorFromString(@"dealloc"), @selector(xx_danglingPointer_dealloc));
}

+ (void)registerRecordHandler:(nonnull id<XXRecordProtocol>)record { 
    [XXRecord registerRecordHandler:record];
}

@end
