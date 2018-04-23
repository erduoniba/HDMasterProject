//
//  MideaAlertController.h
//  midea
//
//  Created by MaYifang on 16/9/25.
//  Copyright © 2016年 Midea. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MideaAlertController;

typedef void (^MideaAlertBlock)(MideaAlertController *alert);

@interface MideaAlertController : UIAlertController

+ (instancetype)alertWithAlertTitle:(NSString *)title
                            message:(NSString *)msg
                          cancelBtn:(NSString *)cancelName
                           okButton:(NSString *)okButtonName
                      cancelHandler:(MideaAlertBlock)cancelHandler
                          okHandler:(MideaAlertBlock)okHandler;

+ (instancetype)alertWithAlertTitle:(NSString *)title
                            message:(NSString *)msg
                          cancelBtn:(NSString *)cancelName
                      cancelHandler:(void (^)(MideaAlertController *alert))cancelHandler;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, copy) MideaAlertBlock cancelBlock;
@property (nonatomic, copy) MideaAlertBlock okBlock;

- (void)show;
- (void)show:(BOOL)animated;
- (void)disMiss;
- (void)disMiss:(BOOL)animated;

@end

