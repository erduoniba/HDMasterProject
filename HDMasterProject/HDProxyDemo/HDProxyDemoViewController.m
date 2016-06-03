//
//  HDProxyDemo.m
//  HDMasterProject
//
//  Created by Harry on 16/5/31.
//  Copyright © 2016年 HarryDeng. All rights reserved.
//

#import "HDProxyDemoViewController.h"
#import "HDProxy.h"
#import "HDProxyModel.h"

#import "HDAnimalProxy.h"
#import "HDDog.h"
#import "HDAnimal.h"
#import "HDCat.h"

@implementation HDProxyDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self proxyTestOne];
    
    [self proxyTestTwo];
}

- (void)proxyTestOne{
    HDProxyModel *model = [HDProxyModel new];
    [model doSomeThing];
    [model doSomeThing:@"hello" intValue:@(21)];
    
    HDProxy *proxy = [HDProxy alloc];
    [proxy addFatherObject:model];
    
    SEL sel = @selector(doSomeThing);
    NSMethodSignature *sig = [proxy methodSignatureForSelector:sel];
    NSInvocation *iv = [NSInvocation invocationWithMethodSignature:sig];
    [iv setTarget:proxy];
    iv.selector = sel;
    [iv invoke];
    
    SEL sel2 = @selector(doSomeThing:intValue:);
    NSMethodSignature *sig2 = [proxy methodSignatureForSelector:sel2];
    NSInvocation *iv2 = [NSInvocation invocationWithMethodSignature:sig2];
    iv2.target = proxy;
    iv2.selector = sel2;
    NSString *ss = @"hello2";
    [iv2 setArgument:&ss atIndex:2];
    NSNumber *cc = @(123);
    [iv2 setArgument:&cc atIndex:3];
    [iv2 invoke];
}

- (void)proxyTestTwo{
    HDAnimalProxy *proxy = [HDAnimalProxy sharedInstance];
    [proxy registerHandlerProtocol:@protocol(HDAnimal) handler:[HDDog new]];
    NSLog(@"name = %@", proxy.name);
    NSLog(@"type = %@", proxy.type);
    
    [proxy call];
    [proxy run];
    
    [proxy registerHandlerProtocol:@protocol(HDAnimal) handler:[HDCat new]];
    NSLog(@"name = %@", proxy.name);
    NSLog(@"type = %@", proxy.type);
    
    [proxy call];
    [proxy run];
}

@end
