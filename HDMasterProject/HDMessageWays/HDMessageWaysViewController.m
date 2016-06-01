//
//  HDMessageWays.m
//  HDMasterProject
//
//  Created by Harry on 16/5/16.
//  Copyright © 2016年 HarryDeng. All rights reserved.
//

#import "HDMessageWaysViewController.h"

#import "ViewController.h"

#import "NSObject+Messages.h"

#import <objc/message.h>

@implementation HDMessageWaysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat red = (random()%255) / 255.0;
    CGFloat green = (random()%255) / 255.0;
    CGFloat blue = (random()%255) / 255.0;
    self.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    
    self.title = NSStringFromClass(self.class);
    
    [self doSomeThingOne:@(11) two:@(22) three:@"hd33"];
    [self performSelectorHD:@selector(doSomeThingOne: two: three:), @(111), @(222), @"hd333"];
    ((void (*)(id, SEL, NSNumber *, NSNumber *, NSString *))objc_msgSend)((id)self, @selector(doSomeThingOne:two:three:), @(1111), @(2222), @"hd3333");
    
    UIView *view = [[UIView alloc] init];
    [self.view addSubview:view];
    
    UIImageView *iview = [[UIImageView alloc] init];
    [self.view addSubview:iview];
    
    ViewController *vc = [ViewController new];
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    
    //需要和第一个参数的类型中保持一致，不然会crash
    [self addMultipleValue:view, iview, vc.view];
}

- (void)doSomeThingOne:(NSNumber *)n1 two:(NSNumber *)n2 three:(NSString *)ss{
    NSLog(@"doSomeThingOne:%@ two:%@ three:%@", n1, n2, ss);
}


- (void)addMultipleValue:(UIView *)ss,...{
    //获取可变参数的步骤:
    //1.首先在函数里定义一个va_list型的变量,这里是valist,这个变量是指向参数的指针.
    va_list valist;
    
    //2.然后用va_start宏初始化变量valist,这个宏的第二个参数是第一个可变参数的前一个参数,是一个固定的参数.
    va_start(valist, ss);

    //3.然后用va_arg返回可变的参数,并赋值给nextValue. va_arg的第二个参数是你要返回的参数的类型,这里是NSObject *型
    id nextValue = va_arg(valist, id);
    
    while (nextValue) {
        NSLog(@"nextValue:%@",nextValue);
        nextValue = nil;
        nextValue = va_arg(valist, id);
    }

    
    //4.最后用va_end宏结束可变参数的获取.然后你就可以在函数里使用第二个参数了.如果函数有多个可变参数的,依次调用va_arg获取各个参数.
    va_end(valist);
}

@end
