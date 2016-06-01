//
//  HDAnimalProxy.h
//  HDMasterProject
//
//  Created by Harry on 16/5/31.
//  Copyright © 2016年 HarryDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HDAnimal.h"

/**
 *  专门用来做NHAnimal这一类对象的代理
 *  代理也实现NHAnimal协议 (无需对协议进行 实现，但是NSObject的对象需要，不然有警告)
 */
@interface HDAnimalProxy : NSProxy <HDAnimal>

+ (instancetype)sharedInstance;

//绑定 协议 与 具体实现类对象
- (void)registerHandlerProtocol:(Protocol *)protocol handler:(id)handler;

@end
