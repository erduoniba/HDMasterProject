//
//  HDBarChartsView.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2018/3/20.
//  Copyright © 2018年 HarryDeng. All rights reserved.
//

#import "HDBarChartsView.h"

#import "HDBarChartsModel.h"
#import "HDBarChartsElementManager.h"

@interface HDBarChartsView ()

@property (nonatomic, strong) HDBarChartsElementManager *barChartsElementManager;

@property (nonatomic, strong) NSMutableArray *xAxisElementViews; //X轴上的标度文字集合
@property (nonatomic, strong) NSMutableArray *yAxisElementViews; //Y轴上的标度文字集合
@property (nonatomic, strong) NSMutableArray *barElementViews;   //柱状图集合

@property (nonatomic, strong) UILabel *xAxisTitleLb; //X轴最右边文字
@property (nonatomic, strong) UILabel *yAxisTitleLb; //Y轴最上边文字

@property (nonatomic, strong) UIView *tagView1;
@property (nonatomic, strong) UILabel *tagLb1;
@property (nonatomic, strong) UIView *tagView2;
@property (nonatomic, strong) UILabel *tagLb2;

@property (nonatomic, strong) UIView *xAxisView; //X轴线
@property (nonatomic, strong) UIView *yAxisView; //Y轴线
@property (nonatomic, strong) UIScrollView *barChartsBgView; //柱状图的底界面

@end

@implementation HDBarChartsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _barChartsElementManager = [HDBarChartsElementManager sharedInstanceClass:UIView.class];
        [self initParams];
        [self initUI];
    }
    return self;
}

- (void)initParams {
    _blockSpace = 0.0f;
    _barShowDuration = 1.0f;
    _xAxisLineOriginX = 40.0f;
    _yAxisLineOriginY = 40.0f;
    _xyAxisLineWidth = 0.5f;
    _barShowAnimateType = HDBarChartsAnimateTypeNone;
    _xAxisElementViews = [NSMutableArray array];
    _yAxisElementViews = [NSMutableArray array];
    _barElementViews = [NSMutableArray array];

    _yAxisFont = [UIFont systemFontOfSize:12];
    _yAxisColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    _xAxisLineColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
    _yAxisLineColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
    _yAxisTitle = @"次数";
}

