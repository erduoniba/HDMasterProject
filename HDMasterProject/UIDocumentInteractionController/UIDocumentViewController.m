//
//  UIDocumentViewController.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2018/1/2.
//  Copyright © 2018年 HarryDeng. All rights reserved.
//

#import "UIDocumentViewController.h"

@interface UIDocumentViewController () <UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) UIDocumentInteractionController *documentController;

@end

@implementation UIDocumentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.frame = CGRectMake(100, 100, 40, 40);
    [btn addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn2.frame = CGRectMake(100, 200, 40, 40);
    [btn2 addTarget:self action:@selector(buttonAction2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonAction {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"iOSAppReverseEngineering" ofType:@"pdf"];
    _documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    _documentController.delegate = self;
    _documentController.UTI = @"com.adobe.pdf";
    BOOL canOpen = [_documentController presentOptionsMenuFromRect:CGRectZero inView:self.view animated:YES];
    if (!canOpen) {
        NSLog(@"沒有程序可以打開要分享的文件");
    }
}

- (void)buttonAction2 {
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"iOSAppReverseEngineering" ofType:@"pdf"];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"3333" ofType:@"jpg"];
    _documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    _documentController.delegate = self;
    [_documentController presentPreviewAnimated:YES];
}

#pragma mark - UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller {
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller {
    return self.view.frame;
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
