//
//  HDSScrollTableViewCell.h
//  HDMasterProject
//
//  Created by 邓立兵 on 2019/12/3.
//  Copyright © 2019 HarryDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HDSSCrollViewDemoViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HDSScrollTableViewCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, assign) BOOL recommendCanScroll;

@property (nonatomic, weak) HDSSCrollViewDemoViewController *ttvc;

@end

NS_ASSUME_NONNULL_END
