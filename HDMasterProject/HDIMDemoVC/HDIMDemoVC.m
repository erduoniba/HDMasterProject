//
//  HDIMDemoVC.m
//  HDMasterProject
//
//  Created by denglibing on 2017/3/28.
//  Copyright © 2017年 HarryDeng. All rights reserved.
//

#import "HDIMDemoVC.h"
#import "HDIMListVC.h"

#import "NSObject+LCCKHUD.h"

#import <AVOSCloud/AVOSCloud.h>

#import "LCCKUser.h"

@interface HDIMDemoVC ()

@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;

@property (weak, nonatomic) IBOutlet UIView *registerView;
@property (weak, nonatomic) IBOutlet UITextField *userNameLb;
@property (weak, nonatomic) IBOutlet UITextField *mailTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet UIView *useLoginView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;

@end

@implementation HDIMDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];

    // 保存对象
    AVObject *testObject = [AVObject objectWithClassName:@"user"];
    [testObject setObject:@"26" forKey:@"age"];
    [testObject setObject:@"harry" forKey:@"name"];
    [testObject setObject:@"shenzhen" forKey:@"area"];
    [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"保存成功 object:%@", testObject.objectId);
        }
        else {
            NSLog(@"保存失败 error:%@", error);
        }
    }];

    // 获取对象
    AVObject *obj = [AVObject objectWithClassName:@"user" objectId:@"58d9ff53ac502e0058e1d671"];
    [obj fetchInBackgroundWithBlock:^(AVObject * _Nullable object, NSError * _Nullable error) {
        NSLog(@"name:%@ age:%@", obj[@"name"], object[@"age"]);
        [obj setObject:@"27" forKey:@"age"];
        [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {

        }];
    }];

    // 获取对象
    AVQuery *query = [AVQuery queryWithClassName:@"user"];
    [query getObjectInBackgroundWithId:@"58d9ff53ac502e0058e1d671" block:^(AVObject * _Nullable object, NSError * _Nullable error) {
        
    }];

    [self.view bringSubviewToFront:_registerView];
}

- (IBAction)getMailAction:(id)sender {
    [AVUser requestEmailVerify:_mailTF.text withBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"获取邮箱验证码成功");
        }
        else {
            NSLog(@"获取邮箱验证码失败 error:%@", error);
        }
    }];
}


- (IBAction)registerAction:(id)sender {
    AVUser *user = [AVUser user];
    user.username = _userNameLb.text;
    user.password = _passwordTF.text;
    user.email = _mailTF.text;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"注册成功");
        }
        else {
            NSLog(@"注册失败 error:%@", error);
        }
    }];
}


- (IBAction)getCodeAction:(id)sender {
    [AVOSCloud requestSmsCodeWithPhoneNumber:_phoneTF.text callback:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"获取验证码成功");
        }
        else {
            NSLog(@"获取验证码失败 error:%@", error);
        }
    }];
}

- (IBAction)codeLoginAction:(id)sender {
    [AVUser signUpOrLoginWithMobilePhoneNumberInBackground:_phoneTF.text smsCode:_codeTF.text block:^(AVUser * _Nullable user, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"验证码登录成功 user：%@", user);
            
            [self.view lcck_toast:@"登录成功"];
        }
        else {
            NSLog(@"验证码登录失败 error:%@", error);
        }
    }];
}

- (IBAction)changeModel:(UISegmentedControl *)sender {

    if (sender.selectedSegmentIndex == 1) {
        [self.view bringSubviewToFront:_loginView];
    }
    else if (sender.selectedSegmentIndex == 0) {
        [self.view bringSubviewToFront:_registerView];
    }
    else {
        [self.view bringSubviewToFront:_useLoginView];
    }

    CATransition *animation = [CATransition animation];
    animation.duration = 0.7 ;  // 动画持续时间(秒)
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";//淡入淡出效果
    [self.view.layer addAnimation:animation forKey:@"animation"];
}

- (IBAction)userNameLoginAction:(id)sender {

    LCChatKit *chatKit = [LCChatKit sharedInstance];

    [chatKit openWithClientId:_userNameTF.text
                     callback:^(BOOL succeeded, NSError *error) {
                         if (succeeded) {
                             [self.view lcck_toast:@"登录成功"];
                             HDIMListVC *vc = [[HDIMListVC alloc] init];
                             [self.navigationController pushViewController:vc animated:YES];
                         }
                         else {

                         }
                     }];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
