//
//  HDFriendCycleModel.h
//  HDMasterProject
//
//  Created by Harry on 16/6/2.
//  Copyright © 2016年 HarryDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDFriendCycleModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, strong) NSArray<NSString *> *picUrl; //动态图片列表，有可能为空(原始图片地址)

+ (NSMutableArray *)queryTestData;

@end
