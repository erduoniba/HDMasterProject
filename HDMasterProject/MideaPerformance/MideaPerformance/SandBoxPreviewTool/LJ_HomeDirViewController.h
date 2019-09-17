//
//  LJ_HomeDirViewController.h
//  FileDirectoryTool
//
//  Created by nuomi on 2017/2/7.
//  Copyright © 2017年 xgyg. All rights reserved.
//

#import "LJ_BaseViewController.h"

@interface LJ_HomeDirViewController : LJ_BaseViewController

@property (nonatomic,assign)BOOL isHomeDir;//文件路径
@property (nonatomic,copy)NSString * filePath;//文件路径
@property (nonatomic,copy)NSString * fileName;//文件名称

@end
