//
//  HDPasswordView.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2019/3/11.
//  Copyright © 2019 HarryDeng. All rights reserved.
//

#import "HDPasswordView.h"

#import "HDPasswordItem.h"

#define ITEMTAG 122

@interface HDPasswordView()
@property(nonatomic , strong) NSMutableArray *btnArray;
@property(nonatomic , strong) NSMutableArray *itemArray;
@property(nonatomic , assign) CGPoint movePoint;
@property(nonatomic , assign) CGPoint lastPoint;
@property (nonatomic, assign) BOOL passwordCorrect;
@end

@implementation HDPasswordView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.normalColor = [UIColor colorWithRed:199/255.0 green:199/255.0 blue:204/255.0 alpha:1]; //正常颜色  灰色
        self.selectColor = [UIColor colorWithRed:38/255.0 green:122/255.0 blue:255/255.0 alpha:1];  //选中颜色  蓝色
        self.wrongColor = [UIColor colorWithRed:255/255.0 green:149/255.0 blue:0/255.0 alpha:1];  //选中颜色  橙色
        
        self.backgroundColor = [UIColor whiteColor];
        
        /****** 9个大点的布局 *****/
        [self createPoint_nine];
        
        /******* 小按钮上三角的point ******/
        _lastPoint = CGPointMake(0, 0);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (int i=0; i<9; i++) {
        int row    = i / 3;
        int column = i % 3;
        
        CGFloat spaceFloat = (self.frame.size.width-3*ITEMWH)/4;             //每个item的间距是等宽的
        CGFloat pointX     = spaceFloat*(column+1)+ITEMWH*column;   //起点X
        CGFloat pointY     = ITEM_TOTAL_POSITION + ITEMWH*row + spaceFloat*row;     //起点Y
        HDPasswordItem *item = self.itemArray[i];
        item.frame = CGRectMake( pointX  , pointY , ITEMWH, ITEMWH);
    }
}

- (void)createPoint_nine {
    for (int i=0; i<9; i++) {
        int row    = i / 3;
        int column = i % 3;
        
        CGFloat spaceFloat = (self.frame.size.width-3*ITEMWH)/4;             //每个item的间距是等宽的
        CGFloat pointX     = spaceFloat*(column+1)+ITEMWH*column;   //起点X
        CGFloat pointY     = ITEM_TOTAL_POSITION + ITEMWH*row + spaceFloat*row;     //起点Y
        
        HDPasswordItem *item = [[HDPasswordItem alloc] initWithFrame:CGRectMake( pointX  , pointY , ITEMWH, ITEMWH)];
        item.userInteractionEnabled = YES;
        item.backgroundColor = [UIColor clearColor];
        item.isSelect = NO;
        item.selectStyle = HDselectStyleNormal;
        item.tag = ITEMTAG + i ;
        [self addSubview:item];
        [self.itemArray addObject:item];
    }
}


#pragma mark - 延迟实例化
- (NSMutableArray *)btnArray {
    if (_btnArray==nil) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

- (NSMutableArray *)itemArray {
    if (_itemArray==nil) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}


#pragma mark - Touch Event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [self.btnArray removeAllObjects];
    [self resetAliPayItems];
    _passwordCorrect = YES;
    
    CGPoint point = [self touchLocation:touches];
    [self isContainItem:point];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    
    CGPoint point = [self touchLocation:touches];
    
    [self isContainItem:point];
    
    [self touchMove_triangleAction];
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    [self touchEndAction];
    
    [self setNeedsDisplay];
}

#pragma mark - 私有方法
- (void)resetAliPayItems {
    // 选中样式
    for (HDPasswordItem *item  in self.subviews) {
        if ([item isKindOfClass:[HDPasswordItem class]]) {
            item.isSelect = NO;
            item.selectStyle = HDselectStyleNormal;
            [item judegeDirectionActionx1:0 y1:0 x2:0 y2:0 isHidden:YES];
        }
    }
}

