//
//  HDGCDTestVCViewController.m
//  HDMasterProject
//
//  Created by denglibing on 2017/5/18.
//  Copyright © 2017年 HarryDeng. All rights reserved.
//


#define HDLog(fmt, ...)  NSLog(@"[%s]" fmt, __func__, ##__VA_ARGS__)


#import "HDGCDTestVC.h"

@interface HDReadonlyObj : NSObject

@property (nonatomic, strong) NSString *sValue;
@property (nonatomic, strong, readonly) NSString *readonly;
@property (nonatomic, strong) NSMutableArray *mArr;
@property (nonatomic, strong) HDReadonlyObj *readonlyObj;

@end

@implementation HDReadonlyObj

@end



@interface HDGCDTestVC ()

@end

@implementation HDGCDTestVC

- (void)viewDidLoad {
    [super viewDidLoad];

    HDReadonlyObj *obj = [HDReadonlyObj new];
    obj.readonlyObj = [HDReadonlyObj new];
    obj.readonlyObj.sValue = @"sValue";
    NSLog(@"readonly0: %@", obj.readonly);
    [obj setValue:@"readonly" forKey:@"readonly"];
    NSLog(@"readonly1: %@", obj.readonly);
    obj.mArr = [NSMutableArray array];
    [obj.mArr addObject:@(1)];
    [obj.mArr addObject:@(2)];
    NSLog(@"obj.mArr: %@", obj.mArr);

    //[self test1];
    //[self test2];
    //[self test3];
    //[self test4];
    //[self test41];
    //[self test5];
    //[self test6];
    //[self test8];
    //[self test9];
    //[self test10];
//    [self test11];
    [self test12];
}

- (void)test1 {
    HDLog(@"1"); // 任务1
    dispatch_sync(dispatch_get_main_queue(), ^{
        HDLog(@"2"); // 任务2
    });
    HDLog(@"3"); // 任务3
    // 1 卡住
}

- (void)test2 {
    HDLog(@"1"); // 任务1
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        HDLog(@"2"); // 任务2
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            HDLog(@"3"); // 任务3
        });
        HDLog(@"4"); // 任务4
    });
    HDLog(@"5"); // 任务5
    // 1 2 3 4 5
}

- (void)test3 {
    dispatch_queue_t queue = dispatch_queue_create("com.demo.serialQueue", DISPATCH_QUEUE_SERIAL);
    HDLog(@"1"); // 任务1
    dispatch_async(queue, ^{
        HDLog(@"2"); // 任务2
        HDLog(@"4"); // 任务4
    });
    HDLog(@"5"); // 任务5
    HDLog(@"6"); // 任务6
    // 1 5 6 2 4
}

- (void)test4 {
    dispatch_queue_t queue = dispatch_queue_create("com.demo.serialQueue", DISPATCH_QUEUE_SERIAL);
    HDLog(@"1"); // 任务1
    dispatch_async(queue, ^{
        HDLog(@"2"); // 任务2
        dispatch_sync(queue, ^{
            HDLog(@"3"); // 任务3
        });
        HDLog(@"4"); // 任务4
    });
    HDLog(@"5"); // 任务5
    // 1 5 2 卡住
}

- (void)test41 {
    dispatch_queue_t queue = dispatch_queue_create("com.demo.serialQueue", DISPATCH_QUEUE_CONCURRENT);
    HDLog(@"1"); // 任务1
    dispatch_async(queue, ^{
        HDLog(@"2"); // 任务2
        dispatch_sync(queue, ^{
            HDLog(@"3"); // 任务3
        });
        HDLog(@"4"); // 任务4
    });
    HDLog(@"5"); // 任务5
    // 1 5 2 3 4
}

- (void)test5 {
    HDLog(@"1"); // 任务1
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        HDLog(@"2"); // 任务2
        dispatch_sync(dispatch_get_main_queue(), ^{
            HDLog(@"3"); // 任务3
        });
        HDLog(@"4"); // 任务4
    });
    HDLog(@"5"); // 任务5
    // 1 5 2 3 4
}

- (void)test6 {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        HDLog(@"1"); // 任务1
        dispatch_sync(dispatch_get_main_queue(), ^{
            HDLog(@"2"); // 任务2
        });
        HDLog(@"3"); // 任务3
    });
    HDLog(@"4"); // 任务4
    while (1) {
        
    }
    // 4 1 卡住
}

- (void)test7 {
    dispatch_queue_t queueC = dispatch_queue_create("com.demo.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queueC, ^{
        sleep(3);
        HDLog(@"1");
    });
    dispatch_async(queueC, ^{
        sleep(2);
        HDLog(@"2");
    });

    dispatch_barrier_sync(queueC, ^{
        HDLog(@"3");
    });

    dispatch_async(queueC, ^{
        sleep(1);
        HDLog(@"4");
    });
    // 1 2 3 4
}

- (void)test8 {
    dispatch_queue_t queueC = dispatch_queue_create("com.demo.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queueC, ^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(3);
            HDLog(@"1");
        });
    });

    dispatch_async(queueC, ^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(2);
            HDLog(@"2");
        });
    });

    dispatch_barrier_sync(queueC, ^{
        HDLog(@"3");
    });

    dispatch_async(queueC, ^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(1);
            HDLog(@"4");
        });
    });
    //3 4 2 1
}

- (void)test9 {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_group_async(group, queue, ^{
        sleep(3);
        HDLog(@"1");
    }); //任务1
    dispatch_group_async(group, queue, ^{
        sleep(2);
        HDLog(@"2");
    }); //任务2
    dispatch_group_async(group, queue, ^{
        sleep(1);
        HDLog(@"3");
    }); //任务3
    dispatch_group_notify(group, dispatch_get_main_queue(),^{
        HDLog(@"done");
    });
    // 3 2 1 done
}

- (void)test10 {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_group_async(group, queue, ^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(3);
            HDLog(@"1"); //任务1
        });
    });
    dispatch_group_async(group, queue, ^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(2);
            HDLog(@"2"); //任务2
        });
    });
    dispatch_group_async(group, queue, ^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(1);
            HDLog(@"3"); //任务3
        });
    });
    dispatch_group_notify(group, dispatch_get_main_queue(),^{
        HDLog(@"done");
    });
    //done 3 2 1
}

- (void)test11 {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(3);
            HDLog(@"1"); //任务1
            dispatch_group_leave(group);
        });
    });
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(2);
            HDLog(@"2"); //任务2
            dispatch_group_leave(group);
        });
    });
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(1);
            HDLog(@"3"); //任务3
            dispatch_group_leave(group);
        });
    });
    dispatch_group_notify(group, dispatch_get_main_queue(),^{
        HDLog(@"done");
    });
    // 3 2 1 done
}

- (void)test12 {
    NSLog(@"1");
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        NSLog(@"2");
        dispatch_semaphore_signal(semaphore);
    });
    NSLog(@"3");

    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, 1.1 * NSEC_PER_SEC);
    dispatch_semaphore_wait(semaphore, timeout);
    NSLog(@"done");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
