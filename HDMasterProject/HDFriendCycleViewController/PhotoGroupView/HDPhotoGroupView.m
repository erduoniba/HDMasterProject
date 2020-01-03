//
//  HDPhotoGroupView.m
//  HDMasterProject
//
//  Created by Harry on 15/12/4.
//  Copyright © 2015年 HarryDeng. All rights reserved.
//

#import "HDPhotoGroupView.h"
#import "UIView+Helpers.h"
#import "HDPhotoGroupCell.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#include <sys/sysctl.h>
#import <Accelerate/Accelerate.h>

#define kPadding 20
#define kHiColor [UIColor colorWithRGBHex:0x2dd6b8]
#define CURRENT_IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define NH_CLAMP(_x_, _low_, _high_)  (((_x_) > (_high_)) ? (_high_) : (((_x_) < (_low_)) ? (_low_) : (_x_)))

@interface HDPhotoGroupItem()<NSCopying>
@property (nonatomic, readonly) UIImage *thumbImage;
@property (nonatomic, readonly) BOOL thumbClippedToTop;
- (BOOL)shouldClipToTop:(CGSize)imageSize forView:(UIView *)view;
@end
@implementation HDPhotoGroupItem

- (UIImage *)thumbImage {
    if ([_thumbView respondsToSelector:@selector(image)]) {
        return ((UIImageView *)_thumbView).image;
    }
    return nil;
}

- (BOOL)thumbClippedToTop {
    if (_thumbView) {
        if (_thumbView.layer.contentsRect.size.height < 1) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)shouldClipToTop:(CGSize)imageSize forView:(UIView *)view {
    if (imageSize.width < 1 || imageSize.height < 1) return NO;
    if (view.frameSizeWidth < 1 || view.frameSizeHeight < 1) return NO;
    return imageSize.height / imageSize.width > view.frameSizeWidth / view.frameSizeHeight;
}

- (id)copyWithZone:(NSZone *)zone {
    HDPhotoGroupItem *item = [self.class new];
    return item;
}
@end



@interface HDPhotoGroupView() <UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, weak) UIView *fromView;
@property (nonatomic, weak) UIView *toContainerView;

@property (nonatomic, strong) UIImage *snapshotImage;
@property (nonatomic, strong) UIImage *snapshorImageHideFromView;

@property (nonatomic, strong) UIImageView *background;
@property (nonatomic, strong) UIImageView *blurBackground;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *cells;
@property (nonatomic, strong) UIPageControl *pager;
@property (nonatomic, assign) CGFloat pagerCurrentPage;
@property (nonatomic, assign) BOOL fromNavigationBarHidden;

@property (nonatomic, assign) NSInteger fromItemIndex;
@property (nonatomic, assign) BOOL isPresented;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGPoint panGestureBeginPoint;
@end