- (CGPoint)touchLocation:(NSSet *)touches {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    _movePoint = point;
    return point;
}

- (void)isContainItem:(CGPoint)point {
    for (HDPasswordItem *item  in self.subviews) {
        if ([item isKindOfClass:[HDPasswordItem class]]) {
            BOOL isContain = CGRectContainsPoint(item.frame, point);
            if (isContain && item.isSelect==NO) {
                [self.btnArray addObject:item];
                item.isSelect = YES;
                item.selectStyle = HDselectStyleSelect;
            }
        }
    }
}

- (void)touchMove_triangleAction {
    NSString *resultStr = [self getResultPwd];
    if (resultStr && resultStr.length>0){
        NSArray *resultArr = [resultStr componentsSeparatedByString:@"A"];
        if ([resultArr isKindOfClass:[NSArray class]]  &&  resultArr.count>2 ) {
            NSString *lastTag    = resultArr[resultArr.count-1];
            NSString *lastTwoTag = resultArr[resultArr.count-2];
            
            CGPoint lastP ;
            CGPoint lastTwoP;
            HDPasswordItem *lastItem;
            
            for (HDPasswordItem *item  in self.btnArray) {
                if (item.tag-ITEMTAG == lastTag.intValue) {
                    lastP = item.center;
                }
                
                if (item.tag-ITEMTAG == lastTwoTag.intValue) {
                    lastTwoP = item.center;
                    lastItem = item;
                }
                
                CGFloat x1 = lastTwoP.x;
                CGFloat y1 = lastTwoP.y;
                CGFloat x2 = lastP.x;
                CGFloat y2 = lastP.y;
                
                [lastItem judegeDirectionActionx1:x1 y1:y1 x2:x2 y2:y2 isHidden:YES];
            }
        }
    }
}

- (NSString *)getResultPwd {
    NSMutableString *resultStr = [NSMutableString string];
    for (HDPasswordItem *item  in self.btnArray) {
        if ([item isKindOfClass:[HDPasswordItem class]]) {
            [resultStr appendString:@"A"];
            [resultStr appendString:[NSString stringWithFormat:@"%ld", (long)item.tag-ITEMTAG]];
        }
    }
    return (NSString *)resultStr;
}

- (void)touchEndAction {
    for (HDPasswordItem *itemssss in self.btnArray) {
        [itemssss judegeDirectionActionx1:0 y1:0 x2:0 y2:0 isHidden:YES];
    }
    
    // if (判断格式少于1个点) [处理密码数据]
    if ([self judgeFormat]) {
        [self blockAction:[self getResultPwd]];
    }
}

- (BOOL)judgeFormat {
    if (self.btnArray.count<1) {
        //不合法
        return NO;
    }
    
    return YES;
}

- (void)blockAction:(NSString *)resultStr {
    if (self.passwordBlock) {
        self.passwordBlock([resultStr stringByReplacingOccurrencesOfString:@"A" withString:@"__"]);
    }
    
    _passwordCorrect = NO;
    _movePoint.x = 0;
    _movePoint.y = 0;
    
    for (HDPasswordItem *item  in self.btnArray) {
        item.isSelect = YES;
        item.selectStyle = HDselectStyleWrong;
    }
    
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for (int i=0; i<self.btnArray.count; i++) {
        HDPasswordView *item = (HDPasswordView *)self.btnArray[i];
        if (i==0) {
            [path moveToPoint:item.center];
        }
        else {
            [path addLineToPoint:item.center];
        }
    }
    
    if (_movePoint.x!=0 && _movePoint.y!=0 && NSStringFromCGPoint(_movePoint)) {
        [path addLineToPoint:_movePoint];
    }
    [path setLineCapStyle:kCGLineCapRound];
    [path setLineJoinStyle:kCGLineJoinRound];
    [path setLineWidth:4.0f];
    if (_passwordCorrect) {
        [self.selectColor setStroke];
    }
    else {
        [self.wrongColor setStroke];
    }
    [path stroke];
}

@end
