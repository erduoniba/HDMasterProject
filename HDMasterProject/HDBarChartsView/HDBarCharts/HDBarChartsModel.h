//
//  HDBarChartsModel.h
//  HDMasterProject
//
//  Created by 邓立兵 on 2018/3/21.
//  Copyright © 2018年 HarryDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 柱状图模型
 */
@interface HDBarChartsElement : NSObject

@property (nonatomic, assign) CGFloat value;      //当前值
@property (nonatomic, assign) CGFloat maxValue;   //最大值,也就是背景的最大值

@property (nonatomic, assign) CGFloat lineWidth;  //柱形图的宽度，默认值为8.0f

@property (nonatomic, strong) UIColor *color;       //柱形图的颜色
@property (nonatomic, strong) UIColor *bgColor;     //柱形图的背景颜色

@end

/**
 柱状图区块数据模型，内部可能包含多个柱状图
 */
@interface HDBarChartsBlock : NSObject

@property (nonatomic, assign) CGFloat lineSpace;  //柱形图之间的间距，默认是动态生成

//X轴的数据标题相关
@property (nonatomic, strong) NSString *xAxisTitle;
@property (nonatomic, strong) UIFont *xAxisFont;
@property (nonatomic, strong) UIColor *xAxisColor;

@property (nonatomic, strong) NSArray <HDBarChartsElement *> *elememts; //柱状图的数据

@end