- (void)initUI {
    _xAxisTitleLb = [self ms_createLabelWithFrame:CGRectMake(10, 0, 40, 14)
                                             text:_yAxisTitle
                                        textColor:_yAxisColor
                                             font:_yAxisFont];
    _xAxisTitleLb.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_xAxisTitleLb];

    _tagView1 = [[UIView alloc] initWithFrame:CGRectMake(_xAxisTitleLb.frame.origin.x + _xAxisTitleLb.frame.size.width + 20,
                                                         _xAxisTitleLb.frame.origin.y + 1,
                                                         10,
                                                         10)];
    _tagView1.backgroundColor = [UIColor colorWithRed:42/255.0 green:210/255.0 blue:252/255.0 alpha:1];
    [self addSubview:_tagView1];

    _tagLb1 = [self ms_createLabelWithFrame:CGRectMake(_tagView1.frame.origin.x + _tagView1.frame.size.width + 10,
                                                       _xAxisTitleLb.frame.origin.y,
                                                       40,
                                                       14)
                                       text:@"冷藏室"
                                  textColor:[self xyAxisTextColor]
                                       font:_yAxisFont];
    [self addSubview:_tagLb1];

    _tagView2 = [[UIView alloc] initWithFrame:CGRectMake(_tagLb1.frame.origin.x + _tagLb1.frame.size.width + 20,
                                                         _xAxisTitleLb.frame.origin.y + 1,
                                                         10,
                                                         10)];
    _tagView2.backgroundColor = [UIColor colorWithRed:27/255.0 green:129/255.0 blue:251/255.0 alpha:1];
    [self addSubview:_tagView2];

    _tagLb2 = [self ms_createLabelWithFrame:CGRectMake(_tagView2.frame.origin.x + _tagView2.frame.size.width + 10,
                                                       _xAxisTitleLb.frame.origin.y,
                                                       80,
                                                       14)
                                       text:@"下段冷冻室"
                                  textColor:[self xyAxisTextColor]
                                       font:_yAxisFont];
    [self addSubview:_tagLb2];

    _xAxisView = [[UIView alloc] initWithFrame:CGRectMake(_xAxisLineOriginX, self.bounds.size.height - _yAxisLineOriginY, self.bounds.size.width - 2 * _xAxisLineOriginX, _xyAxisLineWidth)];
    _xAxisView.backgroundColor = _xAxisLineColor;
    [self addSubview:_xAxisView];
    [self bringSubviewToFront:_xAxisView];

    _yAxisView = [[UIView alloc] initWithFrame:CGRectMake(_xAxisLineOriginX, _yAxisLineOriginY, _xyAxisLineWidth, self.bounds.size.height - 2 * _yAxisLineOriginY)];
    _yAxisView.backgroundColor = _yAxisLineColor;
    [self addSubview:_yAxisView];
    [self bringSubviewToFront:_yAxisView];

    _barChartsBgView = [[UIScrollView alloc] initWithFrame:CGRectMake(_xAxisView.frame.origin.x,
                                                                      _yAxisView.frame.origin.y,
                                                                      _xAxisView.frame.size.width,
                                                                      _yAxisView.frame.size.height + _yAxisLineOriginY)];
    _barChartsBgView.scrollEnabled = YES;
    _barChartsBgView.clipsToBounds = YES;
    _barChartsBgView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_barChartsBgView];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _xAxisTitleLb.frame = CGRectMake(10, 0, 40, 14);
    _tagView1.frame = CGRectMake(_xAxisTitleLb.frame.origin.x + _xAxisTitleLb.frame.size.width + 20,
                                 _xAxisTitleLb.frame.origin.y + 1,
                                 10,
                                 10);
    _tagLb1.frame = CGRectMake(_tagView1.frame.origin.x + _tagView1.frame.size.width + 10,
                               _xAxisTitleLb.frame.origin.y,
                               40,
                               14);
    _tagView2.frame = CGRectMake(_tagLb1.frame.origin.x + _tagLb1.frame.size.width + 20,
                                 _xAxisTitleLb.frame.origin.y + 1,
                                 10,
                                 10);
    _tagLb2.frame = CGRectMake(_tagView2.frame.origin.x + _tagView2.frame.size.width + 10,
                               _xAxisTitleLb.frame.origin.y,
                               80,
                               14);

    _xAxisView.frame = CGRectMake(_xAxisLineOriginX, self.bounds.size.height - _yAxisLineOriginY, self.bounds.size.width - 2 * _xAxisLineOriginX, _xyAxisLineWidth);
    _yAxisView.frame = CGRectMake(_xAxisLineOriginX, _yAxisLineOriginY, _xyAxisLineWidth, self.bounds.size.height - 2 * _yAxisLineOriginY);

    _barChartsBgView.frame = CGRectMake(_xAxisView.frame.origin.x,
                                        _yAxisView.frame.origin.y,
                                        _xAxisView.frame.size.width,
                                        _yAxisView.frame.size.height + _yAxisLineOriginY);
}

