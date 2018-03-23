//
//  WeiXinAnimateView.m
//  WeinXinVideo
//
//  Created by Harry on 15/9/2.
//  Copyright (c) 2015年 Harry. All rights reserved.
//

#import "HDEyeAnimateView.h"

#import "HDEyeCoverView.h"

@implementation HDEyeAnimateView {
    UIImage *_eyeImage;
    UIImageView *_eyeIView;
    HDEyeCoverView *_coverView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _percent = 0;
        [self initEyeImageView];
        [self initEyeCoverView];
    }
    return self;
}

- (void)initEyeImageView {
    _eyeImage = [UIImage imageNamed:@"icon_sight_capture_mask"];
    CGFloat imageWidth = _eyeImage.size.width;
    CGFloat imageHeight = _eyeImage.size.height;
    _eyeIView = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width - imageWidth) / 2.0,
                                                             (self.bounds.size.height - imageHeight) / 2.0,  imageWidth,
                                                             imageHeight)];
    _eyeIView.image = _eyeImage;
    _eyeIView.alpha = 0;
    [self addSubview:_eyeIView];
}

- (void)initEyeCoverView {
    _coverView = [[HDEyeCoverView alloc] initWithFrame:_eyeIView.frame];
    [self addSubview:_coverView];
}

- (void)setCoverColor:(UIColor *)coverColor{
    _coverView.coverColor = coverColor;
}

- (void)setPercent:(CGFloat)percent {
    _percent = percent;
    
    _eyeIView.alpha = _percent;

    if (percent >= 1) {
        _eyeIView.alpha = 1;
        _percent = 1;
        [_coverView setNeedsDisplay];
        return ;
    }
    _coverView.percent = percent;
    [_coverView setNeedsDisplay];
}

- (void)setEyeImage:(UIImage *)eyeImage {
    _eyeImage = eyeImage;
    CGFloat imageWidth = eyeImage.size.width;
    CGFloat imageHeight = eyeImage.size.height;

    _eyeIView.frame = CGRectMake((self.bounds.size.width - imageWidth) / 2.0,
                                 (self.bounds.size.height - imageHeight) / 2.0,
                                 imageWidth,
                                 imageHeight);
    _eyeIView.image = eyeImage;
    _coverView.frame = _eyeIView.frame;
}

@end
