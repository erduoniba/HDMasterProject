//
//  HDTextFieldDemo.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2018/7/30.
//  Copyright © 2018年 HarryDeng. All rights reserved.
//

#import "HDTextFieldDemo.h"

@interface HDTextFieldDemo () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *tf;

@end

@implementation HDTextFieldDemo

- (void)viewDidLoad {
    [super viewDidLoad];

    _tf = [[UITextField alloc] initWithFrame:CGRectMake(10, 100, kScreenWidth - 20, 43)];
    _tf.backgroundColor = [UIColor orangeColor];
    _tf.delegate = self;
    [self.view addSubview:_tf];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [_tf becomeFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.25 animations:^{
        [self.navigationController setNavigationBarHidden:YES];
        _tf.frame = CGRectMake(10, 44, kScreenWidth  -20, 43);
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.25 animations:^{
        [self.navigationController setNavigationBarHidden:NO];
        _tf.frame = CGRectMake(10, 100, kScreenWidth  -20, 43);
    }];
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
