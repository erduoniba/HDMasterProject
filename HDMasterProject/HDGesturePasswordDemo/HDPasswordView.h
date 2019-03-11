//
//  HDPasswordView.h
//  HDMasterProject
//
//  Created by 邓立兵 on 2019/3/11.
//  Copyright © 2019 HarryDeng. All rights reserved.
//


#define ITEMRADIUS_OUTTER    60  //item的外圆直径
#define ITEMRADIUS_INNER     24  //item的内圆直径
#define ITEMRADIUS_LINEWIDTH 1   //item的线宽
#define ITEMWH               60  //item的宽高
#define ITEM_TOTAL_POSITION  0  // 整个item的顶点位置



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^HDPasswordBlock) (NSString *pswString);

@interface HDPasswordView : UIView

@property(nonatomic , copy) HDPasswordBlock passwordBlock;

@property (nonatomic, strong) NSString *password;

@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectColor;
@property (nonatomic, strong) UIColor *wrongColor;

@end

NS_ASSUME_NONNULL_END
