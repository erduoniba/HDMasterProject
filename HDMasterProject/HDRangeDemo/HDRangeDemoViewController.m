//
//  HDRangeDemoViewController.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2019/1/17.
//  Copyright © 2019 HarryDeng. All rights reserved.
//

#import "HDRangeDemoViewController.h"

@interface HDRangeDemoViewController ()

@end

@implementation HDRangeDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *arr = [self rangesOfString:@"abbcd_123_213_ss__" referString:@"_"];
    NSLog(@"%@", arr);
    
    arr = [self rangesOfString:@"abbc_ab_asd_ascadab" referString:@"ab"];
    NSLog(@"%@", arr);
}

- (NSArray <NSValue *> *)rangesOfString:(NSString *)string referString:(NSString *)referString {
    // string:  abbcd_123_213_ss
    // referString: _
    NSMutableArray *ranges = [NSMutableArray array];
    NSString *originString = string;
    NSRange lastRange = NSMakeRange(0, 0);
    while ([string containsString:referString]) {
        NSRange range = [string rangeOfString:referString];
        range = NSMakeRange(lastRange.location + lastRange.length + range.location, range.length);
        [ranges addObject:[NSValue valueWithRange:range]];
        string = [originString substringWithRange:NSMakeRange(range.location + range.length, originString.length - range.length - range.location)];
        lastRange = range;
    }
    return ranges;
}

@end
