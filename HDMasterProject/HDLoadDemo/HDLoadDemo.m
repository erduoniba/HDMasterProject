//
//  HDLoadDemo.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2019/11/4.
//  Copyright © 2019 HarryDeng. All rights reserved.
//

#import "HDLoadDemo.h"

#import "HDLoadObj.h"
#import "HDSonLoadObj.h"

#import "HDTableViewHeaderDemo.h"

@interface HDLoadDemo ()

@property (nonatomic, strong) HDSonLoadObj *obj;

@property (nonatomic, strong) NSMutableDictionary *dic;

@end

@implementation HDLoadDemo

+ (void)load {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    view.backgroundColor = [UIColor orangeColor];
    NSLog(@"[UIScreen mainScreen].bounds : %@", [NSValue valueWithCGRect:[UIScreen mainScreen].bounds]);
    HDTableViewHeaderDemo *vc = HDTableViewHeaderDemo.new;
    [[UIApplication sharedApplication].keyWindow addSubview:vc.view];
}


- (void)hd_performOnMainThread:(void(^)(void))block
{
    if (!block) {
        return ;
    }
    
    if ([NSThread isMainThread]) {
        block();
        return;
    }

    dispatch_async(dispatch_get_main_queue(), block);
}

- (void)dealloc {
    NSLog(@"HDLoadDemo dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _obj = [HDSonLoadObj new];
    _obj.viewController = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hd_performOnMainThread:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    });
    
    /*
     ^^^ HDLoadObj load
     ^^^ HDSonLoadObj load
     ^^^ HDSonLoadObj HD load
     ^^^ HDLoadObj HD load
     ^^^ HDLoadObj HD initialize
     ^^^ HDSonLoadObj HD initialize
     */
}

@end
