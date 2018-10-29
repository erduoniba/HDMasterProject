//
//  HDSwitch.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2018/8/27.
//  Copyright © 2018年 HarryDeng. All rights reserved.
//

#import "HDSwitch.h"

@interface HDSwitch ()
@property(nonatomic,strong)UIImage *onImage;
@property(nonatomic,strong)UIImage *offImage;
@end


@implementation HDSwitch

- (instancetype)initWithFrame:(CGRect)frame {
    NSAssert(NO, @"请使用 -initWithOnImage:(UIImage *)onImage offImage:(UIImage *)offImage frame:(CGRect)frame 初始化CLSwitch");
    return nil;
}

- (instancetype)initWithOnImage:(UIImage *)onImage offImage:(UIImage *)offImage frame:(CGRect)frame{
    NSAssert(onImage&&offImage, @"onImage & offImage 不能为空");
    frame.size = onImage.size;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _onImage = onImage;
        _offImage = offImage;
        [self addTarget:self action:@selector(switchClicked) forControlEvents:UIControlEventTouchUpInside];
        self.isOn = NO;
    }
    return self;
}

- (void)switchClicked {
    self.isOn = !self.isOn;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setIsOn:(BOOL)isOn {
    _isOn = isOn;

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"contents"];
    animation.fromValue = self.layer.contents;
    animation.toValue = (id)(_isOn ? _onImage.CGImage: _offImage.CGImage);
    animation.duration = .3;
    [self.layer addAnimation: animation forKey: @"animation"];

    self.layer.contents = (id)(_isOn ? _onImage.CGImage: _offImage.CGImage);
}

- (void)setFrame:(CGRect)frame {
    if (_onImage) {
        frame.size = _onImage.size;
    }
    super.frame = frame;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return _onImage.size;
}


@end
