//
//  HDNSArrayCrashDemo.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2020/5/22.
//  Copyright © 2020 HarryDeng. All rights reserved.
//

#import "HDNSArrayCrashDemo.h"

@interface HDNSArrayCrashDemo ()

@property (nonatomic, strong) NSMutableArray *jsApis;
@property (nonatomic, assign) int index;

@property (nonatomic, strong) dispatch_queue_t concurrentQueue;

@property (nonatomic, strong) NSString *str1;
@property (nonatomic, strong) NSString *str2;

@end

@implementation HDNSArrayCrashDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _jsApis = [NSMutableArray array];
    _concurrentQueue = dispatch_queue_create("com.360buy.jdpingou.safe.array.jsapi", DISPATCH_QUEUE_CONCURRENT);
    _index = 0;
    [self addAction:_index];
    
    _str1 = @"str1";
    _str2 = _str1;
    _str1 = @"str2";
    
    NSLog(@"_str2 : %@", _str2);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            for (int j=0; j<100; j++) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    for (int i=0; i<100; i++) {
        //                NSLog(@"_jsApis count : %d", _jsApis.count);
                        [self copyArray];
        //                NSArray *tempArr = [NSArray arrayWithArray:_jsApis];
        //                NSMutableArray *tempss = _jsApis.mutableCopy;
        //                NSArray *tempArr = _jsApis.copy;
                    }
                });
            }
    });

    
//    [self copyArray];
}

- (void)addAction:(int)j {
    _index ++;
//    NSLog(@"_index : %d", _index);
    if (_index > 10000) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * 0.0001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self->_jsApis addObject:@"1"];
        
        [self safeAddObject:@"1"];
        [self addAction:_index];
    });
}

- (void)safeAddObject:(id)anObject {
//    NSLog(@"safeAddObject count %d", _jsApis.count);
    if (anObject) {
         dispatch_barrier_async(_concurrentQueue, ^{
             [self->_jsApis addObject:anObject];
             NSLog(@"_jsApis count %d", _jsApis.count);
         });
     }
}

- (void)copyArray {
//    NSLog(@"copyArray count %d", _jsApis.count);
    dispatch_barrier_async(_concurrentQueue, ^{
//        [_jsApis removeLastObject];
        
        NSArray *tempArr = [NSArray arrayWithArray:_jsApis];
        NSLog(@"tempArr count %d", _jsApis.count);
    });
}

@end
