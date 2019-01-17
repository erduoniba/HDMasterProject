//
//  HDDSwitch.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2018/12/24.
//  Copyright © 2018 HarryDeng. All rights reserved.
//

#import "HDDSwitch.h"

@implementation HDDSwitch

- (void)setImage {
    for (UIView *view in self.subviews) {
        for (UIView *sview in view.subviews) {
            if ([sview isMemberOfClass:UIImageView.class]) {
                UIImageView *imageView = (UIImageView *)sview;
                imageView.image = [UIImage imageNamed:@"smart_ic_switch_l"];
            }
        }
    }
}

@end
