//
//  HDMideaScanCodeDemo.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2019/1/22.
//  Copyright © 2019 HarryDeng. All rights reserved.
//

#import "HDMideaScanCodeDemo.h"

#import "MideaDisposeScanCodeTool.h"

@interface HDMideaScanCodeDemo () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITextView *textView2;

@end

@implementation HDMideaScanCodeDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *code = @"http://qrcode.midea.com/midea_e1/index.html?cd=OOhEXE0p7qYli4tDeyjXgLrYVodKo-zZGECjF8xn&SSID=midea_e1_Z010&mode=1";
    code = @"http://qrcode.midea.com/midea_10/index.html?cd=1OCn9cfJhAydVnXnzIARCHslse5UbniO4VJyKXdZ&SSID=midea_10_0008";
    code = @"http://www.midea.com/kt_APP/index.html?cd=D110001139515429210004";
//    code = @"http://qrcode.midea.com/index.html?v=2&type=0000DA21338000724&mode=0&tsn=0000DA2133800088868021413001";
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 120, kScreenWidth - 20, 100)];
    _textView.text = code;
    [self.view addSubview:_textView];
    
    _textView2 = [[UITextView alloc] initWithFrame:CGRectMake(10, _textView.frame.size.height + _textView.frame.origin.y + 20, kScreenWidth - 20, 120)];
    [self.view addSubview:_textView2];
    
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(100, _textView2.frame.size.height + _textView2.frame.origin.y + 20, kScreenWidth - 200, 40);
    [bt setTitle:@"转换" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(qrCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
    
//    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)qrCodeAction {
    NSString *code = _textView.text;
    NSDictionary *dd = [MideaDisposeScanCodeTool disposeApplianceCode:code];
    NSLog(@"\n code:%@ \n info:%@", code, dd);
    
    _textView2.text = [NSString stringWithFormat:@"%@", dd];
    
//
//    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
//    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    mediaUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
//    mediaUI.allowsEditing = YES;
//    mediaUI.delegate = self;
//
//
//
//    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
//        //调用隐藏方法
//        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
//    }
//
//    [self presentViewController:mediaUI animated:YES completion:^{
////        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
//    }];
}

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    // iOS11需要让导航栏透明，否则图片对不准选择框，选出的图片也会有黑边
//    if ([navigationController isKindOfClass:UIImagePickerController.class]) {
//        navigationController.navigationBar.translucent = YES;
//    }
//}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *Eimage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *Oimage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (!Eimage){
        Eimage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    NSString *result = nil;
    if (Eimage)
    {
        
        UIGraphicsBeginImageContext(Eimage.size);
        [Eimage drawInRect:CGRectMake(0, 0, Eimage.size.width, Eimage.size.height)];
        Eimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (!result)
        {
            NSLog(@"识别图片失败");
        }
        else
        {
            NSLog(@"图片结果: %@", result);
        }
        
    }
    [picker dismissViewControllerAnimated:YES completion:^{
//        [[UIApplication sharedApplication] setStatusBarStyle:self.statusBarStyle animated:YES];
    }];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
//        [[UIApplication sharedApplication] setStatusBarStyle:self.statusBarStyle animated:YES];
    }];
}

@end
