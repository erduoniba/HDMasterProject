//
//  NSObject+PGDanglingPointer.h
//  pgBFoundationModule
//
//  Created by 邓立兵 on 2020/11/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// swizzling dealloc 到 xx_danglingPointer_dealloc，然后进行野指针保持操作
@interface NSObject (PGDanglingPointer)

@end

NS_ASSUME_NONNULL_END