@implementation HDPhotoGroupView
- (instancetype)initWithGroupItems:(NSArray *)groupItems {
    self = [super init];
    if (groupItems.count == 0) return nil;
    _groupItems = groupItems.copy;
    _blurEffectBackground = YES;
    
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *model = [NSString stringWithUTF8String:machine];
    free(machine);
    
    static NSMutableSet *oldDevices;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        oldDevices = [NSMutableSet new];
        [oldDevices addObject:@"iPod1,1"];
        [oldDevices addObject:@"iPod2,1"];
        [oldDevices addObject:@"iPod3,1"];
        [oldDevices addObject:@"iPod4,1"];
        [oldDevices addObject:@"iPod5,1"];
        
        [oldDevices addObject:@"iPhone1,1"];
        [oldDevices addObject:@"iPhone1,1"];
        [oldDevices addObject:@"iPhone1,2"];
        [oldDevices addObject:@"iPhone2,1"];
        [oldDevices addObject:@"iPhone3,1"];
        [oldDevices addObject:@"iPhone3,2"];
        [oldDevices addObject:@"iPhone3,3"];
        [oldDevices addObject:@"iPhone4,1"];
        
        [oldDevices addObject:@"iPad1,1"];
        [oldDevices addObject:@"iPad2,1"];
        [oldDevices addObject:@"iPad2,2"];
        [oldDevices addObject:@"iPad2,3"];
        [oldDevices addObject:@"iPad2,4"];
        [oldDevices addObject:@"iPad2,5"];
        [oldDevices addObject:@"iPad2,6"];
        [oldDevices addObject:@"iPad2,7"];
        [oldDevices addObject:@"iPad3,1"];
        [oldDevices addObject:@"iPad3,2"];
        [oldDevices addObject:@"iPad3,3"];
    });
    if ([oldDevices containsObject:model]) {
        _blurEffectBackground = NO;
    }
    
    self.backgroundColor = [UIColor clearColor];
    self.frame = [UIScreen mainScreen].bounds;
    self.clipsToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap2.delegate = self;
    tap2.numberOfTapsRequired = 2;
    [tap requireGestureRecognizerToFail: tap2];
    [self addGestureRecognizer:tap2];
    
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
    press.delegate = self;
    [self addGestureRecognizer:press];
    
    if (CURRENT_IOS_VERSION >= 7) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
        _panGesture = pan;
    }
    
    
    _cells = @[].mutableCopy;
    
    _background = UIImageView.new;
    _background.frame = self.bounds;
    _background.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _blurBackground = UIImageView.new;
    _blurBackground.frame = self.bounds;
    _blurBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _contentView = UIView.new;
    _contentView.frame = self.bounds;
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _scrollView = UIScrollView.new;
    _scrollView.frame = CGRectMake(-kPadding / 2, 0, self.frameSizeWidth + kPadding, self.frameSizeHeight);
    _scrollView.delegate = self;
    _scrollView.scrollsToTop = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.alwaysBounceHorizontal = groupItems.count > 1;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.delaysContentTouches = NO;
    _scrollView.canCancelContentTouches = YES;
    
    _pager = [[UIPageControl alloc] init];
    _pager.hidesForSinglePage = YES;
    _pager.userInteractionEnabled = NO;
    _pager.frameSizeWidth = self.frameSizeWidth - 36;
    _pager.frameSizeHeight = 10;
    _pager.center = CGPointMake(self.frameSizeWidth / 2, self.frameSizeHeight - 18);
    _pager.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [self addSubview:_background];
    [self addSubview:_blurBackground];
    [self addSubview:_contentView];
    [_contentView addSubview:_scrollView];
    [_contentView addSubview:_pager];
    
    return self;
}