- (void)reloadBarChartsView:(NSArray <HDBarChartsBlock *> *)blocks {
    [self removeSubElementViews:_xAxisElementViews];
    [_xAxisElementViews removeAllObjects];
    [self removeSubElementViews:_yAxisElementViews];
    [_yAxisElementViews removeAllObjects];
    for (UIView *view in _barElementViews) {
        [_barChartsElementManager saveBarChartsElementView:view];
        [view removeFromSuperview];
    }
    [_barElementViews removeAllObjects];


    CGFloat yAxisOriginX = 5;
    CGFloat yAxisOriginY = _yAxisLineOriginY;
    CGFloat yAxisHeight = _yAxisView.frame.size.height / _yAxisElements.count;
    for (int i=0; i<_yAxisElements.count; i++) {
        UILabel *yLb = [self ms_createLabelWithFrame:CGRectMake(yAxisOriginX, yAxisOriginY + i * yAxisHeight, 30, yAxisHeight)
                                                text:[_yAxisElements[i] stringValue]
                                           textColor:[self xyAxisTextColor]
                                                font:_yAxisFont];
        yLb.textAlignment = NSTextAlignmentRight;
        [self addSubview:yLb];
        [_yAxisElementViews addObject:yLb];
    }

    if (_blockSpace == 0) {
        NSInteger elementWidth = 0;
        for (int i=0; i<blocks.count; i++) {
            HDBarChartsBlock *block = blocks[i];
            for (int j=0; j<block.elememts.count; j++) {
                HDBarChartsElement *elememt = block.elememts[j];
                elementWidth += elememt.lineWidth;
            }
        }

        _blockSpace = (_xAxisView.frame.size.width - elementWidth) / (blocks.count + 1);
    }

    CGFloat originX = 0;
    for (int i=0; i<blocks.count; i++) {
        HDBarChartsBlock *block = blocks[i];
        originX += _blockSpace;

        for (int j=0; j<block.elememts.count; j++) {
            HDBarChartsElement *elememt = block.elememts[j];
            UIView *view = [_barChartsElementManager getBarChartsElementView];
            view.backgroundColor = elememt.color;
            CGFloat height = elememt.value / _maxYAxisValue * _barChartsBgView.frame.size.height;
            [_barElementViews addObject:view];
            [_barChartsBgView addSubview:view];

            if (_barShowAnimateDirection == HDBarChartsAnimateDirectionToUp) {
                view.frame = CGRectMake(originX, _barChartsBgView.bounds.size.height - _yAxisLineOriginY, elememt.lineWidth, 0);
            }
            else {
                view.frame = CGRectMake(originX, _barChartsBgView.frame.size.height - height - _yAxisLineOriginY, elememt.lineWidth, 0);
            }
            [self barChartsAnimate:view finalFrame:CGRectMake(originX, _barChartsBgView.frame.size.height - height - _yAxisLineOriginY, elememt.lineWidth, height)];

            originX += elememt.lineWidth;
        }

        UILabel *xLb = [self ms_createLabelWithFrame:CGRectMake(originX - 30, _barChartsBgView.frame.size.height - _yAxisLineOriginY + 10, 30, 14)
                                                text:block.xAxisTitle
                                           textColor:block.xAxisColor
                                                font:block.xAxisFont];
        xLb.textAlignment = NSTextAlignmentRight;
        [_barChartsBgView addSubview:xLb];
        [_xAxisElementViews addObject:xLb];
    }
    _barChartsBgView.contentSize = CGSizeMake(originX, _barChartsBgView.bounds.size.height);
}

- (void)barChartsAnimate:(UIView *)view finalFrame:(CGRect)frame {
    if (_barShowAnimateType == HDBarChartsAnimateTypeNone) {
        view.frame = frame;
    }
    else if (_barShowAnimateType == HDBarChartsAnimateTypeAlpa) {
        view.alpha = 0;
        [UIView animateWithDuration:_barShowDuration animations:^{
            view.alpha = 1;
            view.frame = frame;
        }];
    }
    else {
        [UIView animateWithDuration:_barShowDuration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             view.frame = frame;
                         } completion:^(BOOL finished) {

                         }];
    }
}

#pragma mark - 工具代码方法

- (void)removeSubElementViews:(NSArray *)views {
    for (UIView *view in views) {
        [view removeFromSuperview];
    }
}

- (UILabel *)ms_createLabelWithFrame:(CGRect)frame
                                text:(NSString *)text
                           textColor:(UIColor *)textColor
                                font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = textColor;
    label.font = font;
    return label;
}

- (UIColor *)xyAxisTextColor {
    return [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
}

@end

