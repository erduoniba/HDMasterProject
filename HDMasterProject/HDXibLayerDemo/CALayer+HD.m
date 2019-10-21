//
//  CALayer+HD.m
//  HDNetDate
//
//  Created by 邓立兵 on 2019/10/21.
//  Copyright © 2019 Harry. All rights reserved.
//

#import "CALayer+HD.h"

@implementation CALayer (HD)

-(void)setBorderUIColor:(UIColor*)color {
    self.borderColor = color.CGColor;
}

-(UIColor*)borderUIColor {
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