- (void)presentFromImageView:(UIView *)fromView
                 toContainer:(UIView *)toContainer
                    animated:(BOOL)animated
                  completion:(void (^)(void))completion {
    if (!toContainer) return;
    
    _fromView = fromView;
    _toContainerView = toContainer;
    
    NSInteger page = -1;
    for (NSUInteger i = 0; i < self.groupItems.count; i++) {
        if (fromView == ((HDPhotoGroupItem *)self.groupItems[i]).thumbView) {
            page = (int)i;
            break;
        }
    }
    if (page == -1) page = 0;
    _fromItemIndex = page;
    
    _snapshotImage = [_toContainerView snapshotImageAfterScreenUpdates:NO];
    BOOL fromViewHidden = fromView.hidden;
    fromView.hidden = YES;
    _snapshorImageHideFromView = [_toContainerView snapshotImage];
    fromView.hidden = fromViewHidden;
    
    _background.image = _snapshorImageHideFromView;
    _blurEffectBackground = NO;
    if (_blurEffectBackground) {
        _blurBackground.image = [self gaussianBlurWithBias:0.5 image:_snapshorImageHideFromView];
    } else {
        _blurBackground.image = [self imageWithColor:[UIColor blackColor] size:CGSizeMake(1, 1)];
    }
    
    self.frameSize  = _toContainerView.frameSize;
    _blurBackground.alpha = 0;
    //self.pager.alpha = 0;
    self.pager.numberOfPages = self.groupItems.count;
    self.pager.currentPage = page;
    [_toContainerView addSubview:self];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frameSizeWidth * self.groupItems.count, _scrollView.frameSizeHeight);
    [_scrollView scrollRectToVisible:CGRectMake(_scrollView.frameSizeWidth * _pager.currentPage, 0, _scrollView.frameSizeWidth, _scrollView.frameSizeHeight) animated:NO];
    [self scrollViewDidScroll:_scrollView];
    
    [UIView setAnimationsEnabled:YES];
    _fromNavigationBarHidden = [UIApplication sharedApplication].statusBarHidden;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:animated ? UIStatusBarAnimationFade : UIStatusBarAnimationNone];
    
    
    HDPhotoGroupCell *cell = [self cellForPage:self.currentPage];
    HDPhotoGroupItem *item = _groupItems[self.currentPage];
    
    if (!item.thumbClippedToTop) {
        NSString *imageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:item.largeImageURL];
        if ([[SDWebImageManager sharedManager].imageCache imageFromMemoryCacheForKey:imageKey ]) {
            cell.item = item;
        }
        cell.item = item;
    }
    if (!cell.item) {
        cell.imageView.image = item.thumbImage;
        [cell resizeSubviewSize];
    }
    
    if (item.thumbClippedToTop) {
        CGRect fromFrame = [_fromView convertRect:_fromView.bounds toView:cell];
        CGRect originFrame = cell.imageContainerView.frame;
        CGFloat scale = fromFrame.size.width / cell.imageContainerView.frameSizeWidth;
        
        cell.imageContainerView.frameCenterX = CGRectGetMidX(fromFrame);
        cell.imageContainerView.frameSizeHeight  = fromFrame.size.height / scale;
     
        [cell.imageContainerView.layer setValue:@(scale) forKeyPath:@"transform.scale"];
        cell.imageContainerView.frameCenterY = CGRectGetMidY(fromFrame);
        
        float oneTime = animated ? 0.25 : 0;
        [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            _blurBackground.alpha = 1;
        }completion:NULL];
        
        _scrollView.userInteractionEnabled = NO;
        [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [cell.imageContainerView.layer setValue:@(1) forKeyPath:@"transform.scale"];
            cell.imageContainerView.frame = originFrame;
            //_pager.alpha = 1;
        }completion:^(BOOL finished) {
            _isPresented = YES;
            [self scrollViewDidScroll:_scrollView];
            _scrollView.userInteractionEnabled = YES;
            [self hidePager];
            if (completion) completion();
        }];
        
    } else {
        CGRect fromFrame = [_fromView convertRect:_fromView.bounds toView:cell.imageContainerView];
//        if (fromFrame.size.width == 0 && fromFrame.size.height == 0) {
//            fromFrame = _toContainerView.bounds;
//        }
        cell.imageContainerView.clipsToBounds = NO;
        cell.imageView.frame = fromFrame;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        float oneTime = animated ? 0.18 : 0;
        [UIView animateWithDuration:oneTime*2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            _blurBackground.alpha = 1;
        }completion:NULL];
        
        _scrollView.userInteractionEnabled = NO;
        [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.imageView.frame = cell.imageContainerView.bounds;
            [cell.imageView.layer setValue:@(1.01) forKeyPath:@"transform.scale"];
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
                [cell.imageView.layer setValue:@(1) forKeyPath:@"transform.scale"];
            }completion:^(BOOL finished) {
                cell.imageContainerView.clipsToBounds = YES;
                _isPresented = YES;
                [self scrollViewDidScroll:_scrollView];
                _scrollView.userInteractionEnabled = YES;
                [self hidePager];
                if (completion) completion();
            }];
        }];
    }
}

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [UIView setAnimationsEnabled:YES];
    
    [[UIApplication sharedApplication] setStatusBarHidden:_fromNavigationBarHidden withAnimation:animated ? UIStatusBarAnimationFade : UIStatusBarAnimationNone];
    NSInteger currentPage = self.currentPage;
    HDPhotoGroupCell *cell = [self cellForPage:currentPage];
    HDPhotoGroupItem *item = _groupItems[currentPage];
    
    UIView *fromView = nil;
    if (_fromItemIndex == currentPage) {
        fromView = _fromView;
    } else {
        fromView = item.thumbView;
    }
    
    [self cancelAllImageLoad];
    _isPresented = NO;
    BOOL isFromImageClipped = fromView.layer.contentsRect.size.height < 1;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    if (isFromImageClipped) {
        CGRect frame = cell.imageContainerView.frame;
        cell.imageContainerView.layer.anchorPoint = CGPointMake(0.5, 0);
        cell.imageContainerView.frame = frame;
    }
    cell.progressLayer.hidden = YES;
    [CATransaction commit];
    
    
    
    
    if (fromView == nil) {
        self.background.image = _snapshotImage;
        [UIView animateWithDuration:animated ? 0.25 : 0 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
            self.alpha = 0.0;
            [self.scrollView.layer setValue:@(0.95) forKeyPath:@"transform.scale"];
            
            self.scrollView.alpha = 0;
            self.pager.alpha = 0;
            self.blurBackground.alpha = 0;
        }completion:^(BOOL finished) {
            [self.scrollView.layer setValue:@(1) forKeyPath:@"transform.scale"];
            [self removeFromSuperview];
            [self cancelAllImageLoad];
            if (completion) completion();
        }];
        return;
    }
    
    if (_fromItemIndex != currentPage) {
        _background.image = _snapshotImage;
        [self addFadeAnimationWithDuration:0.25 curve:UIViewAnimationCurveEaseOut layer:_background.layer];
    } else {
        _background.image = _snapshorImageHideFromView;
    }
    
    
    if (isFromImageClipped) {
        CGPoint off = cell.contentOffset;
        off.y = 0 - cell.contentInset.top;
        [cell setContentOffset:off animated:NO];
    }
    
    [UIView animateWithDuration:animated ? 0.2 : 0 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
        //_pager.alpha = 0.0;
        _blurBackground.alpha = 0.0;
        if (isFromImageClipped) {
            
            CGRect fromFrame = [fromView convertRect:fromView.bounds toView:cell];
            CGFloat scale = fromFrame.size.width / cell.imageContainerView.frameSizeWidth * cell.zoomScale;
            CGFloat height = fromFrame.size.height / fromFrame.size.width * cell.imageContainerView.frameSizeWidth;
            if (isnan(height)) height = cell.imageContainerView.frameSizeHeight;
            
            cell.imageContainerView.frameSizeHeight  = height;
            cell.imageContainerView.center = CGPointMake(CGRectGetMidX(fromFrame), CGRectGetMinY(fromFrame));
            [cell.imageContainerView.layer setValue:@(scale) forKeyPath:@"transform.scale"];
            
        } else {
            CGRect fromFrame = [fromView convertRect:fromView.bounds toView:cell.imageContainerView];
            cell.imageContainerView.clipsToBounds = NO;
            cell.imageView.contentMode = fromView.contentMode;
            cell.imageView.frame = fromFrame;
        }
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:animated ? 0.15 : 0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            cell.imageContainerView.layer.anchorPoint = CGPointMake(0.5, 0.5);
            [self removeFromSuperview];
            if (completion) completion();
        }];
    }];
    
    
}

