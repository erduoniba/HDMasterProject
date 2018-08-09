//
//  HDAddressBookDemo.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2018/6/26.
//  Copyright © 2018年 HarryDeng. All rights reserved.
//

#import "HDAddressBookDemo.h"

#import <AddressBook/AddressBook.h>

@interface HDAddressBookDemo ()
@property (nonatomic, assign) ABAddressBookRef addressBook;
@end

@implementation HDAddressBookDemo

- (void)viewDidLoad {
    [super viewDidLoad];

    // 判断权限
    switch (ABAddressBookGetAuthorizationStatus()) {
        case kABAuthorizationStatusNotDetermined:   //!< 未选择权限.
        {

        }
            break;
        case kABAuthorizationStatusRestricted:      //!< 权限被限制.
        {

        }
            break;
        case kABAuthorizationStatusDenied:          //!< 已拒绝权限.
        {

        }
            break;
        case kABAuthorizationStatusAuthorized:      //!< 已授权.
        {

        }
            break;

        default:
            break;
    }

    [self requestAddressBookAccessWithCompletion:^(int code, NSString *msg) {
        if (code == 1) {
            [self getAddressBookPersonListWithSort];
        }
    }];
}

/**
 请求通讯录访问权限

 @param completion 权限回调
 */
- (void)requestAddressBookAccessWithCompletion:(void (^)(int code, NSString *msg))completion
{
    // 请求访问用户通讯录,注意无论成功与否block都会调用
    ABAddressBookRequestAccessWithCompletion(_addressBook, ^(bool granted, CFErrorRef error) {
        // 回调到主线程返回结果
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                if (completion) completion(1, @"请求通讯录访问权限成功");
            } else {
                if (completion) completion(-1, @"请求通讯录访问权限失败");
            }
        });
    });
}

/**
 *  同步获取通讯录联系人列表
 *
 *  @return 通讯录ZMPersonModel数组
 */
- (NSArray *)getAddressBookPersonListWithSort
{
    // 检测权限
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
        return nil;
    }

    // 按照排序读取所有联系人
    CFArrayRef allPerson = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(_addressBook, kABSourceTypeLocal, kABPersonSortByFirstName);

    // 存储通讯录的数组
    NSMutableArray  *addressBookArray = [NSMutableArray array];

    // 循环遍历，获取每个联系人信息
    for (NSInteger i = 0; i < CFArrayGetCount(allPerson); i++)  {
        ABRecordRef person = CFArrayGetValueAtIndex(allPerson, i);
        [addressBookArray addObject:(__bridge id _Nonnull)(person)];
    }

    // 释放资源
    if (allPerson) CFRelease(allPerson);

    return addressBookArray;
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
