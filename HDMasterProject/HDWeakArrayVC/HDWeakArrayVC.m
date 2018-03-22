//
//  HDWeakArrayVC.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2018/1/23.
//  Copyright © 2018年 HarryDeng. All rights reserved.
//

#import "HDWeakArrayVC.h"

#import "HDDelegateTaget.h"

@interface HDTaget: NSObject <HDDelegate>

@end

@implementation HDTaget

- (void)hdDelegateTaget:(HDDelegateTaget *)taget {
    NSLog(@"hdDelegateTaget %@ : %@", self, taget);
}

- (void)dealloc {
    NSLog(@"%s", __func__);
//    HDDelegateTaget *taget = [HDDelegateTaget sharedInstance];
//    [[HDDelegateTaget sharedInstance].delegates removeObject:[NSValue valueWithNonretainedObject:self]];
//    [taget.delegates2 removeObject:self];
}

@end


@interface HDWeakArrayVC ()

@property (nonatomic, strong) HDDelegateTaget *delegateTaget;

@end

@implementation HDWeakArrayVC

- (void)dealloc {
    NSLog(@"%s", __func__);

//    [_delegateTaget.delegates removeAllObjects];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    HDTaget *taget1 = [HDTaget new];
    HDTaget *taget2 = [HDTaget new];
    HDTaget *taget3 = [HDTaget new];
    HDTaget *taget4 = [HDTaget new];

    _delegateTaget = [HDDelegateTaget sharedInstance];

//    [_delegateTaget.delegates addObject:[NSValue valueWithNonretainedObject:taget1]];
//    [_delegateTaget.delegates addObject:[NSValue valueWithNonretainedObject:taget2]];
//    [_delegateTaget.delegates addObject:[NSValue valueWithNonretainedObject:taget3]];
//    [_delegateTaget.delegates addObject:[NSValue valueWithNonretainedObject:taget4]];
//    [_delegateTaget doSomething];

//    [_delegateTaget.delegates2 addObject:taget1];
//    [_delegateTaget.delegates2 addObject:taget2];
//    [_delegateTaget.delegates2 addObject:taget3];
//    [_delegateTaget.delegates2 addObject:taget4];
//    [_delegateTaget doSomething2];

    [_delegateTaget.delegates3 addPointer:(__bridge void *)taget1];
    [_delegateTaget.delegates3 addPointer:(__bridge void *)taget2];
    [_delegateTaget.delegates3 addPointer:(__bridge void *)taget3];
    [_delegateTaget.delegates3 addPointer:(__bridge void *)taget4];
    [_delegateTaget doSomething3];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSLog(@"%d", _delegateTaget.index);
    _delegateTaget.index ++;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