- (void)dismiss {
    [self dismissAnimated:YES completion:nil];
}


- (void)cancelAllImageLoad {
    [_cells enumerateObjectsUsingBlock:^(HDPhotoGroupCell *cell, NSUInteger idx, BOOL *stop) {
        [cell.imageView sd_cancelCurrentAnimationImagesLoad];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateCellsForReuse];
    
    CGFloat floatPage = _scrollView.contentOffset.x / _scrollView.frameSizeWidth;
    NSInteger page = _scrollView.contentOffset.x / _scrollView.frameSizeWidth + 0.5;
    
    for (NSInteger i = page - 1; i <= page + 1; i++) { // preload left and right cell
        if (i >= 0 && i < self.groupItems.count) {
            HDPhotoGroupCell *cell = [self cellForPage:i];
            if (!cell) {
                HDPhotoGroupCell *cell = [self dequeueReusableCell];
                cell.page = i;
                cell.frameOriginX = (self.frameSizeWidth + kPadding) * i + kPadding / 2;
                
                if (_isPresented) {
                    cell.item = self.groupItems[i];
                }
                [self.scrollView addSubview:cell];
            } else {
                if (_isPresented && !cell.item) {
                    cell.item = self.groupItems[i];
                }
            }
        }
    }
    
    NSInteger intPage = floatPage + 0.5;
    intPage = intPage < 0 ? 0 : intPage >= _groupItems.count ? (int)_groupItems.count - 1 : intPage;
    _pager.currentPage = intPage;
//    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
//        _pager.alpha = 1;
//    }completion:^(BOOL finish) {
//    }];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self hidePager];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self hidePager];
}


- (void)hidePager {
//    [UIView animateWithDuration:0.3 delay:0.8 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut animations:^{
//        _pager.alpha = 0;
//    }completion:^(BOOL finish) {
//    }];
}

/// enqueue invisible cells for reuse
- (void)updateCellsForReuse {
    for (HDPhotoGroupCell *cell in _cells) {
        if (cell.superview) {
            if (cell.frameOriginX  > _scrollView.contentOffset.x + _scrollView.frameSizeWidth * 2||
                cell.frameMaxX  < _scrollView.contentOffset.x - _scrollView.frameSizeWidth) {
                [cell removeFromSuperview];
                cell.page = -1;
                cell.item = nil;
            }
        }
    }
}

/// dequeue a reusable cell
- (HDPhotoGroupCell *)dequeueReusableCell {
    HDPhotoGroupCell *cell = nil;
    for (cell in _cells) {
        if (!cell.superview) {
            return cell;
        }
    }
    
    cell = [HDPhotoGroupCell new];
    cell.frame = self.bounds;
    cell.imageContainerView.frame = self.bounds;
    cell.imageView.frame = cell.bounds;
    cell.page = -1;
    cell.item = nil;
    [_cells addObject:cell];
    return cell;
}

/// get the cell for specified page, nil if the cell is invisible
- (HDPhotoGroupCell *)cellForPage:(NSInteger)page {
    for (HDPhotoGroupCell *cell in _cells) {
        if (cell.page == page) {
            return cell;
        }
    }
    return nil;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.frameSize  = _toContainerView.frameSize;
    _scrollView.frame = CGRectMake(-kPadding / 2, 0, self.frameSizeWidth + kPadding, self.frameSizeHeight);
    _pager.frameSizeWidth = self.frameSizeWidth - 36;
    _pager.frameSizeHeight = 10;
    _pager.center = CGPointMake(self.frameSizeWidth / 2, self.frameSizeHeight - 18);
    _scrollView.contentSize = CGSizeMake(_scrollView.frameSizeWidth * self.groupItems.count, _scrollView.frameSizeHeight);
    
    HDPhotoGroupCell *cell = [self cellForPage:self.currentPage];
//    cell.imageView.frame = cell.bounds;
    
    NSLog(@"xxx : %f", self.bounds.size.width);
}

- (NSInteger)currentPage {
    NSInteger page = _scrollView.contentOffset.x / _scrollView.frameSizeWidth + 0.5;
    if (page >= _groupItems.count) page = (NSInteger)_groupItems.count - 1;
    if (page < 0) page = 0;
    return page;
}

CGSize CGSizePixelCeil(CGSize size) {
    CGFloat scale = [UIScreen mainScreen].scale;
    return CGSizeMake(ceil(size.width * scale) / scale,
                      ceil(size.height * scale) / scale);
}

- (void)showHUD:(NSString *)msg {
    if (!msg.length) return;
    UIFont *font = [UIFont systemFontOfSize:17];
    CGSize size = [self fdd_sizeWithFont:font constrainedToSize:CGSizeMake(200, 200) withString:msg];
    UILabel *label = [UILabel new];
    label.frameSize = CGSizePixelCeil(size);
    label.font = font;
    label.text = msg;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    
    UIView *hud = [UIView new];
    hud.frameSize = CGSizeMake(label.frameSizeWidth + 20, label.frameSizeHeight + 20);
    hud.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.650];
    hud.clipsToBounds = YES;
    hud.layer.cornerRadius = 8;
    
    label.center = CGPointMake(hud.frameSizeWidth / 2, hud.frameSizeHeight / 2);
    [hud addSubview:label];
    
    hud.center = CGPointMake(self.frameSizeWidth / 2, self.frameSizeHeight / 2);
    hud.alpha = 0;
    [self addSubview:hud];
    
    [UIView animateWithDuration:0.4 animations:^{
        hud.alpha = 1;
    }];
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIView animateWithDuration:0.4 animations:^{
            hud.alpha = 0;
        } completion:^(BOOL finished) {
            [hud removeFromSuperview];
        }];
    });
}

