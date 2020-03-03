//
//  PGPageLimitSetting.h
//  pgLibrariesModule
//
//  Created by 邓立兵 on 2020/3/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGPageLimitSetting : NSObject

+ (instancetype)shareInstance;

/*
 {
   "pd": "1",       // 0：关闭商详层级限制功能 1:开启 (默认关闭)
   "pdNum": "3",    // 非0情况下，商详层级数量限制，<=0 使用默认值 3
   "all": "1",      // 0：关闭层级限制功能 1:开启 (默认关闭)
   "allNum": “11”   // 非0情况下，层级数量限制，<=0 使用默认值 10
 }
 */
@property (nonatomic, strong) NSString *pd;
@property (nonatomic, strong) NSString *pdNum;
@property (nonatomic, strong) NSString *all;
@property (nonatomic, strong) NSString *allNum;

@property (nonatomic, assign) NSInteger currentPdNum;
@property (nonatomic, assign) NSInteger currentAllNum;

- (void)pageNumLimit:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
