//
//  HDBarChartsView.h
//  HDMasterProject
//
//  Created by 邓立兵 on 2018/3/20.
//  Copyright © 2018年 HarryDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HDBarChartsBlock;

/**
 柱状图显示的动画效果

 - HDBarChartsAnimateTypeCurveEaseInOut: 时间曲线，慢进慢出
 - HDBarChartsAnimateTypeCurveEaseIn: 时间曲线，慢进
 - HDBarChartsAnimateTypeCurveEaseOut: 时间曲线，慢出
 - HDBarChartsAnimateTypeCurveLinear: 时间曲线，匀速
 - HDBarChartsAnimateTypeAlpa: 渐变显示
 - HDBarChartsAnimateTypeNone: 无动画 （默认值）
 */
typedef NS_ENUM(NSInteger, HDBarChartsAnimateType) {
    HDBarChartsAnimateTypeCurveEaseInOut = 0 << 16,
    HDBarChartsAnimateTypeCurveEaseIn = 1 << 16,
    HDBarChartsAnimateTypeCurveEaseOut = 2 << 16,
    HDBarChartsAnimateTypeCurveLinear = 3 << 16,
    HDBarChartsAnimateTypeAlpa,
    HDBarChartsAnimateTypeNone,
};


/**
 柱状图显示的动画方向

 - HDBarChartsAnimateDirectionToUp: 向上
 - HDBarChartsAnimateDirectionToDown: 向下
 */
typedef NS_ENUM(NSInteger, HDBarChartsAnimateDirection) {
    HDBarChartsAnimateDirectionToUp = 0,
    HDBarChartsAnimateDirectionToDown,
};

@interface HDBarChartsView : UIView

@property (nonatomic, assign) BOOL xAxisScrollEnable; //X轴是否需要滚动
@property (nonatomic, assign) CGFloat blockSpace;  //柱形区块之间的间距(默认动态计算)

//X轴的标题相关
@property (nonatomic, strong) NSString *xAxisTitle;
@property (nonatomic, strong) UIFont *xAxisFont;
@property (nonatomic, strong) UIColor *xAxisColor;

//XY轴线的起始位置、颜色
@property (nonatomic, assign) CGFloat xAxisLineOriginX;
@property (nonatomic, assign) CGFloat yAxisLineOriginY;
@property (nonatomic, assign) CGFloat xyAxisLineWidth;
@property (nonatomic, strong) UIColor *xAxisLineColor;
@property (nonatomic, strong) UIColor *yAxisLineColor;

//Y轴的标题
@property (nonatomic, strong) NSArray <NSNumber *> *yAxisElements;
@property (nonatomic, assign) CGFloat maxYAxisValue;

//Y轴的标题相关
@property (nonatomic, strong) NSString *yAxisTitle;
@property (nonatomic, strong) UIFont *yAxisFont;
@property (nonatomic, strong) UIColor *yAxisColor;


// 柱状图显示的动画时长(默认是1秒)，动画类型(默认无)，动画方向(默认向上)
@property (nonatomic, assign) NSTimeInterval barShowDuration;
@property (nonatomic, assign) HDBarChartsAnimateType barShowAnimateType;
@property (nonatomic, assign) HDBarChartsAnimateDirection barShowAnimateDirection;


// 刷新数据
- (void)reloadBarChartsView:(NSArray <HDBarChartsBlock *> *)blocks;

@end
