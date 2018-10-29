//
//  HDSwitch.h
//  HDMasterProject
//
//  Created by 邓立兵 on 2018/8/27.
//  Copyright © 2018年 HarryDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDSwitch : UIControl

//事件类型  UIControlEventValueChanged
@property (nonatomic,assign)BOOL isOn;

//默认初始化方法, onImage 和 offImage 是必选参数不能为 nil,  frame.size 为无效值 ,size 根据图片size设置大小
- (instancetype)initWithOnImage:(UIImage *)onImage offImage:(UIImage *)offImage frame:(CGRect)frame;


@end
