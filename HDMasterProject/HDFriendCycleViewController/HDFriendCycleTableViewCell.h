//
//  HDFriendCycleTableViewCell.h
//  HDMasterProject
//
//  Created by Harry on 16/6/2.
//  Copyright © 2016年 HarryDeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDDynamicImageView.h"

@class HDFriendCycleTableViewCell;

@protocol HDFriendCycleTableViewCellDelegate <NSObject>
@optional

- (void)friendCycleTableViewCell:(HDFriendCycleTableViewCell *)cell tapImageView:(UIImageView *)imageView atIndex:(NSInteger)index;
- (void)friendCycleTableViewCell:(HDFriendCycleTableViewCell *)cell shareDynamic:(id )shareEntity;

@end

@interface HDFriendCycleTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *contentLb;
@property (nonatomic, strong) HDDynamicImageView *dynamicImageView;

@property (nonatomic, assign) BOOL isDynamicDetail;

@property (nonatomic, strong) HDDynamicImageViewManager *dynamicImageViewManager;

@property(nonatomic, assign) id <HDFriendCycleTableViewCellDelegate> delegate;

- (void)setData:(id )data delegate:(id)delegate;

+ (CGFloat)getCellHeight:(id)data;

@end
