//
//  HDDynamicImageView.h
//  HDMasterProject
//
//  Created by Harry on 15/12/4.
//  Copyright © 2015年 HarryDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HDDynamicImageViewManager;

typedef void (^ tapImageAtIndex)(UIImageView *imageView, NSInteger index);

@interface HDDynamicImageView : UIView

@property (nonatomic, strong) HDDynamicImageViewManager *dynamicImageViewManager;

@property (nonatomic, strong) NSArray <NSString *>*imageUrls;
@property (nonatomic, strong) NSMutableArray <UIImageView *>*imageViews;

@property (nonatomic, copy)  tapImageAtIndex tapIndex;

///< 设置图片宽度
-  (void)setImageWidth:(CGFloat)width;

///< 重用imageView， 在cell 的 “prepareForReuse”里面调用
- (void)prepareForReuse;

///<根据数据获取高度，该界面已经包含上下间距
+ (CGFloat)getImageViewHeight:(NSArray *)imageUrls;

///<根据数据获取高度，该界面已经包含上下间距
+ (CGFloat)getImageViewHeight:(NSArray *)imageUrls imageWidth:(CGFloat)width;

@end




#pragma mark - 图片管理类
@interface HDDynamicImageViewManager : NSObject

+ (instancetype)quickInstance;
- (UIImageView *)getUseOne;
- (void)saveUseOne:(UIImageView *)imageView;

@end
