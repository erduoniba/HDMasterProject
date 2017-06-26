//
//  HDSortVC.m
//  HDMasterProject
//
//  Created by denglibing on 2017/6/20.
//  Copyright © 2017年 HarryDeng. All rights reserved.
//

#import "HDSortVC.h"

@interface HDSortVC ()

@end

@implementation HDSortVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSMutableArray *preArr = [@[@4, @1, @9, @10, @5, @7, @6, @0, @2, @8, @3] mutableCopy];
    [self selectionSort:preArr];
    preArr = [@[@4, @1, @9, @10, @5, @7, @6, @0, @2, @8, @3] mutableCopy];
    [self bubbleSort:preArr];
    preArr = [@[@4, @1, @9, @10, @5, @7, @6, @0, @2, @8, @3] mutableCopy];
    [self insertionSort:preArr];
    preArr = [@[@4, @1, @9, @10, @5, @7, @6, @0, @2, @8, @3] mutableCopy];
    [self shellSort:preArr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 选择排序
- (void)selectionSort:(NSMutableArray *)preArr {
    NSLog(@"<<<<=======选择排序开始=======>>>");
    NSInteger minIndex = 0;
    NSLog(@"排序前数组：");
    for (int i=0; i<preArr.count; i++) {
        minIndex = i;
        NSLog(@"%ld", (long)[preArr[i] integerValue]);
        for (int j=i+1; j<preArr.count; j++) {
            if ([preArr[j] integerValue] < [preArr[minIndex] integerValue]) {
                minIndex = j;
            }
        }
        [preArr exchangeObjectAtIndex:i withObjectAtIndex:minIndex];
    }

    NSLog(@"排序后数组：");
    for (int i=0; i<preArr.count; i++) {
        NSLog(@"%@", preArr[i]);
    }
    NSLog(@"<<<<=======选择排序完成=======>>>");
}

//冒泡排序
- (void)bubbleSort:(NSMutableArray *)preArr {
    NSLog(@"<<<<=======冒泡排序开始=======>>>");
    NSLog(@"排序前数组：");
    for (int i=0; i<preArr.count; i++) {
        NSLog(@"%ld", (long)[preArr[i] integerValue]);
    }

    for (int i=0; i<preArr.count; i++) {
        for (int j=i+1; j<preArr.count; j++) {
            if ([preArr[j] integerValue] < [preArr[i] integerValue]) {
                [preArr exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }

    NSLog(@"排序后数组：");
    for (int i=0; i<preArr.count; i++) {
        NSLog(@"%@", preArr[i]);
    }
    NSLog(@"<<<<=======冒泡排序完成=======>>>");
}

//插入排序
- (void)insertionSort:(NSMutableArray *)preArr {
    NSLog(@"<<<<=======插入排序开始=======>>>");
    NSLog(@"排序前数组：");
    for (int i=0; i<preArr.count; i++) {
        NSLog(@"%ld", (long)[preArr[i] integerValue]);
    }

    for (int i=0; i<preArr.count-1; i++) {
        for (int j=i+1; j>0; j--) {
            if ([preArr[j] integerValue] > [preArr[j-1] integerValue]) {
                break;
            }
            [preArr exchangeObjectAtIndex:j withObjectAtIndex:j-1];
        }
    }

    NSLog(@"排序后数组：");
    for (int i=0; i<preArr.count; i++) {
        NSLog(@"%@", preArr[i]);
    }
    NSLog(@"<<<<=======插入排序完成=======>>>");
}

//希尔排序
- (void)shellSort:(NSMutableArray *)preArr {
    NSLog(@"<<<<=======希尔排序开始=======>>>");
    NSLog(@"排序前数组：");
    for (int i=0; i<preArr.count; i++) {
        NSLog(@"%ld", (long)[preArr[i] integerValue]);
    }

    int len = (int)preArr.count;
    for (int gap=len>>1; gap>0; gap>>=1) {
        for (int i=gap; i<len; i++) {
            //插入排序
            NSInteger temp = [preArr[i] integerValue];
            int j;
            for (j=i-gap; j>=0 && [preArr[j] integerValue] > temp; j-=gap) {
                [preArr replaceObjectAtIndex:j+gap withObject:preArr[j]];
            }
            [preArr replaceObjectAtIndex:j+gap withObject:@(temp)];
        }
    }

    NSLog(@"排序后数组：");
    for (int i=0; i<preArr.count; i++) {
        NSLog(@"%@", preArr[i]);
    }
    NSLog(@"<<<<=======希尔排序完成=======>>>");
}

@end
