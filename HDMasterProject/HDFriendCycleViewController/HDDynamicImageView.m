//
//  HDDynamicImageView.m
//  HDMasterProject
//
//  Created by Harry on 15/12/4.
//  Copyright © 2015年 HarryDeng. All rights reserved.
//

#import "HDDynamicImageView.h"

#import "UIImageView+WebCache.h"


static const CGFloat dynamicImageViewDistance = 9;
static const CGFloat dynamicImageViewOneLineCount = 3;

@implementation HDDynamicImageView{
    CGFloat dynamicImageViewWidth;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _imageViews = [NSMutableArray array];
        
        dynamicImageViewWidth = (kScreenWidth - dynamicImageViewDistance * 4) / 3;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    dynamicImageViewWidth = (kScreenWidth - dynamicImageViewDistance * 4) / 3;
    
    for (int i=0; i<_imageViews.count; i++) {
        UIImageView *imageView = _imageViews[i];
        NSInteger vLine = (int)i / (int)dynamicImageViewOneLineCount;
        NSInteger hLine = (int)i % (int)dynamicImageViewOneLineCount;
        imageView.frame = CGRectMake(dynamicImageViewDistance + (dynamicImageViewWidth + dynamicImageViewDistance) * hLine,
                                     dynamicImageViewDistance + (dynamicImageViewWidth + dynamicImageViewDistance) * vLine,                     dynamicImageViewWidth,
                                     dynamicImageViewWidth);
    }
}

- (void)setImageUrls:(NSArray<NSString *> *)imageUrls{

    _imageUrls = imageUrls;
    
    __weak typeof(self) weak_self = self;
    [_imageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weak_self) strong_self = weak_self;
        [strong_self.dynamicImageViewManager saveUseOne:obj];
        [obj removeFromSuperview];
    }];
    
    [_imageViews removeAllObjects];
    
    for (int i=0; i<imageUrls.count; i++) {
        UIImageView *imageView = [_dynamicImageViewManager getUseOne];
        NSInteger vLine = (int)i / (int)dynamicImageViewOneLineCount;
        NSInteger hLine = (int)i % (int)dynamicImageViewOneLineCount;
        imageView.frame = CGRectMake(dynamicImageViewDistance + (dynamicImageViewWidth + dynamicImageViewDistance) * hLine,
                                     dynamicImageViewDistance + (dynamicImageViewWidth + dynamicImageViewDistance) * vLine,                     dynamicImageViewWidth,
                                     dynamicImageViewWidth);
        __weak typeof(self) wSelf = self;
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrls[i]] placeholderImage:[UIImage imageNamed:@"loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            __strong typeof(self) sSelf = wSelf;
            UIImage *iii = [sSelf imageByResizeToSize:CGSizeMake(imageView.frame.size.width, imageView.frame.size.height) image:image];
            imageView.image = iii;
//            imageView.image = image;
        }];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageAction:)];
        [imageView addGestureRecognizer:tap];
        
        [self addSubview:imageView];
        [_imageViews addObject:imageView];
    }
}

- (UIImage *)imageByResizeToSize:(CGSize)size image:(UIImage *)oImage{
    if (size.width <= 0 || size.height <= 0) return nil;
    
    CGFloat originalWidth = oImage.size.width;
    CGFloat originalHeight = oImage.size.height;
    CGFloat destWidth, destHeight;
    
    if (originalWidth < originalHeight)
    {
        destWidth = size.width;
        destHeight = originalHeight * size.width / originalWidth;
    }
    else
    {
        destHeight = size.height;
        destWidth = originalWidth * size.height / originalHeight;
    }
    
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(destWidth * scale_screen, destHeight * scale_screen), NO, oImage.scale);
    [oImage drawInRect:CGRectMake(0, 0, destWidth * scale_screen, destHeight * scale_screen)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)imageAction:(UITapGestureRecognizer *)tap{
    UIImageView *imageView = (UIImageView *)[tap view];
    if (_tapIndex) {
        _tapIndex(imageView, imageView.tag);
    }
}


///< 设置图片宽度
-  (void)setImageWidth:(CGFloat)width{
    dynamicImageViewWidth = width;
}

///<根据数据获取高度，该界面已经包含上下间距
+ (CGFloat)getImageViewHeight:(NSArray *)imageUrls{
    return [self getImageViewHeight:imageUrls imageWidth:(kScreenWidth - dynamicImageViewDistance * 4) / 3];
}

///<根据数据获取高度，该界面已经包含上下间距
+ (CGFloat)getImageViewHeight:(NSArray *)imageUrls imageWidth:(CGFloat)width{
    CGFloat height = (imageUrls.count + 2) / (int)dynamicImageViewOneLineCount * (width + dynamicImageViewDistance) + 2 * dynamicImageViewDistance;
    return height;
}

- (void)prepareForReuse{
    __weak typeof(self) weak_self = self;
    [_imageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weak_self) strong_self = weak_self;
        [strong_self.dynamicImageViewManager saveUseOne:obj];
        [obj removeFromSuperview];
    }];
}

@end



#pragma mark - 图片管理类
@implementation HDDynamicImageViewManager{
    NSMutableArray  *useImageViews;
}

+ (instancetype)quickInstance{
    HDDynamicImageViewManager *manager = [[HDDynamicImageViewManager alloc] init];
    return manager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        useImageViews = [NSMutableArray array];
    }
    return self;
}

- (UIImageView *)getUseOne{
    if (useImageViews.count > 0) {
        UIImageView *imageView = [useImageViews firstObject];
        [useImageViews removeObjectAtIndex:0];
        return imageView;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    return imageView;
}

- (void)saveUseOne:(UIImageView *)imageView{
    if (![useImageViews containsObject:imageView]) {
        [useImageViews addObject:imageView];
    }
}

@end

