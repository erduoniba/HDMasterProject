//
//  Customview.m
//  FDDPhotoDemo
//
//  Created by Harry on 16/4/13.
//  Copyright © 2016年 HarryDeng. All rights reserved.
//

#import "HDTouchControlView.h"

@implementation HDTouchControlView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    //将手势的点击点point，转换到_bottomView的坐标
    //point：点击点相对于self的坐标 pointNew：点击点相对于_bottomView的坐标
    CGPoint pointNew = [_bottomView convertPoint:point fromView:self];
    
    // pointNew 改点击坐标是否能在 _bottomView 相应
    BOOL respose = [_bottomView pointInside:pointNew withEvent:event];
//    NSLog(@"pointNew.y : %0.2f  respose : %d", pointNew.y, respose);
    
    if (respose && (pointNew.y > 0 && pointNew.y < 200 + _navHeight)){
        // 当点击区域Y轴在0-200（即图片区域位置），将该点击事件交给 _bottomView 相应
        return [_bottomView hitTest:pointNew withEvent:event];
    }
    
    return [super hitTest:point withEvent:event];
}


@end
