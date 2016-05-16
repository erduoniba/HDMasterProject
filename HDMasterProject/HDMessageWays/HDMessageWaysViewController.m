//
//  HDMessageWays.m
//  HDMasterProject
//
//  Created by Harry on 16/5/16.
//  Copyright © 2016年 HarryDeng. All rights reserved.
//

#import "HDMessageWaysViewController.h"

#import "NSObject+Messages.h"

#import <objc/message.h>

@implementation HDMessageWaysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSStringFromClass(self.class);
    
    [self doSomeThingOne:@(11) two:@(22) three:@"hd33"];
    [self performSelectorHD:@selector(doSomeThingOne: two: three:), @(111), @(222), @"hd333"];
    ((void (*)(id, SEL, NSNumber *, NSNumber *, NSString *))objc_msgSend)((id)self, @selector(doSomeThingOne:two:three:), @(1111), @(2222), @"hd3333");
}

- (void)doSomeThingOne:(NSNumber *)n1 two:(NSNumber *)n2 three:(NSString *)ss{
    NSLog(@"doSomeThingOne:%@ two:%@ three:%@", n1, n2, ss);
}


@end