- (void)doubleTap:(UITapGestureRecognizer *)g {
    if (!_isPresented) return;
    HDPhotoGroupCell *tile = [self cellForPage:self.currentPage];
    if (tile) {
        if (tile.zoomScale > 1) {
            [tile setZoomScale:1 animated:YES];
        } else {
            CGPoint touchPoint = [g locationInView:tile.imageView];
            CGFloat newZoomScale = tile.maximumZoomScale;
            CGFloat xsize = self.frameSizeWidth  / newZoomScale;
            CGFloat ysize = self.frameSizeHeight / newZoomScale;
            [tile zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
        }
    }
}

- (void)longPress {
    if (!_isPresented) return;
    
    HDPhotoGroupCell *tile = [self cellForPage:self.currentPage];
    if (!tile.imageView.image) return;
    
    id imageItem = tile.imageView.image ;
    
    
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[imageItem] applicationActivities:nil];
    
    UIViewController *toVC = self.toContainerView.fdd_viewController;
    if (!toVC) toVC = self.fdd_viewController;
    [toVC presentViewController:activityViewController animated:YES completion:nil];
}

- (void)pan:(UIPanGestureRecognizer *)g {
    switch (g.state) {
        case UIGestureRecognizerStateBegan: {
            if (_isPresented) {
                _panGestureBeginPoint = [g locationInView:self];
            } else {
                _panGestureBeginPoint = CGPointZero;
            }
        } break;
        case UIGestureRecognizerStateChanged: {
            if (_panGestureBeginPoint.x == 0 && _panGestureBeginPoint.y == 0) return;
            CGPoint p = [g locationInView:self];
            CGFloat deltaY = p.y - _panGestureBeginPoint.y;
            _scrollView.frameOriginY = deltaY;
            
            CGFloat alphaDelta = 160;
            CGFloat alpha = (alphaDelta - fabs(deltaY) + 50) / alphaDelta;
            alpha = NH_CLAMP(alpha, 0, 1);
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
                _blurBackground.alpha = alpha;
                //_pager.alpha = alpha;
            } completion:nil];
            
        } break;
        case UIGestureRecognizerStateEnded: {
            if (_panGestureBeginPoint.x == 0 && _panGestureBeginPoint.y == 0) return;
            CGPoint v = [g velocityInView:self];
            CGPoint p = [g locationInView:self];
            CGFloat deltaY = p.y - _panGestureBeginPoint.y;
            
            if (fabs(v.y) > 1000 || fabs(deltaY) > 120) {
                [self cancelAllImageLoad];
                _isPresented = NO;
                [[UIApplication sharedApplication] setStatusBarHidden:_fromNavigationBarHidden withAnimation:UIStatusBarAnimationFade];
                
                BOOL moveToTop = (v.y < - 50 || (v.y < 50 && deltaY < 0));
                CGFloat vy = fabs(v.y);
                if (vy < 1) vy = 1;
                CGFloat duration = (moveToTop ? _scrollView.frameMaxY : self.frameSizeHeight - _scrollView.frameOriginY) / vy;
                duration *= 0.8;
                duration = NH_CLAMP(duration, 0.05, 0.3);
                
                [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState animations:^{
                    _blurBackground.alpha = 0;
                    //_pager.alpha = 0;
                    if (moveToTop) {
//                        _scrollView.frameMaxY = 0;
                        _scrollView.frameOriginY = -self.frameSizeHeight;
                    } else {
                        _scrollView.frameOriginY = self.frameSizeHeight;
                    }
                } completion:^(BOOL finished) {
                    [self removeFromSuperview];
                }];
                
                _background.image = _snapshotImage;
                [self addFadeAnimationWithDuration:0.3 curve:UIViewAnimationCurveEaseInOut layer:_background.layer];
                
            } else {
                [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:v.y / 1000 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
                    _scrollView.frameOriginY = 0;
                    _blurBackground.alpha = 1;
                    //_pager.alpha = 1;
                } completion:^(BOOL finished) {
                    
                }];
            }
            
        } break;
        case UIGestureRecognizerStateCancelled : {
            _scrollView.frameOriginY = 0;
            _blurBackground.alpha = 1;
        }
        default:break;
    }
}


