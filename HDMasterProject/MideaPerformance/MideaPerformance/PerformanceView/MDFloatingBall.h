//
//  MDFloatingBall.h
//  MDFloatingBall
//
//  Created by Mistletoe on 2017/4/22.
//  Copyright © 2017年 Mistletoe. All rights reserved.
//  悬浮球

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**< 靠边策略(默认所有边框均可停靠) */
typedef NS_ENUM(NSUInteger, MDFloatingBallEdgePolicy) {
    MDFloatingBallEdgePolicyAllEdge = 0,    /**< 所有边框都可
                                             (符合正常使用习惯，滑到某一位置时候才上下停靠，参见系统的 assistiveTouch) */
    MDFloatingBallEdgePolicyLeftRight,      /**< 只能左右停靠 */
    MDFloatingBallEdgePolicyUpDown,         /**< 只能上下停靠 */
};

typedef NS_ENUM(NSUInteger, MDFloatingBallContentType) {
    MDFloatingBallContentTypeImage = 0,    // 图片
    MDFloatingBallContentTypeText,         // 文字
    MDFloatingBallContentTypeCustomView    // 自定义视图(添加到上方的自定义视图默认 userInteractionEnabled = NO)
};

typedef struct MISEdgeRetractConfig {
    CGPoint edgeRetractOffset; /**< 缩进结果偏移量 */
    CGFloat edgeRetractAlpha;  /**< 缩进后的透明度 */
} MISEdgeRetractConfig;

UIKIT_STATIC_INLINE MISEdgeRetractConfig MISEdgeOffsetConfigMake(CGPoint edgeRetractOffset, CGFloat edgeRetractAlpha) {
    MISEdgeRetractConfig config = {edgeRetractOffset, edgeRetractAlpha};
    return config;
}

@class MDFloatingBall;
@protocol MDFloatingBallDelegate;

typedef void(^MDFloatingBallClickHandler)(MDFloatingBall *floatingBall);

@interface MDFloatingBall : UIView

/**
 靠边策略
 */
@property (nonatomic, assign) MDFloatingBallEdgePolicy edgePolicy;

/**
 初始化只会在当前指定的 view 范围内生效的悬浮球
 当 view 为 nil 的时候，和直接使用 initWithFrame 初始化效果一直，默认为全局生效的悬浮球

 @param frame 尺寸
 @param specifiedView 将要显示所在的view
 @return 悬浮球
 */
- (instancetype)initWithFrame:(CGRect)frame inSpecifiedView:(nullable UIView *)specifiedView __deprecated_msg("Method deprecated. Use `initWithFrame:inSpecifiedView:effectiveEdgeInsets`");;

/**
 初始化只会在当前指定的 view 范围内生效的悬浮球
 当 view 为 nil 的时候，和直接使用 initWithFrame 初始化效果一直，默认为全局生效的悬浮球

 @param frame 尺寸
 @param specifiedView 将要显示所在的view
 @param effectiveEdgeInsets 限制显示的范围，UIEdgeInsetsMake(50, 50, -50, -50)
                            则表示显示范围周围上下左右各缩小了 50 范围
 @return 生成的悬浮球实例
 */
- (instancetype)initWithFrame:(CGRect)frame
              inSpecifiedView:(nullable UIView *)specifiedView
          effectiveEdgeInsets:(UIEdgeInsets)effectiveEdgeInsets;

/**
 悬浮球代理
 */
@property (nonatomic, weak) id<MDFloatingBallDelegate> delegate;

/**
 显示
 */
- (void)show;

/**
 隐藏
 */
- (void)hide;

/**
 是否自动靠边
 */
@property (nonatomic, assign, getter=isAutoCloseEdge) BOOL autoCloseEdge;

/**
 当悬浮球靠近边缘的时候，自动像边缘缩进一段间距 (只有 autoCloseEdge 为YES时候才会生效)

 @param duration 缩进间隔
 @param edgeRetractConfigHander 缩进后参数的配置(如果为 NULL，则使用默认的配置)
 */
- (void)autoEdgeRetractDuration:(NSTimeInterval)duration edgeRetractConfigHander:(nullable MISEdgeRetractConfig(^)(void))edgeRetractConfigHander;

/**
 设置ball内部的内容

 @param content 内容
 @param contentType 内容类型（存在三种文字，图片，和自定义传入视图）
 */
- (void)setContent:(id)content contentType:(MDFloatingBallContentType)contentType;

/**
 点击 floatingBall 的 block 回调
 */
@property (nonatomic,   copy) MDFloatingBallClickHandler clickHandler;

// 文字颜色
@property (nonatomic, strong) UIColor *textTypeTextColor;
@end

@protocol MDFloatingBallDelegate <NSObject>
@optional
- (void)didClickFloatingBall:(MDFloatingBall *)floatingBall;
@end

@interface MDFloatingBall (Unavailable)
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end
NS_ASSUME_NONNULL_END
