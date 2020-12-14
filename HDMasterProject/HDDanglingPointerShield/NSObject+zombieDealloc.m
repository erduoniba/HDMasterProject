//
//  NSObject+zombieDealloc.m
//  FortunePlat
//
//  Created by sgcy on 2018/7/26.
//  Copyright © 2018年 Tencent. All rights reserved.
//
#import <objc/runtime.h>
#import <Foundation/NSObjCRuntime.h>

#import "NSObject+zombieDealloc.h"


#define ZOMBIE_PREFIX "_NSZombie_"

NS_ROOT_CLASS
@interface _NSZombie_ {
    Class isa;
}

@end

@implementation _NSZombie_

+ (void)initialize
{
    
}

@end



@implementation NSObject(zombieDealloc)

- (void)dealloc {
    const char *className = object_getClassName(self);
    char *zombieClassName = NULL;
    do {
        /*
         int asprintf(char **strp, const char *fmt, ...);
         asprintf()可以说是一个增强版的sprintf(),在不确定字符串的长度时
         非常灵活方便，能够根据格式化的字符串长度，申请足够的内存空间。返回 字符串长度
         strp：char型指针，指向将要写入的字符串的缓冲区。
         fmt：格式化字符串
         arg：可选参数
         */
        if (asprintf(&zombieClassName, "%s%s", ZOMBIE_PREFIX, className) == -1) {
            break;
        }

        Class zombieClass = objc_getClass(zombieClassName);
        if (zombieClass == Nil) {
            zombieClass = objc_duplicateClass(objc_getClass(ZOMBIE_PREFIX), zombieClassName, 0);
        }

        if (zombieClass == Nil) {
            break;
        }

        // 进行析构操作
        objc_destructInstance(self);
        // 将self的isa指向换成我们新产生的zombieClass
        object_setClass(self, zombieClass);

    } while (0);

    if (zombieClassName != NULL) {
        // 做完各种析构操作后释放obj的内存
        free(zombieClassName);
    }
}

@end
