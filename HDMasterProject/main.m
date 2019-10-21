//
//  main.m
//  HDMasterProject
//
//  Created by Harry on 16/4/27.
//  Copyright © 2016年 HarryDeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#import <AdSupport/AdSupport.h>

int main(int argc, char * argv[]) {
    @autoreleasepool {
//        for (int i=0; i<10000; i++) {
//            if ((i%3==2) && (i%5==4) && (i%7==6)) {
//                NSLog(@"iiiiiiiii : %d", i);
//            }
//        }
        
        Class LSApplicationWorkspace_class = NSClassFromString(@"LSApplicationWorkspace");
        NSObject *workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
        NSArray *arrAPP = [workspace performSelector:@selector(allApplications)];
        NSLog(@"arrAPP: %@",arrAPP);
        
        if ( [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled] ) {
            NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
            
            NSLog(@"idfa1 : %@", idfa);
        }
        else {
            NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
            
            NSLog(@"idfa2 : %@", idfa);
        }
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
