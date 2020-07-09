//
//  HDRegexDemo.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2020/7/3.
//  Copyright © 2020 HarryDeng. All rights reserved.
//

#import "HDRegexDemo.h"

@interface HDRegexDemo ()

@property (weak, nonatomic) IBOutlet UITextField *regexTF;
@property (weak, nonatomic) IBOutlet UITextField *urlTF;
@property (weak, nonatomic) IBOutlet UILabel *resultLb;

@property (weak, nonatomic) IBOutlet UITextField *replaceUrlTF;
@property (weak, nonatomic) IBOutlet UITextField *replaceRegexTF;
@property (weak, nonatomic) IBOutlet UITextField *replaceStrTF;
@property (weak, nonatomic) IBOutlet UILabel *replaceResultLb;


@end

@implementation HDRegexDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)regexAction {
    if ([self regexMatching:_regexTF.text forString:_urlTF.text]) {
        _resultLb.text = @"匹配成功";
    }
    else {
        _resultLb.text = @"未匹配";
    }
}

- (IBAction)replaceRegexAction {
    NSString *result = [self replaceUrl:_replaceUrlTF.text regex:_replaceRegexTF.text replaceString:_replaceStrTF.text];
    _replaceResultLb.text = result;
}

- (BOOL)regexMatching:(NSString *)regex forString:(NSString *)sourceStr {
    NSPredicate *predURL = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL result = [predURL evaluateWithObject:sourceStr];
    return result;
}

- (NSString *)replaceUrl:(NSString *)url regex:(NSString *)regex replaceString:(NSString *)replace {
    // 正则替换
    NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *resultStr = [regExp stringByReplacingMatchesInString:url
                                                 options:NSMatchingReportProgress
                                                   range:NSMakeRange(0, url.length)
                                            withTemplate:replace];
    NSLog(@"resultStr: %@", resultStr);
    return resultStr;
}

- (NSString *)url:(NSString *)url urlReg:(NSString *)urlReg reg:(NSString *)reg replace:(NSString *)replace {
    BOOL result = [self regexMatching:urlReg forString:url];
     if (result) {
         // 正则替换
         NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:reg options:NSRegularExpressionCaseInsensitive error:nil];
         NSString *resultStr = [regExp stringByReplacingMatchesInString:url
                                                      options:NSMatchingReportProgress
                                                        range:NSMakeRange(0, url.length)
                                                 withTemplate:replace];
         NSLog(@"resultStr: %@", resultStr);
         return resultStr;
     }
    NSLog(@"resultStr: %@", url);
    return url;
}

@end
