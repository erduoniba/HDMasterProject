//
//  PGDanglingPointService.h
//  pgBFoundationModule
//
//  Created by 邓立兵 on 2020/11/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 记录需要保留野指针的类的集合
@interface PGDanglingPointService : NSObject

+ (instancetype)shared;

@property (nonatomic, copy) NSArray<NSString *> *classArr;
@property (nonatomic, assign) NSInteger maxRetainCount;

@end


NS_ASSUME_NONNULL_END
