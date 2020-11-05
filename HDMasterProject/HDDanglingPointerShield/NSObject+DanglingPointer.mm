//
//  NSObject+DanglingPointer.h
//  XXShield
//
//  Created by nero on 2017/1/18.
//  Copyright © 2017年 XXShield. All rights reserved.
//


#import <objc/runtime.h>
#import "NSObject+DanglingPointer.h"
#import "XXDanglingPointStub.h"
#import "XXDanglingPonterService.h"
#import <list>

static NSInteger const threshold = 100;

static std::list<id> undellocedList;

@implementation NSObject (DanglingPointer)

- (void)xx_danglingPointer_dealloc {
    Class selfClazz = object_getClass(self);
    
    BOOL needProtect = NO;
    for (NSString *className in [XXDanglingPonterService getInstance].classArr) {
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
        object_setClass(self, [XXDanglingPointStub class]);
        
        undellocedList.size();
        if (undellocedList.size() >= threshold) {
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
        [self xx_danglingPointer_dealloc];
    }
}

@end

