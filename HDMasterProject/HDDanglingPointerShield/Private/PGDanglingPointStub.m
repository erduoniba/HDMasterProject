//
//  PGDanglingPointStub.m
//  pgBFoundationModule
//
//  Created by 邓立兵 on 2020/11/6.
//

#import "PGDanglingPointStub.h"

#import <objc/runtime.h>
#import "PGDanglingPointRecord.h"
#import "PGDanglingPointRecord.h"

int smartFunction(id target, SEL cmd, ...) {
    return 0;
}

static BOOL __addMethod(Class clazz, SEL sel) {
    NSString *selName = NSStringFromSelector(sel);
    NSMutableString *tmpString = [[NSMutableString alloc] initWithFormat:@"%@", selName];
    
    int count = (int)[tmpString replaceOccurrencesOfString:@":"
                                                withString:@"_"
                                                   options:NSCaseInsensitiveSearch
                                                     range:NSMakeRange(0, selName.length)];
    
    NSMutableString *val = [[NSMutableString alloc] initWithString:@"i@:"];
    
    for (int i = 0; i < count; i++) {
        [val appendString:@"@"];
    }
    const char *funcTypeEncoding = [val UTF8String];
    return class_addMethod(clazz, sel, (IMP)smartFunction, funcTypeEncoding);
}

/// 当一个类被释放的情况下，dealloc方法将释放类的方法转移到该类去处理。
@interface PGDanglingPointStubObject : NSObject

+ (PGDanglingPointStubObject *)shared;
- (instancetype)init __unavailable;
- (BOOL)addFunc:(SEL)sel;
+ (BOOL)addClassFunc:(SEL)sel;

@end

@implementation PGDanglingPointStubObject

+ (PGDanglingPointStubObject *)shared {
    static PGDanglingPointStubObject *singleton;
    if (!singleton) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            singleton = [PGDanglingPointStubObject new];
        });
    }
    return singleton;
}

- (BOOL)addFunc:(SEL)sel {
    return __addMethod([PGDanglingPointStubObject class], sel);
}

+ (BOOL)addClassFunc:(SEL)sel {
    Class metaClass = objc_getMetaClass(class_getName([PGDanglingPointStubObject class]));
    return __addMethod(metaClass, sel);
}

@end



@implementation PGDanglingPointStub

- (instancetype)init {
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    PGDanglingPointStubObject *stub = [PGDanglingPointStubObject shared];
    [stub addFunc:aSelector];
    return [[PGDanglingPointStubObject class] instanceMethodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : DangLingPointer .",
                        [self class], NSStringFromSelector(_cmd)];
    [PGDanglingPointRecord recordFatalWithReason:reason];
    [anInvocation invokeWithTarget:[PGDanglingPointStubObject shared]];
}

@end
