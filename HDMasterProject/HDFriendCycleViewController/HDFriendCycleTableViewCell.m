//
//  HDFriendCycleTableViewCell.m
//  HDMasterProject
//
//  Created by Harry on 16/6/2.
//  Copyright © 2016年 HarryDeng. All rights reserved.
//

#import "HDFriendCycleTableViewCell.h"
#import "HDFriendCycleModel.h"
#import "UIView+Helpers.h"

#define UIColorWithHex(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
green:((float)((hexValue & 0xFF00) >> 8))/255.0 \
blue:((float)(hexValue & 0xFF))/255.0 alpha:1]


@implementation HDFriendCycleTableViewCell{
    UILabel         *titleLb;
    UILabel         *timeLb;
    UIButton        *shareBt;
    
    HDFriendCycleModel *model;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        titleLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, kScreenWidth - 20, 17)];
        titleLb.textColor = UIColorWithHex(0x333333);
        titleLb.font = [UIFont systemFontOfSize:15];
        titleLb.numberOfLines = 0;
        [self.contentView addSubview:titleLb];
        
        timeLb = [[UILabel alloc] initWithFrame:CGRectMake(10, titleLb.frame.origin.y + titleLb.frame.size.height + 6, 100, 13)];
        timeLb.textColor = UIColorWithHex(0x999999);
        timeLb.font = [UIFont systemFontOfSize:12];
        timeLb.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:timeLb];
        
        _contentLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, kScreenWidth - 20, 34)];
        _contentLb.textColor = UIColorWithHex(0x666666);
        _contentLb.font = [UIFont systemFontOfSize:14];
        _contentLb.numberOfLines = 0;
        [self.contentView addSubview:_contentLb];
        
        [self.contentView addSubview:self.dynamicImageView];
        
        shareBt = [UIButton buttonWithType:UIButtonTypeCustom];
        shareBt.frame = CGRectMake(kScreenWidth - 63, 0, 60, 30);
        shareBt.titleLabel.font = [UIFont systemFontOfSize:12];
        [shareBt setTitleColor:UIColorWithHex(0xFF9934) forState:UIControlStateNormal];
        [shareBt setImage:[UIImage imageNamed:@"ng_house_share"] forState:UIControlStateNormal];
        [shareBt setTitle:@"  分享" forState:UIControlStateNormal];
        [shareBt addTarget:self action:@selector(shareDynamic) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:shareBt];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    titleLb.frameSizeWidth = kScreenWidth - 20;
    
    CGSize size = [self.class fdd_sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreenWidth - 20, 999) withString:model.content];
    _contentLb.frameSizeWidth = kScreenWidth - 20;
    _contentLb.frameSizeHeight = size.height;
    
    _dynamicImageView.frameOriginY = _contentLb.frameMaxY;
    
    shareBt.frameOriginX = kScreenWidth - 63;
    CGFloat maxHeight = [[self class] getCellHeight:model];
    shareBt.frameOriginY = maxHeight - 35;
    timeLb.frameOriginY = shareBt.frame.origin.y + 9;
}

- (HDDynamicImageView *)dynamicImageView{
    if (!_dynamicImageView) {
        _dynamicImageView = [[HDDynamicImageView alloc] initWithFrame:CGRectZero];
    }
    return _dynamicImageView;
}

- (void)setData:(HDFriendCycleModel *)data delegate:(id)delegate{
    
    model = data;
    
    titleLb.text = model.title;
    _contentLb.text = model.content;
    timeLb.text = model.time;
    _delegate = delegate;
    
    CGSize size = [self.class fdd_sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(kScreenWidth - 20, 999) withString:model.title];
    titleLb.frameSizeHeight = size.height;
    
    size = [self.class fdd_sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreenWidth - 20, 999) withString:model.content];
    _contentLb.frameOriginY = titleLb.frameMaxY + 8;
    _contentLb.frameSizeHeight = size.height;
    
    if (model.picUrl.count > 0) {
        
        _dynamicImageView.hidden = NO;
        
        _dynamicImageView.dynamicImageViewManager = _dynamicImageViewManager;
        CGFloat imageViewHeight = [HDDynamicImageView getImageViewHeight:model.picUrl];
        _dynamicImageView.frame = CGRectMake(0, _contentLb.frame.origin.y + _contentLb.frame.size.height, kScreenWidth, imageViewHeight);
        __weak typeof(self) weak_self = self;
        _dynamicImageView.tapIndex = ^(UIImageView *imageView, NSInteger index){
            __strong typeof(weak_self) strong_self = weak_self;
            if (strong_self.delegate && [strong_self.delegate respondsToSelector:@selector(friendCycleTableViewCell:tapImageView:atIndex:)]) {
                [strong_self.delegate friendCycleTableViewCell:strong_self tapImageView:imageView atIndex:index];
            }
        };
        
        _dynamicImageView.imageUrls = model.picUrl;
    }
    else{
        _dynamicImageView.imageUrls = [NSArray array];
        _dynamicImageView.hidden = YES;
    }
    
    CGFloat maxHeight = [[self class] getCellHeight:model];
    shareBt.frameOriginY = maxHeight - 35;
    timeLb.frameOriginY = shareBt.frame.origin.y + 9;
}

- (void)shareDynamic{
    if (_delegate && [_delegate respondsToSelector:@selector(friendCycleTableViewCell:shareDynamic:)]) {
        [_delegate friendCycleTableViewCell:self shareDynamic:nil];
    }
}

- (void)prepareForReuse{
    [super prepareForReuse];
    
    [self.dynamicImageView prepareForReuse];
}

+ (CGFloat)getCellHeight:(HDFriendCycleModel *)data{
    CGSize size1 = [self fdd_sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(kScreenWidth - 20, 999) withString:data.title];
    CGSize size2 = [self fdd_sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreenWidth - 20, 999) withString:data.content];
    CGFloat imageViewHeight = [HDDynamicImageView getImageViewHeight:data.picUrl];
    return 13 + size1.height + size2.height + imageViewHeight + 30; //13:titleLb上面距离 20时间高度 30:分享bt高度
}


+ (CGSize)fdd_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size withString:(NSString *)string
{
    CGSize resultSize;
    if ([string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMethodSignature *signature = [[string class] instanceMethodSignatureForSelector:@selector(boundingRectWithSize:options:attributes:context:)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:string];
        [invocation setSelector:@selector(boundingRectWithSize:options:attributes:context:)];
        NSDictionary *attributes = @{ NSFontAttributeName:font };
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
        NSStringDrawingContext *context;
        [invocation setArgument:&size atIndex:2];
        [invocation setArgument:&options atIndex:3];
        [invocation setArgument:&attributes atIndex:4];
        [invocation setArgument:&context atIndex:5];
        [invocation invoke];
        CGRect rect;
        [invocation getReturnValue:&rect];
        resultSize = rect.size;
    } else {
        NSMethodSignature *signature = [[string class] instanceMethodSignatureForSelector:@selector(sizeWithFont:constrainedToSize:)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:string];
        [invocation setSelector:@selector(sizeWithFont:constrainedToSize:)];
        [invocation setArgument:&font atIndex:2];
        [invocation setArgument:&size atIndex:3];
        [invocation invoke];
        [invocation getReturnValue:&resultSize];
    }
    
    return resultSize;
}

@end
