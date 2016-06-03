//
//  HDFriendCycleModel.m
//  HDMasterProject
//
//  Created by Harry on 16/6/2.
//  Copyright © 2016年 HarryDeng. All rights reserved.
//

#import "HDFriendCycleModel.h"

@implementation HDFriendCycleModel

+ (NSMutableArray *)queryTestData{
    NSMutableArray *dataArr = [NSMutableArray array];
    
    NSInteger randInt = arc4random() % 10 + 10;
    
    for (int i=0; i<randInt; i++) {
        HDFriendCycleModel *model = [HDFriendCycleModel new];
        model.title = [self randomTitle];
        model.content = [self randomContent];
        model.time = [self randomTime];
        model.picUrl = [NSArray arrayWithArray:[self randomImages]];
        [dataArr addObject:model];
    }
    
    return dataArr;
}

+ (NSString *)randomTitle{
    NSArray *titles = @[
                        @"如果觉得我的文章对您有用，请支持我。您的支持将鼓励我继续创作！",
                        @"Rollout学习1 简单使用篇",
                        @"Rollout学习2 JS和OC代码对照篇",
                        @"UIImage size压缩后图片下面出现白色线问题",
                        @"git submodule 管理子工程 http://blog.csdn.net/u012390519/article/details/51356714"
                        ];
    NSInteger randInt = arc4random() % titles.count;
    return titles[randInt];
}

+ (NSString *)randomContent{
    NSArray *contents = @[
                        @"如果觉得我的文章对您有用，请支持我。您的支持将鼓励我继续创作！如果觉得我的文章对您有用，请支持我。您的支持将鼓励我继续创作！如果觉得我的文章对您有用，请支持我。您的支持将鼓励我继续创作！如果觉得我的文章对您有用，请支持我。您的支持将鼓励我继续创作！",
                        @"Rollout 是国外开发者一个基于iOS运行时注入OC格式化的JS代码来修复/更新App的热修复工具，它有一套自己的JS命名空间及OC代码和JS代码转换的协议，而且它的功能强大且使用简单，文档详细且人性化。",
                        @"对版本兼容也做了可视化界面方便使用者操作，所以目前来说超过一定的月激活量后会收费，但是一切是值得的。",
                        @"使用- (UIImage *)getResizeImageWithSize:(CGSize )size{ // 创建一个bitmap的context // 并把它设置成为当前正在使用的context, UIGraphicsBeginImageContext(size); // 绘制改变大小的图片 ",
                        @"当多人共同维护一个项目时，必然需要进行模块化开发，所以使用submodule来管理子工程很有必要。本文以图文并貌的形势进行一步步搭建主工程及绑定子工程。"
                        ];
    NSInteger randInt = arc4random() % contents.count;
    return contents[randInt];
}

+ (NSString *)randomTime{
    NSArray *times = @[
                          @"2016-06-02",
                          @"2016-06-01",
                          @"2016-05-22",
                          @"2016-04-12",
                          @"2016-04-09",
                          ];
    NSInteger randInt = arc4random() % times.count;
    return times[randInt];
}

+ (NSMutableArray *)randomImages{
    NSArray *images = @[
                       @"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1464859569&di=1326543dd954db593d6c8b209f791361&src=http://img4.duitang.com/uploads/item/201212/16/20121216111033_Xa4UF.jpeg",
                       @"http://cdn.duitang.com/uploads/item/201406/03/20140603204504_ZL24d.thumb.700_0.jpeg",
                       @"http://www.people.com.cn/mediafile/pic/20140409/22/15937063715147780714.jpg",
                       @"http://pic.hzcnc.com/yl/rl/201009/W020100902519747543742.jpg",
                       @"http://img4.duitang.com/uploads/item/201407/03/20140703151621_ZFAuK.thumb.700_0.jpeg",
                       @"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1464859630&di=8daf1e7a42a8a9707ec769340cde9b43&src=http://f.hiphotos.baidu.com/zhidao/pic/item/241f95cad1c8a786e430f4196509c93d70cf508a.jpg",
                       @"http://tupian.qqjay.com/u/2013/1030/36_8450_4.jpg",
                       @"http://a.hiphotos.baidu.com/zhidao/pic/item/f2deb48f8c5494ee3816f00d2ff5e0fe99257eea.jpg",
                       @"http://v1.qzone.cc/pic/201304/29/11/49/517dedd6def95968.png%21600x600.jpg",
                       @"http://h.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=7a71972e26a446237e9fad66ad125e38/4afbfbedab64034f6fa32f52a9c379310a551d73.jpg",
                       @"http://y3.ifengimg.com/dbcc8e45854c158f/2015/0702/rdn_559520d897ac1.jpg"
                       ];
    NSInteger randInt = arc4random() % 9;
    
    NSMutableArray *ss = [NSMutableArray arrayWithCapacity:randInt];
    for (int i=0; i<randInt; i++) {
        NSInteger jj = arc4random() % images.count;
        [ss addObject:images[jj]];
    }
    
    return ss;
}

@end
