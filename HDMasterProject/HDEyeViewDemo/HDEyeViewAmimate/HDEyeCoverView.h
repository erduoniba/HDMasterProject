//
//  HDEyeCoverView.h
//  HDMasterProject
//
//  Created by 邓立兵 on 2018/3/22.
//  Copyright © 2018年 HarryDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDEyeCoverView : UIView

///< percent:1 全部显示 0:不显示
@property (nonatomic, assign) CGFloat percent;

///< 遮盖层的颜色值
@property (nonatomic, strong) UIColor *coverColor;

@end
