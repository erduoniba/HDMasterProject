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

@interface HDLoadDemo ()

@property (nonatomic, strong) HDSonLoadObj *obj;

@property (nonatomic, strong) NSMutableDictionary *dic;

@end

@implementation HDLoadDemo

- (void)dealloc {
    NSLog(@"HDLoadDemo dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _obj = [HDSonLoadObj new];
    _obj.viewController = self;
    
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
