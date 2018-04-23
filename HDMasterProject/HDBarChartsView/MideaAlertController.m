//
//  MideaAlertController.m
//  midea
//
//  Created by MaYifang on 16/9/25.
//  Copyright © 2016年 Midea. All rights reserved.
//

#import "MideaAlertController.h"

@interface MideaAlertController ()<UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray<MideaAlertController *> *alerts;

@end

@implementation MideaAlertController

+ (instancetype)alertWithAlertTitle:(NSString *)title message:(NSString *)msg cancelBtn:(NSString *)cancelName okButton:(NSString *)okButtonName cancelHandler:(void (^)(MideaAlertController *alert))cancelHandler okHandler:(void (^)(MideaAlertController *alert))okHandler {
    
    MideaAlertController *alertVc = [[self class] alertControllerWithTitle:title message:msg];

    NSString *cancel = @"";
    
    if (cancelName) {
        cancel = cancelName;
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancelHandler) {
            cancelHandler(alertVc);
        }
        
    }];
    
    UIAlertAction *okaAction = [UIAlertAction actionWithTitle:okButtonName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (okHandler) {
            okHandler(alertVc);
        }
    }];
    
    [alertVc addAction:cancelAction];
    [alertVc addAction:okaAction];
    
    return alertVc;
}

+ (instancetype)alertWithAlertTitle:(NSString *)title message:(NSString *)msg cancelBtn:(NSString *)cancelName cancelHandler:(void (^)(MideaAlertController *alert))cancelHandler {
    
    MideaAlertController *alertVc = [[self class] alertControllerWithTitle:title message:msg];
    
    NSString *cancel = @"";
    
    if (cancelName) {
        cancel = cancelName;
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancelHandler) {
            cancelHandler(alertVc);
        }
    }];
    
    [alertVc addAction:cancelAction];
    return alertVc;
}

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message {
    return [super alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
}

- (NSMutableArray<MideaAlertController *> *)alerts {
    if (_alerts == nil) {
        _alerts = [[NSMutableArray alloc] init];
    }
    return _alerts;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.clipsToBounds = YES;
        _contentView.layer.cornerRadius = 12.0;
        [self.view addSubview:_contentView];
    }
    return _contentView;
}


- (void)okButtonClick {
    [self disMiss];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addAlert:(MideaAlertController *)alert {
    [self.alerts addObject:alert];
}

- (void)show {
    [self show:YES];
}

- (void)disMiss {
    [self disMiss:YES];
}

- (void)show:(BOOL)animated {
    UIViewController *currentViewController = nil;
    if ([UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController) {
        currentViewController = [UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController;
    } else {
        currentViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    if ([currentViewController isKindOfClass:[MideaAlertController class]]) {
        MideaAlertController *alert = (MideaAlertController *)currentViewController;
        [alert addAlert:self];
        return ;
    }
    [currentViewController presentViewController:self animated:animated completion:^{}];
}

- (void)disMiss:(BOOL)animated {
    [self dismissViewControllerAnimated:animated completion:^{}];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"MideaAlertController viewDidDisappear");
    if (self.alerts.count > 0) {
        for (MideaAlertController *alert in self.alerts) {
            [alert show:animated];
        }
    }
    [self.alerts removeAllObjects];
}

- (void)dealloc {
    NSLog(@"MideaAlertController dealloc");
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
