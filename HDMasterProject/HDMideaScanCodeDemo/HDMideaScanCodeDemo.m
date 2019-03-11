//
//  HDMideaScanCodeDemo.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2019/1/22.
//  Copyright © 2019 HarryDeng. All rights reserved.
//

#import "HDMideaScanCodeDemo.h"

#import "MideaDisposeScanCodeTool.h"

@interface HDMideaScanCodeDemo ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITextView *textView2;

@end

@implementation HDMideaScanCodeDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *code = @"http://qrcode.midea.com/midea_e1/index.html?cd=OOhEXE0p7qYli4tDeyjXgLrYVodKo-zZGECjF8xn&SSID=midea_e1_Z010&mode=1";
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 120, kScreenWidth - 20, 100)];
    _textView.text = code;
    [self.view addSubview:_textView];
    
    _textView2 = [[UITextView alloc] initWithFrame:CGRectMake(10, _textView.frame.size.height + _textView.frame.origin.y + 20, kScreenWidth - 20, 100)];
    [self.view addSubview:_textView2];
    
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(100, _textView2.frame.size.height + _textView2.frame.origin.y + 20, kScreenWidth - 200, 40);
    [bt setTitle:@"转换" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(qrCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
}

- (void)qrCodeAction {
    NSString *code = _textView.text;
    NSDictionary *dd = [MideaDisposeScanCodeTool disposeApplianceCode:code];
    NSLog(@"\n code:%@ \n info:%@", code, dd);
    
    _textView2.text = [NSString stringWithFormat:@"%@", dd];
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
