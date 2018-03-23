//
//  HDEyeView.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2018/3/22.
//  Copyright © 2018年 HarryDeng. All rights reserved.
//

#import "HDEyeView.h"

#define   kDegreesToRadians(degrees)  ((M_PI * degrees)/ 180)

@implementation HDEyeView

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];

    if (self) {

        [self createUI];

    }
    return self;
}

-(void)createUI{

    [self.layer addSublayer:[self eyeFirstLightLayer]];

    [self.layer addSublayer:[self eyeSecondLightLayer]];

    [self.layer addSublayer:[self eyeballLayer]];

    [self.layer addSublayer:[self topEyesocketLayer]];

    [self.layer addSublayer:[self bottomEyesocketLayer]];

    [self setupAnimation];

}

//长 眼神
-(CAShapeLayer *)eyeFirstLightLayer{

    if (!eyeFirstLightLayer) {

        eyeFirstLightLayer = [CAShapeLayer layer];

        CGPoint center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);

        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:CGRectGetHeight(self.frame) * 0.2 startAngle:kDegreesToRadians(230) endAngle:kDegreesToRadians(265) clockwise:YES];

        eyeFirstLightLayer.borderColor = [UIColor blackColor].CGColor;

        eyeFirstLightLayer.lineWidth = 5.0f;

        eyeFirstLightLayer.path = path.CGPath;

        eyeFirstLightLayer.fillColor = [UIColor clearColor].CGColor;

        eyeFirstLightLayer.strokeColor = [UIColor whiteColor].CGColor;

    }

    return eyeFirstLightLayer;
}

//短 眼神
-(CAShapeLayer *)eyeSecondLightLayer{

    if (!eyeSecondLightLayer) {

        eyeSecondLightLayer = [CAShapeLayer layer];

        CGPoint center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);

        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:CGRectGetHeight(self.frame) * 0.2 startAngle:kDegreesToRadians(211) endAngle:kDegreesToRadians(220) clockwise:YES];

        eyeSecondLightLayer.borderColor = [UIColor blackColor].CGColor;

        eyeSecondLightLayer.lineWidth = 5.0f;

        eyeSecondLightLayer.path = path.CGPath;

        eyeSecondLightLayer.fillColor = [UIColor clearColor].CGColor;

        eyeSecondLightLayer.strokeColor = [UIColor whiteColor].CGColor;

    }

    return eyeSecondLightLayer;
}

//圆
-(CAShapeLayer *)eyeballLayer{

    if (!eyeballLayer) {

        eyeballLayer = [CAShapeLayer layer];

        CGPoint center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);

        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:CGRectGetHeight(self.frame) * 0.3 startAngle:kDegreesToRadians(0) endAngle:kDegreesToRadians(360) clockwise:YES];

        eyeballLayer.borderColor = [UIColor blackColor].CGColor;

        eyeballLayer.lineWidth = 1.0f;

        eyeballLayer.path = path.CGPath;

        eyeballLayer.fillColor = [UIColor clearColor].CGColor;

        eyeballLayer.strokeColor = [UIColor whiteColor].CGColor;

        eyeballLayer.anchorPoint = CGPointMake(0.5, 0.5);

    }

    return eyeballLayer;
}

//上半部分 贝塞尔曲线
-(CAShapeLayer *)topEyesocketLayer{

    if (!topEyesocketLayer) {

        topEyesocketLayer = [CAShapeLayer layer];

        CGPoint center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);

        UIBezierPath *path = [UIBezierPath bezierPath];

        [path moveToPoint:CGPointMake((CGRectGetWidth(self.frame) - CGRectGetHeight(self.frame) * 1.2) / 2, CGRectGetHeight(self.frame) / 2)];

        [path addQuadCurveToPoint:CGPointMake((CGRectGetWidth(self.frame) + CGRectGetHeight(self.frame) * 1.2) / 2, CGRectGetHeight(self.frame) / 2) controlPoint:CGPointMake(CGRectGetWidth(self.frame) / 2, center.y - center.y - 20)];

        topEyesocketLayer.borderColor = [UIColor blackColor].CGColor;

        topEyesocketLayer.lineWidth = 1.0f;

        topEyesocketLayer.path = path.CGPath;

        topEyesocketLayer.fillColor = [UIColor clearColor].CGColor;

        topEyesocketLayer.strokeColor = [UIColor whiteColor].CGColor;

    }

    return topEyesocketLayer;
}

