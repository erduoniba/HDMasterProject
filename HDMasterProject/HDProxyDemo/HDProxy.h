//
//  NHProxy.h
//  HDMasterProject
//
//  Created by Harry on 16/5/31.
//  Copyright © 2016年 HarryDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDProxy : NSProxy

- (void)addFatherObject:(NSObject *)anObject;

@end