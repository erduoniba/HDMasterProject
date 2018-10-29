//
//  GYSwitch.m
//  BHSmartHome
//
//  Created by hh on 2018/7/30.
//

#import "GYSwitch.h"

#define RGBCOLOR(r,g,b)          [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

@interface GYSwitch()
@property (nonatomic, strong) UIView *sliderView;
@property (nonatomic, strong) UIImageView *roundImageView;
@property (nonatomic) BOOL isRightSide;
@end

@implementation GYSwitch

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.sliderView = UIView.new;
    self.sliderView.layer.cornerRadius = 1.5;
    self.sliderView.layer.masksToBounds = YES;
    [self addSubview:self.sliderView];
    self.sliderView.backgroundColor = RGBCOLOR(0xe5, 0xe5, 0xe8);
    
    self.roundImageView = [[UIImageView alloc] initWithImage:[self gradientBackgroundImage]];
    self.roundImageView.layer.shadowOffset = CGSizeMake(0, 2);
    self.roundImageView.layer.shadowColor = RGBCOLOR(0xd8, 0xd8, 0xd8).CGColor;
    self.roundImageView.layer.cornerRadius = 10;
    self.roundImageView.layer.masksToBounds = YES;
    [self addSubview:self.roundImageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)];
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeView:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeView:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:tap];
    [self addGestureRecognizer:rightSwipe];
    [self addGestureRecognizer:leftSwipe];
    self.userInteractionEnabled = YES;

    self.sliderView.frame = CGRectMake(0, (self.frame.size.height - 3) / 2, self.frame.size.width, 3);
    self.roundImageView.frame = CGRectMake(0, (self.frame.size.height - 20) / 2, 20, 20);
}

- (void)didTapView:(UITapGestureRecognizer *)tap {
    CGPoint tapPoint = [tap locationInView:self];
    if (CGRectContainsPoint(self.bounds, tapPoint)) {
        if(!self.isRightSide) {
            [self turnRoundImageViewToRight];
            if (self.eventBlock) {
                self.eventBlock(YES);
            }
        } else {
            [self turnRoundImageViewToLeft];
            if (self.eventBlock) {
                self.eventBlock(NO);
            }
        }
    }
}

- (void)didSwipeView:(UISwipeGestureRecognizer *)swipe {
    if(swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        [self turnRoundImageViewToRight];
        if (self.eventBlock) {
            self.eventBlock(YES);
        }
    } else if(swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self turnRoundImageViewToLeft];
        if (self.eventBlock) {
            self.eventBlock(NO);
        }
    }
}

- (void)turnRoundImageViewToRight {
    self.roundImageView.frame = CGRectMake(self.frame.size.width - 20, (self.frame.size.height - 20) / 2, 20, 20);
    self.sliderView.backgroundColor = RGBCOLOR(0x26, 0x7A, 0xFF);
    self.isRightSide = YES;
}

- (void)turnRoundImageViewToLeft {
    self.roundImageView.frame = CGRectMake(0, (self.frame.size.height - 20) / 2, 20, 20);
    self.sliderView.backgroundColor = RGBCOLOR(0xe5, 0xe5, 0xe8);
    self.isRightSide = NO;
}

- (UIImage *)gradientBackgroundImage {
    UIGraphicsBeginImageContext(CGSizeMake(20, 20));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat locations[2] = {0, 1};
    CGFloat components[8] = {
        0xff/255.0f, 0xff/255.0, 0xff/255.0, 1,
        0xf1/255.0, 0xf1/255.0, 0xf1/255.0, 1
    };
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(space, components, locations, 2);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, 20), kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGColorSpaceRelease(space);
    return image;
}

@end
