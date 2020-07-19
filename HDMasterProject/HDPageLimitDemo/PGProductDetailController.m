//
//  PGProductDetailController.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2020/3/3.
//  Copyright © 2020 HarryDeng. All rights reserved.
//

#import "PGProductDetailController.h"

@interface HDArrayModel : NSObject <NSCopying, NSMutableCopying>

@property (nonatomic, strong) NSString *name;

@end

@implementation HDArrayModel

+ (instancetype)initWithName:(NSString *)name {
    HDArrayModel *model = [[HDArrayModel alloc] init];
    model.name = name;
    return model;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    HDArrayModel *model = [[HDArrayModel allocWithZone:zone] init];
    model.name = self.name;
    return model;
}


- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    HDArrayModel *model = [[HDArrayModel allocWithZone:zone] init];
    model.name = [self.name mutableCopyWithZone:zone];
    return model;
}

@end


@interface PGProductDetailController ()

@end

@implementation PGProductDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSMutableArray *temoArray = [NSMutableArray array];
    for (int i=0; i<10; i++) {
        HDArrayModel *model = [HDArrayModel initWithName:[NSString stringWithFormat:@"name_%d", i]];
        [temoArray addObject:model];
    }
    
    NSArray *temoArray2 = temoArray;
    for (int i=10; i<20; i++) {
        HDArrayModel *model = [HDArrayModel initWithName:[NSString stringWithFormat:@"name_%d", i]];
        [temoArray addObject:model];
    }
    
    for (int j=0; j<10; j++) {
//        HDArrayModel *model = [temoArray[j] mutableCopy];
        HDArrayModel *model = [temoArray[j] copy];
        model.name = [NSString stringWithFormat:@"name"];
    }
    
    for (int j=0; j<temoArray.count; j++) {
        HDArrayModel *model = temoArray[j];
        NSLog(@"model.name : %@", model.name);
    }
    
    for (int j=0; j<temoArray2.count; j++) {
        HDArrayModel *model = temoArray2[j];
        NSLog(@"model.name2 : %@", model.name);
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
