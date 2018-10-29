//
//  GYSwitch.h
//  BHSmartHome
//
//  Created by hh on 2018/7/30.
//

#import <UIKit/UIKit.h>

typedef void(^eventBlock)(BOOL isRight);

@interface GYSwitch : UIView
@property (nonatomic, copy) eventBlock eventBlock;

- (void)turnRoundImageViewToRight;

- (void)turnRoundImageViewToLeft;
@end
