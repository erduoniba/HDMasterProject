//
//  HDEyeView.h
//  HDMasterProject
//
//  Created by 邓立兵 on 2018/3/22.
//  Copyright © 2018年 HarryDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDEyeView : UIView {

    CAShapeLayer        *eyeFirstLightLayer;

    CAShapeLayer        *eyeSecondLightLayer;

    CAShapeLayer        *eyeballLayer;

    CAShapeLayer        *topEyesocketLayer;

    CAShapeLayer        *bottomEyesocketLayer;
}

-(void)changeFloat:(CGFloat)y;

@end
