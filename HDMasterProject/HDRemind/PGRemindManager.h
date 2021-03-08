//
//  PGRemindManager.h
//  pgBusinessFoundationModule
//
//  Created by 邓立兵 on 2021/3/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGRemindManager : NSObject

/// 1、查询日历权限
+ (BOOL)queryRemindPermission;

/// 2、如果没有日历权限，请求开启权限
+ (void)requestRemindPermission;

/// 3、添加日历事件
/// @param title “618购物狂欢节” 字符串类型
/// @param time 1493479968081 long类型(毫秒)
/// @param forwardAlarmTime 事件提醒闹钟需要提前多少秒，默认是180s
/// @param url 落地页地址
+ (NSString *)addRemindTitle:(NSString *)title
                        time:(NSTimeInterval)time
            forwardAlarmTime:(NSTimeInterval)forwardAlarmTime
                         url:(NSString *)url;


/// 4、获取当前设备下所有的日历提醒事件的Id集合（一年前到一年后的这个时间段）
+ (NSArray <NSString *> *)queryAllReminds;

/// 5、获取当前设备下所有的日历提醒事件的Id集合
/// @param startTime 开始时间戳  long类型(毫秒)
/// @param endTime  结束时间戳  long类型(毫秒)
+ (NSArray <NSString *> *)queryAllReminds:(NSTimeInterval)startTime endTime:(NSTimeInterval)endTime;

/// 6、根据日历提醒id来判断该事件是否存在
/// @param rId 日历提醒id
+ (BOOL)queryRemind:(NSString *)rId;

/// 7、根据日历提醒id进行删除
/// @param rId 日历提醒id
+ (BOOL)removeRemind:(NSString *)rId;

@end

NS_ASSUME_NONNULL_END
