//
//  HDDelegateObject1.h
//  HDMasterProject
//
//  Created by 邓立兵 on 2018/4/23.
//  Copyright © 2018年 HarryDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HDProtocol.h"

@interface HDDelegateObject1 : NSObject

@property (nonatomic, weak) id <HDProtocol> hdDemoProtocol;

- (void)action;

@end
