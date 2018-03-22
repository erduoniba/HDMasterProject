//
//  HDDelegateTaget.h
//  HDMasterProject
//
//  Created by 邓立兵 on 2018/1/23.
//  Copyright © 2018年 HarryDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HDDelegateTaget;

@protocol HDDelegate <NSObject>

- (void)hdDelegateTaget:(HDDelegateTaget *)taget;

@end

@interface HDDelegateTaget : NSObject

@property (nonatomic, strong) NSMutableArray <NSValue *> *delegates;
@property (nonatomic, strong) NSMutableArray <id <HDDelegate>> *delegates2;
@property (nonatomic, strong) NSPointerArray *delegates3; //不需要手动去删除内部的元素，元素释放后自动删除
@property (nonatomic, assign) int index;

+ (instancetype)sharedInstance;

- (void)doSomething;
- (void)doSomething2;
- (void)doSomething3;

@end
