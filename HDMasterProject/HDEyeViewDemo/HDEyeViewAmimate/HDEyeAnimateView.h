//
//  WeiXinAnimateView.h
//  WeinXinVideo
//
//  Created by Harry on 15/9/2.
//  Copyright (c) 2015年 Harry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDEyeAnimateView : UIView

///< percent:1 全部显示 0:不显示
@property (nonatomic, assign) CGFloat percent;

// 遮盖层的颜色值，默认是黑色
- (void)setCoverColor:(UIColor *)coverColor;

// 设置眼睛图片，当然也可以是其他图片
- (void)setEyeImage:(UIImage *)eyeImage;

@end
