//
//  HDPasswordItem.h
//  HDMasterProject
//
//  Created by 邓立兵 on 2019/3/11.
//  Copyright © 2019 HarryDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ITEMRADIUS_OUTTER    60  //item的外圆直径
#define ITEMRADIUS_INNER     24  //item的内圆直径
#define ITEMRADIUS_LINEWIDTH 1   //item的线宽
#define ITEMWH               60  //item的宽高
#define ITEM_TOTAL_POSITION  0  // 整个item的顶点位置

typedef enum {
    HDselectStyleNormal,
    HDselectStyleSelect ,
    HDselectStyleWrong
} HDselectStyleModel;

NS_ASSUME_NONNULL_BEGIN

@interface HDPasswordItem : UIView

@property(nonatomic , assign) HDselectStyleModel selectStyle;

@property(nonatomic , strong) CAShapeLayer *outterLayer;
@property(nonatomic , strong) CAShapeLayer *innerLayer;
@property(nonatomic , strong) CAShapeLayer *triangleLayer;

@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectColor;
@property (nonatomic, strong) UIColor *wrongColor;

@property(nonatomic , assign)BOOL isSelect;

- (void)judegeDirectionActionx1:(CGFloat)x1 y1:(CGFloat)y1 x2:(CGFloat)x2 y2:(CGFloat)y2 isHidden:(BOOL)isHidden;

@end

NS_ASSUME_NONNULL_END
