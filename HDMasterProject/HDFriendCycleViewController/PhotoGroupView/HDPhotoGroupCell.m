//
//  NHPhotoGroupCell.m
//  HDMasterProject
//
//  Created by Harry on 15/12/4.
//  Copyright © 2015年 HarryDeng. All rights reserved.
//

#import "HDPhotoGroupCell.h"
#import "UIImageView+WebCache.h"
#import "HDPhotoGroupView.h"
#import "UIView+Helpers.h"

@implementation HDPhotoGroupCell

- (instancetype)init {
    self = super.init;
    if (!self) return nil;
    self.delegate = self;
    self.bouncesZoom = YES;
    self.maximumZoomScale = 3;
    self.multipleTouchEnabled = YES;
    self.alwaysBounceVertical = NO;
    self.showsVerticalScrollIndicator = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.frame = [UIScreen mainScreen].bounds;
    
    _imageContainerView = [UIView new];
    _imageContainerView.clipsToBounds = YES;
    [self addSubview:_imageContainerView];
    
    _imageView = [UIImageView new];
    _imageView.clipsToBounds = YES;
    _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
    [_imageContainerView addSubview:_imageView];
    
    CGRect rect = CGRectMake(0, 0, 40, 40);
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = rect;
    _progressLayer.cornerRadius = 20;
    _progressLayer.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500].CGColor;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(_progressLayer.bounds, 7, 7) cornerRadius:(40 / 2 - 7)];
    _progressLayer.path = path.CGPath;
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    _progressLayer.lineWidth = 4;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.strokeStart = 0;
    _progressLayer.strokeEnd = 0;
    _progressLayer.hidden = YES;
    [self.layer addSublayer:_progressLayer];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = _progressLayer.frame;
    CGPoint center = CGPointMake(self.frameSizeWidth / 2, self.frameSizeHeight / 2);
    frame.origin.x = center.x - frame.size.width * 0.5;
    frame.origin.y = center.y - frame.size.height * 0.5;
    _progressLayer.frame = frame;
}

- (void)setItem:(HDPhotoGroupItem *)item {
    if (_item == item) return;
    _item = item;
    _itemDidLoad = NO;
    
    
    [self setZoomScale:1.0 animated:NO];
    self.maximumZoomScale = 1;
    
 
    
    _progressLayer.hidden = NO;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _progressLayer.strokeEnd = 0;
    _progressLayer.hidden = YES;
    [CATransaction commit];
    
    if (!_item) {
        _imageView.image = nil;
        return;
    }
    
    
    __weak typeof(self) wSelf = self;
    [_imageView sd_setImageWithURL:item.largeImageURL placeholderImage:item.thumbImage options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        __strong typeof(wSelf) sSelf = wSelf;
        if (!sSelf) return;
        CGFloat progress = receivedSize / (float)expectedSize;
        progress = progress < 0.01 ? 0.01 : progress > 1 ? 1 : progress;
        if (isnan(progress)) progress = 0;
        sSelf.progressLayer.hidden = NO;
        sSelf.progressLayer.strokeEnd = progress;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        __strong typeof(wSelf) sSelf = wSelf;
        if (!sSelf) return;
        sSelf.progressLayer.hidden = YES;
        if (image) {
            sSelf.maximumZoomScale = 3;
            if (image) {
                sSelf->_itemDidLoad = YES;
                
                [sSelf resizeSubviewSize];
            }
        }
    }];
    
    [self resizeSubviewSize];
}

- (void)resizeSubviewSize {
    _imageContainerView.frameOrigin = CGPointZero;
    _imageContainerView.frameSizeWidth = self.frameSizeWidth;
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.frameSizeHeight / self.frameSizeWidth) {
        _imageContainerView.frameSizeHeight = floor(image.size.height / (image.size.width / self.frameSizeWidth));
    } else {
        CGFloat height = image.size.height / image.size.width * self.frameSizeWidth;
        if (height < 1 || isnan(height)) height = self.frameSizeHeight;
        height = floor(height);
        _imageContainerView.frameSizeHeight = height;
        _imageContainerView.frameCenterY  = self.frameSizeHeight / 2;
    }
    if (_imageContainerView.frameSizeHeight > self.frameSizeHeight && _imageContainerView.frameSizeHeight - self.frameSizeHeight <= 1) {
        _imageContainerView.frameSizeHeight = self.frameSizeHeight;
    }
    self.contentSize = CGSizeMake(self.frameSizeWidth, MAX(_imageContainerView.frameSizeHeight, self.frameSizeHeight));
    [self scrollRectToVisible:self.bounds animated:NO];
    
    if (_imageContainerView.frameSizeHeight <= self.frameSizeHeight) {
        self.alwaysBounceVertical = NO;
    } else {
        self.alwaysBounceVertical = YES;
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _imageView.frame = _imageContainerView.bounds;
    [CATransaction commit];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageContainerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIView *subView = _imageContainerView;
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

@end