#pragma mark - 支持的方法
CGContextRef NYXCreateARGBBitmapContext(const size_t width, const size_t height, const size_t bytesPerRow)
{
    /// Use the generic RGB color space
    /// We avoid the NULL check because CGColorSpaceRelease() NULL check the value anyway, and worst case scenario = fail to create context
    /// Create the bitmap context, we want pre-multiplied ARGB, 8-bits per component
    CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8/*Bits per component*/, bytesPerRow, CGColorSpaceCreateDeviceRGB(), kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    
    return bmContext;
}

static float __f_gaussianblur_kernel_5x5[25] = {
    1.0f/256.0f,  4.0f/256.0f,  6.0f/256.0f,  4.0f/256.0f, 1.0f/256.0f,
    4.0f/256.0f, 16.0f/256.0f, 24.0f/256.0f, 16.0f/256.0f, 4.0f/256.0f,
    6.0f/256.0f, 24.0f/256.0f, 36.0f/256.0f, 24.0f/256.0f, 6.0f/256.0f,
    4.0f/256.0f, 16.0f/256.0f, 24.0f/256.0f, 16.0f/256.0f, 4.0f/256.0f,
    1.0f/256.0f,  4.0f/256.0f,  6.0f/256.0f,  4.0f/256.0f, 1.0f/256.0f
};

