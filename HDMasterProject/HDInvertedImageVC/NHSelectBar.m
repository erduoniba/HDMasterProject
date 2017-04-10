//
//  NHHouseQACommentCell.m
//  NewHouseSDK
//
//  Created by Harry on 16/5/3.
//  Copyright © 2016年 haifeng. All rights reserved.
//

#import "NHSelectBar.h"

#define UIColorWithHex(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
green:((float)((hexValue & 0xFF00) >> 8))/255.0 \
blue:((float)(hexValue & 0xFF))/255.0 alpha:1]

@implementation NHSelectBar {
    NSMutableArray  *bts;
    UIView          *line;
}

+ (CGFloat)getCellHeight:(id)data{
    return 36;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        bts = [NSMutableArray array];
        UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, [NHSelectBar getCellHeight:nil] - 0.5, kScreenWidth, 0.5)];
        bottom.backgroundColor = UIColorWithHex(0xEEEEEE);
        [self addSubview:bottom];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setData:(NSArray *)tags{
    [self setData:tags delegate:nil];
}

- (void)setData:(NSArray *)tags delegate:(id)delegate{
    
    if (!_delegate) {
        [tags enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
            bt.frame = CGRectMake(kScreenWidth / tags.count * idx, 5, kScreenWidth / tags.count, [NHSelectBar getCellHeight:nil] - 10);

            [bt addTarget:self action:@selector(houseTagAction:) forControlEvents:UIControlEventTouchUpInside];
            bt.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [bt setTitle:obj forState:UIControlStateNormal];
            [self addSubview:bt];
            [bts addObject:bt];
            
            if (idx == 0) {
                [bt setTitleColor:UIColorWithHex(0xFF611B) forState:UIControlStateNormal];
                
                line = [[UIView alloc] initWithFrame:CGRectMake(0, [NHSelectBar getCellHeight:nil] - 1.5, 32, 1.5)];
                line.center = CGPointMake(bt.center.x, line.center.y);
                line.backgroundColor = UIColorWithHex(0xFF611B);
                [self addSubview:line];
            }
            else{
                [bt setTitleColor:UIColorWithHex(0x333333) forState:UIControlStateNormal];
            }
        }];
    }
    
    _delegate = delegate;
}

- (void)selectAtIndex:(NSInteger)index {
    UIButton *bt = bts[index];
    [self houseTagAction:bt];
}


- (void)houseTagAction:(UIButton *)bt{
    [bts enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setTitleColor:UIColorWithHex(0x333333) forState:UIControlStateNormal];
    }];
    
    [bt setTitleColor:UIColorWithHex(0xFF611B) forState:UIControlStateNormal];

    line.frame = CGRectMake(bt.frame.origin.x, line.frame.origin.y, line.frame.size.width, line.frame.size.height);
    line.center = CGPointMake(bt.center.x, line.center.y);
    
    if (_delegate && [_delegate respondsToSelector:@selector(NHSelectBar:selectAtIndex:)]) {
        [_delegate NHSelectBar:self selectAtIndex:[bts indexOfObject:bt]];
    }
}

@end
