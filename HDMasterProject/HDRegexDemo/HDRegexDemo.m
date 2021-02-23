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
    
    NSString *oUrl = @"https://wq.jd.com/jxjmp/nativeapp/deal/confirmorder/main?sourceType=1&fromKey=fromShoppingCart&ptag=138844.1.1&addrId=2737784960";
    NSString *tUrl = [self regexMatchingJDToJingxi:oUrl];
    NSLog(@"tUrl : %@", tUrl);
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

- (NSString *)regexMatchingJDToJingxi:(NSString *)url  {
    NSDictionary *replaceHost;
    if (!replaceHost) {
        replaceHost = @{
            @"configs":@[
                    @{
                        @"urlReg": @"^https?:[/]{2}(wqs[.]jd[.]com).*",
                        @"replaceFrom": @"(^https?:[/][/])wqs[.]jd[.]com(.*)",
                        @"replaceTo": @"$1st.jingxi.com$2",
                        @"status": @"on"
                    },
                    @{
                        @"urlReg": @"^https?:[/]{2}wq[.]jd[.]com[/]jxjmp[/]nativeapp[/]deal[/]confirmorder[/]main.*",
                        @"replaceFrom": @"^https?:[/]{2}wq[.]jd[.]com[/]jxjmp[/]nativeapp[/]deal[/]confirmorder[/]main.*",
                        @"replaceTo": @"http://wqdeal.jd.com/socialconfirmorder/appredirect",
                        @"status": @"on"
                    }]
        };
    }
    
    NSArray *configs = replaceHost[@"configs"];
    
    for (int i=0; i<configs.count; i++) {
        NSDictionary *regs = configs[i];
        
        NSString *urlReg = regs[@"urlReg"];
        NSPredicate *predURL = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlReg];
        BOOL result = [predURL evaluateWithObject:url];
        NSString *replaceFrom = regs[@"replaceFrom"];
        NSString *replaceTo = regs[@"replaceTo"];
        
        // 该url被匹配上，则根据规则进行替换
        if (result && replaceFrom && replaceTo) {
            NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:replaceFrom options:NSRegularExpressionCaseInsensitive error:nil];
            NSString *resultStr = [regExp stringByReplacingMatchesInString:url
                                                                   options:NSMatchingReportProgress
                                                                     range:NSMakeRange(0, url.length)
                                                              withTemplate:replaceTo];
            return resultStr;
        }
    }
    
    return url;
}

@end
