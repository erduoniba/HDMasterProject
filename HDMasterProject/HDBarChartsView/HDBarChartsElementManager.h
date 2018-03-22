//
//  HDBarChartsElementManager.h
//  HDMasterProject
//
//  Created by 邓立兵 on 2018/3/20.
//  Copyright © 2018年 HarryDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 负责生成和回收柱状图
 */
@interface HDBarChartsElementManager<ElementType> : NSObject

+ (instancetype)sharedInstanceClass:(Class)eClass;
- (void)saveBarChartsElementView:(ElementType)elementView;
- (ElementType)getBarChartsElementView;

@end
