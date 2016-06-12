//
//  Customview.h
//  FDDPhotoDemo
//
//  Created by Harry on 16/4/13.
//  Copyright © 2016年 HarryDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDTouchControlView : UIView

@property (nonatomic, strong) UIView *topView; //上面的tableview
@property (nonatomic, strong) UIView *bottomView; //下面装载图片的vc.view

@property (nonatomic, assign) CGFloat navHeight;

@end
