//
//  HDEyeCoverView.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2018/3/22.
//  Copyright © 2018年 HarryDeng. All rights reserved.
//

#import "HDEyeCoverView.h"

@implementation HDEyeCoverView {
    CGFloat redValue;
    CGFloat greenValue;
    CGFloat blueValue;
    CGFloat alphaValue;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _percent = 0;
        self.backgroundColor = [UIColor clearColor];
        _coverColor = [UIColor blackColor];
        redValue = 0;
        greenValue = 0;
        blueValue = 0;
        alphaValue = 1;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [_coverColor setFill];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat bwidth = self.bounds.size.width;
    CGFloat bheight = self.bounds.size.height;
    CGRect aRect= CGRectMake(0, 0, bwidth, bheight);
    CGContextSetRGBStrokeColor(context, redValue, greenValue, blueValue, alphaValue);
    CGContextAddEllipseInRect(context, aRect); //椭圆
    CGContextDrawPath(context,kCGPathFillStroke); //有颜色填充

    CGFloat width = bwidth * _percent;
    CGFloat height = bheight * _percent;

    aRect= CGRectMake((bwidth - width) / 2, (bheight - width) / 2, width, width);
    CGContextSaveGState(context);
    CGPathRef radiusPath = [UIBezierPath bezierPathWithRoundedRect:aRect cornerRadius:height/2].CGPath;   //沿着frame，按照radius圆角绘制路径
    CGContextAddPath(context,radiusPath);  //将圆角路径绘制到画布上
    CGContextClip(context);
    CGContextClearRect(context,aRect);  //将当前画布设置透明
    CGContextRestoreGState(context);
}


- (void)setCoverColor:(UIColor *)coverColor{
    _coverColor = coverColor;
    NSArray *arr = [self changeUIColorToRGB:coverColor];
    if (arr.count == 4) {
        redValue = [arr[0] floatValue];
        greenValue = [arr[1] floatValue];
        blueValue = [arr[2] floatValue];
        alphaValue =  [arr[3] floatValue];
    }
}

//将UIColor转换为RGB值
- (NSMutableArray *) changeUIColorToRGB:(UIColor *)color
{
    NSMutableArray *RGBStrValueArr = [[NSMutableArray alloc] init];

    //获得RGB值描述
    NSString *RGBValue = [NSString stringWithFormat:@"%@",color];
    //将RGB值描述分隔成字符串
    NSArray *RGBArr = [RGBValue componentsSeparatedByString:@" "];

    if (RGBArr.count > 1) {
        //获取红色值
        CGFloat r = [[RGBArr objectAtIndex:1] floatValue];
        [RGBStrValueArr addObject:@(r)];
    }

    if (RGBArr.count > 2) {
        //获取绿色值
        CGFloat g = [[RGBArr objectAtIndex:2] floatValue];
        [RGBStrValueArr addObject:@(g)];
    }

    if (RGBArr.count > 3) {
        //获取蓝色值
        CGFloat b = [[RGBArr objectAtIndex:3] floatValue];
        [RGBStrValueArr addObject:@(b)];
    }

    if (RGBArr.count > 4) {
        //获取透明度值
        CGFloat a = [[RGBArr objectAtIndex:4] floatValue];
        [RGBStrValueArr addObject:@(a)];
    }

    //返回保存RGB值的数组
    return RGBStrValueArr;
}

@end