//下半部分 贝塞尔曲线
- (CAShapeLayer *)bottomEyesocketLayer{

    if (!bottomEyesocketLayer) {

        bottomEyesocketLayer = [CAShapeLayer layer];

        CGPoint center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);

        UIBezierPath *path = [UIBezierPath bezierPath];

        [path moveToPoint:CGPointMake((CGRectGetWidth(self.frame) - CGRectGetHeight(self.frame) * 1.2) / 2, CGRectGetHeight(self.frame) / 2)];

        [path addQuadCurveToPoint:CGPointMake((CGRectGetWidth(self.frame) + CGRectGetHeight(self.frame) * 1.2) / 2, CGRectGetHeight(self.frame) / 2)
                     controlPoint:CGPointMake(CGRectGetWidth(self.frame) / 2, center.y + center.y + 20)];

        bottomEyesocketLayer.borderColor = [UIColor blackColor].CGColor;

        bottomEyesocketLayer.lineWidth = 1.f;

        bottomEyesocketLayer.path = path.CGPath;

        bottomEyesocketLayer.fillColor = [UIColor clearColor].CGColor;

        bottomEyesocketLayer.strokeColor = [UIColor whiteColor].CGColor;

    }

    return bottomEyesocketLayer;
}

- (void)setupAnimation {

    eyeFirstLightLayer.lineWidth = 0.f;

    eyeSecondLightLayer.lineWidth = 0.f;

    eyeballLayer.opacity = 0.f;

    bottomEyesocketLayer.strokeStart = 0.5f;

    bottomEyesocketLayer.strokeEnd = 0.5f;

    topEyesocketLayer.strokeStart = 0.5f;

    topEyesocketLayer.strokeEnd = 0.5f;

}

-(void)changeFloat:(CGFloat)y{

    CGFloat flag = -50;

    if (y < flag) {

        if (eyeFirstLightLayer.lineWidth < 5.0f) {

            eyeFirstLightLayer.lineWidth += 1;

            eyeSecondLightLayer.lineWidth += 1;

        }

    }

    if (y < flag - 20) {

        if (eyeballLayer.opacity <= 1) {

            eyeballLayer.opacity += 0.1;

        }

    }

    if (y < flag - 40) {

        if (topEyesocketLayer.strokeEnd < 1 && topEyesocketLayer.strokeStart > 0) {

            topEyesocketLayer.strokeEnd += 0.1;

            topEyesocketLayer.strokeStart -= 0.1;

            bottomEyesocketLayer.strokeEnd += 0.1;

            bottomEyesocketLayer.strokeStart -= 0.1;

        }

    }




    if (y > flag - 40) {

        if (topEyesocketLayer.strokeEnd > 0.5 && topEyesocketLayer.strokeStart < 0.5) {

            topEyesocketLayer.strokeEnd -= 0.1;

            topEyesocketLayer.strokeStart += 0.1;

            bottomEyesocketLayer.strokeEnd -= 0.1;

            bottomEyesocketLayer.strokeStart += 0.1;

        }

    }

    if (y > flag - 20) {

        if (eyeballLayer.opacity >= 0) {

            eyeballLayer.opacity -= 0.1;

        }

    }


    if (y > flag) {

        if (eyeFirstLightLayer.lineWidth > 0) {

            eyeFirstLightLayer.lineWidth -= 1;

            eyeSecondLightLayer.lineWidth -= 1;

        }

    }

}

@end

