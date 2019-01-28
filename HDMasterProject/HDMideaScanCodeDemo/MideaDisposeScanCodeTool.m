//
//  MideaDisposeScanCodeTool.m
//  HDNetDate
//
//  Created by 邓立兵 on 2018/11/29.
//  Copyright © 2018 Midea. All rights reserved.
//

#import "MideaDisposeScanCodeTool.h"

#import "GetQRID.h"


@implementation MideaDisposeScanCodeTool

+ (NSDictionary *)disposeApplianceCode:(NSString *)code {
    NSString *categoryStr;  //类别，不带0x，例如：fd
    NSString *modelNumStr;  //SN8，例如：ZNCZ1475
    NSString *ssid;         //二维码对应设备的ssid，例如：midea_fd_0008
    NSString *mode = @"0";  //配网模式 '0':'AP', '1':'快连', '2':'声波', '3':'蓝牙' , '4':'零配' , '100':'动态扫码配网'
    if ([code rangeOfString:@"cd="].location != NSNotFound) {
        NSArray *comAry = [code componentsSeparatedByString:@"="];
        NSString *cdSsidStr = [self objectAtIndexCheck:comAry index:1];
        NSString *cdStr;
        if ([cdSsidStr rangeOfString:@"&"].location != NSNotFound) {
            cdStr = [self objectAtIndexCheck:[cdSsidStr componentsSeparatedByString:@"&"] index:0];
        }
        else {
            cdStr = cdSsidStr;
        }
        const char * a =[cdStr UTF8String];
        char finally[33];
        getQRID(a,finally);
        NSString *cdResult;
        if (strlen(finally)) {
            char myfinally[33] = {0};
            strncpy(myfinally, finally, 32);
            cdResult = [NSString stringWithCString:myfinally encoding:NSUTF8StringEncoding];
        }

        categoryStr = [NSString stringWithFormat:@"%@", [cdResult substringWithRange:NSMakeRange(4, 2)]];
        modelNumStr  = [NSString stringWithFormat:@"%@", [cdResult substringWithRange:NSMakeRange(9, 8)]];

        // http://qrcode.midea.com/midea_FD/index.html?cd=1OCn9cfJhAydVnXnzIARCHslse5UbniO4VJyKXdZ&SSID=midea_fd_0008
        NSArray *arr = [code componentsSeparatedByString:@"?"];
        if (arr.count > 1) {
            NSString *params = arr[1];
            NSArray *paramArr = [params componentsSeparatedByString:@"&"];
            for (int i=0; i<paramArr.count; i++) {
                NSString *param = paramArr[i];
                if ([param.uppercaseString containsString:@"SSID="]) {
                    NSArray *ssids = [param componentsSeparatedByString:@"="];
                    if (ssids.count > 1) {
                        // midea_fd_0008
                        ssid = ssids[1];
                        NSArray *categorys = [ssid componentsSeparatedByString:@"_"];
                        if (categorys.count > 1) {
                            categoryStr = categorys[1];
                        }
                    }
                }

                //获取mode
                if ([param.lowercaseString containsString:@"mode="]) {
                    NSArray *modeArr = [param componentsSeparatedByString:@"="];
                    if (modeArr.count > 1) {
                        mode = modeArr[1];
                    }
                }
            }
        }
    }
    else if ([code rangeOfString:@"type="].location != NSNotFound) {
        NSArray  *comAry = [code componentsSeparatedByString:@"type"];
        NSString *cdSsidStr = [self objectAtIndexCheck:comAry index:1];
        NSString *typeStr = [cdSsidStr substringFromIndex:1];
        NSString *cdResult;
        if ([typeStr rangeOfString:@"&"].location != NSNotFound) {
            NSArray *tempArr = [typeStr componentsSeparatedByString:@"&"];
            //获取mode
            for (NSString *temp in tempArr) {
                if ([temp.lowercaseString containsString:@"mode="]) {
                    NSArray *modeArr = [temp componentsSeparatedByString:@"="];
                    if (modeArr.count > 1) {
                        mode = modeArr[1];
                        break;
                    }
                }
            }
            cdResult = [self objectAtIndexCheck:tempArr index:0];
        }
        else {
            cdResult = cdSsidStr;
        }
        categoryStr = [NSString stringWithString:[cdResult substringWithRange:NSMakeRange(4, 2)]];
        modelNumStr = [NSString stringWithString:[cdResult substringFromIndex:cdResult.length - 8]];
    }

    NSDictionary *result = @{
                             @"category" : categoryStr ? : @"",
                             @"modelNum" : modelNumStr ? : @"",
                             @"ssid"    : ssid ? : @"",
                             @"mode"    : mode ? : @"0",
                             };
    return result;
}

+ (id)objectAtIndexCheck:(NSArray *)array index:(NSUInteger)index
{
    if (index >= [array count]) {
        return nil;
    }

    id value = [array objectAtIndex:index];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}


@end
