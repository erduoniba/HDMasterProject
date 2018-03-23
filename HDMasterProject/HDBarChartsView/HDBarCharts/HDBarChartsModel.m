//
//  HDBarChartsModel.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2018/3/21.
//  Copyright © 2018年 HarryDeng. All rights reserved.
//

#import "HDBarChartsModel.h"

@implementation HDBarChartsElement

- (instancetype)init {
    self = [super init];
    if (self) {
        _lineWidth = 8.0f;
        _color = [UIColor blueColor];
        _bgColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:248/255.0 alpha:1];
    }
    return self;
}

@end

@implementation HDBarChartsBlock

- (instancetype)init {
    self = [super init];
    if (self) {
        _lineSpace = 0.0f;
        _xAxisFont = [UIFont systemFontOfSize:12];
        _xAxisColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
    }
    return self;
}

@end
