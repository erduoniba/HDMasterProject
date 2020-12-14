//
//  NSObject+PGDanglingPointer.m
//  pgBFoundationModule
//
//  Created by 邓立兵 on 2020/11/6.
//

#import "NSObject+PGDanglingPointer.h"

#import "PGDanglingPointService.h"
#import "PGDanglingPointStub.h"

#import <list>
#import <objc/runtime.h>

static std::list<id> undellocedList;

@implementation NSObject (PGDanglingPointer)

- (void)pg_danglingPointer_dealloc {
    Class selfClazz = object_getClass(self);
    
    BOOL needProtect = NO;
    for (NSString *className in PGDanglingPointService.shared.classArr) {
        Class clazz = objc_getClass([className UTF8String]);
        if (clazz == selfClazz) {
            needProtect = YES;
            break;
        }
    }
    
    if (needProtect) {
        // 进行析构操作
        objc_destructInstance(self);
        // 将self的isa指向换成我们新产生的这个类
        object_setClass(self, [PGDanglingPointStub class]);
        
        undellocedList.size();
        if (undellocedList.size() >= PGDanglingPointService.shared.maxRetainCount) {
            // 返回当前vector容器中起始元素的引用
            id object = undellocedList.front();
            // 删除容器内的第一个
            undellocedList.pop_front();
            // 做完各种析构操作后释放obj的内存
            free(object);
        }
        // 在容器尾部插入新元素
        undellocedList.push_back(self);
    } else {
        [self pg_danglingPointer_dealloc];
    }
}

@end