-(UIImage*)gaussianBlurWithBias:(NSInteger)bias image:(UIImage *)image
{
    /// Create an ARGB bitmap context
    const size_t width = image.size.width;
    const size_t height = image.size.height;
    const size_t bytesPerRow = width * 4;
    CGContextRef bmContext = NYXCreateARGBBitmapContext(width, height, bytesPerRow);
    if (!bmContext)
        return nil;
    
    /// Draw the image in the bitmap context
    CGContextDrawImage(bmContext, (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = width, .size.height = height}, image.CGImage);
    
    /// Grab the image raw data
    UInt8* data = (UInt8*)CGBitmapContextGetData(bmContext);
    if (!data)
    {
        CGContextRelease(bmContext);
        return nil;
    }
    
    //去除提示这段代码不可能被执行的警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunreachable-code"
    
    
    const size_t pixelsCount = width * height;
    const size_t n = sizeof(float) * pixelsCount;
    float* dataAsFloat = malloc(n);
    float* resultAsFloat = malloc(n);
    
    /// Red components
    vDSP_vfltu8(data + 1, 4, dataAsFloat, 1, pixelsCount);
    vDSP_f5x5(dataAsFloat, height, width, __f_gaussianblur_kernel_5x5, resultAsFloat);
    vDSP_vfixu8(resultAsFloat, 1, data + 1, 4, pixelsCount);
    
    /// Green components
    vDSP_vfltu8(data + 2, 4, dataAsFloat, 1, pixelsCount);
    vDSP_f5x5(dataAsFloat, height, width, __f_gaussianblur_kernel_5x5, resultAsFloat);
    vDSP_vfixu8(resultAsFloat, 1, data + 2, 4, pixelsCount);
    
    /// Blue components
    vDSP_vfltu8(data + 3, 4, dataAsFloat, 1, pixelsCount);
    vDSP_f5x5(dataAsFloat, height, width, __f_gaussianblur_kernel_5x5, resultAsFloat);
    vDSP_vfixu8(resultAsFloat, 1, data + 3, 4, pixelsCount);
    
    free(resultAsFloat);
    free(dataAsFloat);
#pragma clang diagnostic pop//[-Wunreachable-code]
    
    CGImageRef blurredImageRef = CGBitmapContextCreateImage(bmContext);
    UIImage* blurred = [UIImage imageWithCGImage:blurredImageRef];
    
    /// Cleanup
    CGImageRelease(blurredImageRef);
    CGContextRelease(bmContext);
    
    return blurred;
}


- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO, .0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [color set];
    CGContextFillRect(context, CGRectMake(.0, .0, size.width, size.height));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)addFadeAnimationWithDuration:(NSTimeInterval)duration curve:(UIViewAnimationCurve)curve layer:(CALayer *)layer{
    if (duration <= 0) return;
    
    NSString *mediaFunction;
    switch (curve) {
        case UIViewAnimationCurveEaseInOut: {
            mediaFunction = kCAMediaTimingFunctionEaseOut;
        } break;
        case UIViewAnimationCurveEaseIn: {
            mediaFunction = kCAMediaTimingFunctionEaseIn;
        } break;
        case UIViewAnimationCurveEaseOut: {
            mediaFunction = kCAMediaTimingFunctionEaseInEaseOut;
        } break;
        case UIViewAnimationCurveLinear: {
            mediaFunction = kCAMediaTimingFunctionLinear;
        } break;
        default: {
            mediaFunction = kCAMediaTimingFunctionLinear;
        } break;
    }
    
    CATransition *transition = [CATransition animation];
    transition.duration = duration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:mediaFunction];
    transition.type = kCATransitionFade;
    [layer addAnimation:transition forKey:@"yykit.fade"];
}


- (CGSize)fdd_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size withString:(NSString *)string
{
    CGSize resultSize;
    if ([string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMethodSignature *signature = [[string class] instanceMethodSignatureForSelector:@selector(boundingRectWithSize:options:attributes:context:)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:string];
        [invocation setSelector:@selector(boundingRectWithSize:options:attributes:context:)];
        NSDictionary *attributes = @{ NSFontAttributeName:font };
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
        NSStringDrawingContext *context;
        [invocation setArgument:&size atIndex:2];
        [invocation setArgument:&options atIndex:3];
        [invocation setArgument:&attributes atIndex:4];
        [invocation setArgument:&context atIndex:5];
        [invocation invoke];
        CGRect rect;
        [invocation getReturnValue:&rect];
        resultSize = rect.size;
    } else {
        NSMethodSignature *signature = [[string class] instanceMethodSignatureForSelector:@selector(sizeWithFont:constrainedToSize:)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:string];
        [invocation setSelector:@selector(sizeWithFont:constrainedToSize:)];
        [invocation setArgument:&font atIndex:2];
        [invocation setArgument:&size atIndex:3];
        [invocation invoke];
        [invocation getReturnValue:&resultSize];
    }
    
    return resultSize;
}

@end
