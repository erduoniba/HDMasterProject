//
//  NHHouseQACommentCell.h
//  NewHouseSDK
//
//  Created by Harry on 16/5/3.
//  Copyright © 2016年 haifeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NHSelectBar;

@protocol NHSelectBarDelegate <NSObject>

- (void)NHSelectBar:(NHSelectBar *)selectBar selectAtIndex:(NSInteger)index;

@end

@interface NHSelectBar : UIView

@property (nonatomic, assign) id<NHSelectBarDelegate> delegate;

- (void)setData:(NSArray *)tags delegate:(id)delegate;
- (void)selectAtIndex:(NSInteger)index;

@end

