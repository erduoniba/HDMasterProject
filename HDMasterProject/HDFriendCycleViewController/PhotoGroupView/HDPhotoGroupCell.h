//
//  NHPhotoGroupCell.h
//  HDMasterProject
//
//  Created by Harry on 15/12/4.
//  Copyright © 2015年 HarryDeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HDPhotoGroupItem;
@interface HDPhotoGroupCell : UIScrollView<UIScrollViewDelegate>
@property (nonatomic, strong) UIView *imageContainerView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) BOOL showProgress;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) CAShapeLayer *progressLayer;

@property (nonatomic, strong) HDPhotoGroupItem *item;
@property (nonatomic, readonly) BOOL itemDidLoad;
- (void)resizeSubviewSize;
@end
