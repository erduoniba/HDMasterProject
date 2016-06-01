//
//  HDProxyModel.m
//  HDMasterProject
//
//  Created by Harry on 16/5/31.
//  Copyright © 2016年 HarryDeng. All rights reserved.
//

#import "HDProxyModel.h"

@implementation HDProxyModel

- (void)doSomeThing{
    NSLog(@"%s", __func__);
}

- (void)doSomeThing:(NSString *)string intValue:(NSNumber *)intV{
    NSLog(@"%s  %@  %d", __func__, string, intV.intValue);
}

@end
