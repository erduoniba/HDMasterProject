//
//  HDAnimalProxy.m
//  HDMasterProject
//
//  Created by Harry on 16/5/31.
//  Copyright © 2016年 HarryDeng. All rights reserved.
//

#import "HDAnimalProxy.h"

#import "HDDog.h"
#import "HDCat.h"

#import <objc/runtime.h>

@interface HDAnimalProxy ()

@property (nonatomic,strong) NSMutableDictionary *selHandlerDict;

@end

@implementation HDAnimalProxy

+ (instancetype)sharedInstance {
    static HDAnimalProxy *_sharedProxy = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //NSProxy没有init方法
        _sharedProxy = [HDAnimalProxy alloc];
        
        //创建SEL与接口实现对象的关联
        _sharedProxy.selHandlerDict = [NSMutableDictionary dictionary];
    });
    return _sharedProxy;
}

- (void)registerHandlerProtocol:(Protocol *)protocol handler:(id)handler {
    
    //记录protocol中的方法个数
    unsigned int numberOfMethods = 0;
    
    //获取protocol中定义的方法描述
    struct objc_method_description *methods = protocol_copyMethodDescriptionList(protocol,
                                                                                 YES,//是否必须实现
                                                                                 YES,//是否对象方法
                                                                                 &numberOfMethods);
    
    //遍历所有的方法描述，设置其Target对象
    for (unsigned int i = 0; i < numberOfMethods; i++) {
        
        //方法描述结构体实例
        struct objc_method_description method = methods[i];
        
        //方法的名字
        NSString *methodNameStr = NSStringFromSelector(method.name);
        
        //保存所有方法名对应的Target对象，最终接收处理消息
        [_selHandlerDict setValue:handler forKey:methodNameStr];
    }

}

- (void)forwardInvocation:(NSInvocation *)invocation {
    
    //获取当前触发消息的SEL
    SEL sel = invocation.selector;
    
    //SEL的字符串
    NSString *methodNameStr = NSStringFromSelector(sel);
    
    //SEL字符串查询字典得到保存的消息接收者Target
    id target = [_selHandlerDict objectForKey:methodNameStr];
    
    
    //是否找到了要转发SEL执行的Target
    if (target && [target respondsToSelector:sel])
    {
        //找到Target，就让Target处理消息
        [invocation invokeWithTarget:target];
        
    } else {
        
        //未找到Target 或 Target未实现方法，交给super去转发消息
        [super forwardInvocation:invocation];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    
    //SEL的字符串
    NSString *methodNameStr = NSStringFromSelector(sel);
    
    //SEL字符串查询字典得到保存的消息接收者Target
    id target = [_selHandlerDict objectForKey:methodNameStr];
    
    //是否找到了要转发SEL执行的Target
    if (target && [target respondsToSelector:sel]) {
        
        //找到了Target，那么获取找到的Target的SEL对应的方法签名
        return [target methodSignatureForSelector:sel];
        
    } else {
        
        //未找到Target 或 Target未实现方法，交给super
        return [super methodSignatureForSelector:sel];
    }
}

@end
