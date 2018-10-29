//
//  main.m
//  HDMasterProject
//
//  Created by Harry on 16/4/27.
//  Copyright © 2016年 HarryDeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        for (int i=0; i<10000; i++) {
            if ((i%3==2) && (i%5==4) && (i%7==6)) {
                NSLog(@"iiiiiiiii : %d", i);
            }
        }
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
