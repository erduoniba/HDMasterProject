//
//  ViewController.m
//  HDMasterProject
//
//  Created by Harry on 16/4/27.
//  Copyright © 2016年 HarryDeng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self performSelectorHD:@selector(doSomeThingOne: two: three:), @(1), @(2), @(4)];
}

- (void)performSelectorHD:(SEL)aSeletor, ...{
    
    if (![self respondsToSelector:aSeletor]) {
        return ;
    }
    
    NSMethodSignature *ms = [self methodSignatureForSelector:aSeletor];
    if (!ms) {
        return ;
    }
    
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:ms];
    if (!inv) {
        return ;
    }
    
    inv.target = self;
    inv.selector = aSeletor;
    NSUInteger totalArgs = ms.numberOfArguments;
    
    va_list arglist;
    va_start(arglist, aSeletor);
    
    // 注意：1、这里设置参数的Index 需要从2开始，因为前两个被selector和target占用。
    for (int i=2; i<totalArgs; i++) {

        id argument = va_arg(arglist, id);
        NSLog(@"%@", argument);
        
        [inv setArgument:&argument atIndex:i];
    }
    
    [inv retainArguments];
    [inv invoke];
}

- (void)doSomeThingOne:(NSNumber *)n1 two:(NSNumber *)n2 three:(NSNumber *)n3{
    
}

- (void)doSomeThing{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
