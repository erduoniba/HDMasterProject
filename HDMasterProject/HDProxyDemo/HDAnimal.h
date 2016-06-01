//
//  Animal.h
//  HDMasterProject
//
//  Created by Harry on 16/5/31.
//  Copyright © 2016年 HarryDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  一个动物的所有行为的抽象, 
    协议 通常是用来抽象描述 具有一组相关行为的物体
    代理，主要要来 获取数据、回传数据、回调执行代码，减少一些不必要的代码耦合度
    那么方法默认是@required的，必须实现
 */
@protocol HDAnimal <NSObject>

/**
 *  动物的名字
 */
- (NSString *)name;

/**
 *  动物的类型
 */
- (NSString *)type;

/**
 *  叫
 */
- (void)call;

/**
 *  跑步
 */
- (void)run;

@end
