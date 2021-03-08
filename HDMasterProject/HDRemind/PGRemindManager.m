//
//  PGRemindManager.m
//  pgBusinessFoundationModule
//
//  Created by 邓立兵 on 2021/3/8.
//

#import "PGRemindManager.h"

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface PGRemindManager ()

@property (nonatomic, strong) EKEventStore *eventStore;

@end

@implementation PGRemindManager

+ (instancetype)sharedInstance {
    static PGRemindManager *obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[PGRemindManager alloc] init];
    });
    return obj;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _eventStore = [[EKEventStore alloc] init];
    }
    return self;
}

+ (BOOL)queryRemindPermission {
    return [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent] == EKAuthorizationStatusAuthorized;
}

+ (void)requestRemindPermission:(void(^)(void))block {
    //获取授权状态
    EKAuthorizationStatus eventStatus = [EKEventStore  authorizationStatusForEntityType:EKEntityTypeEvent];
    //用户还没授权过
    if(eventStatus ==EKAuthorizationStatusNotDetermined) {
        //提示用户授权，调出授权弹窗
        [[[EKEventStore alloc] init] requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block();
                });
            }
        }];
    }
}

+ (void)goToAppSystemSetting {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([application canOpenURL:url]) {
        if (@available(iOS 10.0, *)) {
            [application openURL:url options:@{} completionHandler:nil];
        } else {
            [application openURL:url];
        }
    }
}

+ (void)requestRemindPermission {
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    if(status == EKAuthorizationStatusNotDetermined) {
        [self requestRemindPermission:^{
            
        }];
        return;
    }
    else if (status != EKAuthorizationStatusAuthorized) {
        [self goToAppSystemSetting];
    }
}

+ (NSString *)addRemindTitle:(NSString *)title
                        time:(NSTimeInterval)time
            forwardAlarmTime:(NSTimeInterval)forwardAlarmTime
                         url:(NSString *)url; {
    // 时间戳有误（毫秒）
    if (time < 1000000000000) {
        return nil;
    }
    if (forwardAlarmTime <= 0) {
        forwardAlarmTime = 180;
    }
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:time/1000.0];
    // 日历设置为5分钟
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:(time/1000.0+300)];
    
    EKEvent *event = [EKEvent eventWithEventStore:PGRemindManager.sharedInstance.eventStore];
    event.title = title;
    event.URL = [NSURL URLWithString:url];
    event.startDate = startDate;
    event.endDate = endDate;
    event.calendar = [PGRemindManager.sharedInstance.eventStore defaultCalendarForNewEvents];
    EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:-forwardAlarmTime];
    [event addAlarm:alarm];
    
    NSError *err;
    [PGRemindManager.sharedInstance.eventStore saveEvent:event span:EKSpanThisEvent error:&err];
    if (err) {
        return nil;
    }
    return event.eventIdentifier;
}

+ (NSArray <NSString *> *)queryAllReminds {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:-1];
    NSDate *lastYearDate = [gregorian dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
    
    dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:1];
    NSDate *nextYearDate = [gregorian dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];

    return [self queryAllReminds:lastYearDate endDate:nextYearDate];
}

+ (NSArray <NSString *> *)queryAllReminds:(NSTimeInterval)startTime endTime:(NSTimeInterval)endTime {
    // 时间戳有误（毫秒）
    if (startTime < 1000000000000 || endTime < 1000000000000 || startTime > endTime) {
        return nil;
    }
    NSDate *lastYearDate = [NSDate dateWithTimeIntervalSince1970:startTime/1000.0];
    NSDate *nextYearDate = [NSDate dateWithTimeIntervalSince1970:endTime/1000.0];
    
    return [self queryAllReminds:lastYearDate endDate:nextYearDate];
}

+ (NSArray <NSString *> *)queryAllReminds:(NSDate *)startDate endDate:(NSDate *)endDate {
    NSPredicate *predicate = [PGRemindManager.sharedInstance.eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:nil];
    NSArray *events = [PGRemindManager.sharedInstance.eventStore eventsMatchingPredicate:predicate];
    NSMutableArray *rids = [NSMutableArray arrayWithCapacity:events.count];
    for (EKEvent *event in events) {
        [rids addObject:event.eventIdentifier];
    }
    return rids;
}


+ (BOOL)queryRemind:(NSString *)rId {
    EKEvent *event = [PGRemindManager.sharedInstance.eventStore eventWithIdentifier:rId];
    if (event) {
        return YES;
    }
    return NO;
}

+ (BOOL)removeRemind:(NSString *)rId {
    EKEvent *event = [PGRemindManager.sharedInstance.eventStore eventWithIdentifier:rId];
    return [PGRemindManager.sharedInstance.eventStore removeEvent:event span:EKSpanThisEvent error:nil];
}

@end
