//
//  HDIMListVC.m
//  HDMasterProject
//
//  Created by denglibing on 2017/3/29.
//  Copyright © 2017年 HarryDeng. All rights reserved.
//

#import "HDIMListVC.h"

#import <AVOSCloud/AVOSCloud.h>
#import <ChatKit/LCCKConversationListViewController.h>
#import <ChatKit/LCCKContactListViewController.h>

#import "LCCKUser.h"

@interface HDIMListVC ()

@property (nonatomic, strong) LCCKConversationListViewController *conversationListVC;
@property (nonatomic, strong) LCCKContactListViewController *contactListVC;

@end

@implementation HDIMListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];

    LCChatKit *chatKit = [LCChatKit sharedInstance];

    [chatKit removeAllCachedProfiles];

    [chatKit setFetchProfilesBlock:^(NSArray<NSString *> *userIds, LCCKFetchProfilesCompletionHandler completionHandler) {

        if (userIds.count == 0) {
            NSInteger code = 0;
            NSString *errorReasonText = @"User ids is nil";
            NSDictionary *errorInfo = @{
                                        @"code" : @(code),
                                        NSLocalizedDescriptionKey : errorReasonText,
                                        };
            NSError *error = [NSError errorWithDomain:@"LCChatKitExample"
                                                 code:code
                                             userInfo:errorInfo];
            !completionHandler ?: completionHandler(nil, error);
            return;
        }

        [[NSUserDefaults standardUserDefaults] setObject:userIds forKey:@"contactList"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        NSMutableArray<id<LCCKUserDelegate>> *userList = [NSMutableArray array];
        for (NSString *userId in userIds) {
            LCCKUser *object = [LCCKUser userWithClientId:userId];
            [userList addObject:object];
        }

        if (completionHandler) {
            completionHandler(userList, nil);
        }
    }];


    [chatKit setDidSelectConversationsListCellBlock:^(NSIndexPath *indexPath, AVIMConversation *conversation, LCCKConversationListViewController *controller) {
        NSLog(@"conversation selected");
        LCCKConversationViewController *conversationVC = [[LCCKConversationViewController alloc] initWithConversationId:conversation.conversationId];
        [controller.navigationController pushViewController:conversationVC animated:YES];
        [conversationVC configureBarButtonItemStyle:LCCKBarButtonItemStyleGroupProfile action:^(__kindof LCCKBaseViewController *viewController, UIBarButtonItem *sender, UIEvent *event) {
            
        }];
    }];

    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"联系人", @"聊天列表"]];
    segment.frame = CGRectMake(0, 7, 160, 30);
    segment.selectedSegmentIndex = 0;
    [segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segment;

    [self.view bringSubviewToFront:self.contactListVC.view];
}

- (LCCKContactListViewController *)contactListVC {
    if (!_contactListVC) {
        NSArray *allPersonIds = [[NSUserDefaults standardUserDefaults] objectForKey:@"contactList"];
        _contactListVC = [[LCCKContactListViewController alloc] initWithUserIds:[NSSet setWithArray:allPersonIds] mode:LCCKContactListModeNormal];
        [self.view addSubview:_contactListVC.view];
        [self addChildViewController:_contactListVC];
    }
    return _contactListVC;
}

- (LCCKConversationListViewController *)conversationListVC {
    if (!_conversationListVC) {
        _conversationListVC = [[LCCKConversationListViewController alloc] init];
        [self.view addSubview:_conversationListVC.view];
        [self addChildViewController:_conversationListVC];
    }
    return _conversationListVC;
}



- (void)segmentAction:(UISegmentedControl *)segment{
    if (segment.selectedSegmentIndex == 0) {
        [self.view bringSubviewToFront:self.contactListVC.view];
    }
    else {
        [self.view bringSubviewToFront:self.conversationListVC.view];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

    //LCCKContactListViewController
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
