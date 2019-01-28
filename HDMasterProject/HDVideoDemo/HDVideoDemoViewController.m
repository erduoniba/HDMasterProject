//
//  HDVideoDemoViewController.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2019/1/7.
//  Copyright © 2019 HarryDeng. All rights reserved.
//

#import "HDVideoDemoViewController.h"
#import "MideaVideoViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVPlayerViewController.h>

@interface HDVideoDemoViewController ()

@property (nonatomic, strong) MideaVideoViewController* playerViewController;
@property (nonatomic, strong) AVPlayerItem* playerItem;

@end

@implementation HDVideoDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _playerViewController = [MideaVideoViewController new];
    _playerViewController.view.frame = CGRectMake(0, 200, self.view.frame.size.width, 300);
    if (@available(iOS 11.0, *)) {
        _playerViewController.entersFullScreenWhenPlaybackBegins = YES;
        _playerViewController.exitsFullScreenWhenPlaybackEnds = YES;
    } else {
        // Fallback on earlier versions
    }
    _playerViewController.videoGravity = AVLayerVideoGravityResizeAspect;
//    [self.view addSubview:_playerViewController.view];
    
    [self nextAction];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoDark];
    button.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:button];
    [button addTarget:self action:@selector(nextAction1) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIViewController attemptRotationToDeviceOrientation];
    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}

- (void)nextAction1 {
    [self presentViewController:_playerViewController animated:YES completion:^{
        [_playerViewController.player play];
    }];
}

- (void)nextAction {
    NSString *newURL = [@"https://vdse.bdstatic.com//d0cf2e8e002d56c83324059a0e59fe24.mp4" copy];
    
    if (!newURL) {
        return;
    }
    NSURL *videoNewURL = [NSURL URLWithString:newURL];
    
    AVPlayerViewController *AVVC = (AVPlayerViewController*)_playerViewController;
    if (AVVC.player && _playerItem) {
        [_playerItem removeObserver:self forKeyPath:@"status"];
        [AVVC.player removeObserver:self forKeyPath:@"rate"];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object: _playerItem];
    }
    _playerItem = [[AVPlayerItem alloc] initWithURL:videoNewURL];
    AVPlayer *player = [AVPlayer playerWithPlayerItem: _playerItem];
    AVVC.player = player;
    
    [player addObserver:self
             forKeyPath:@"rate"
                options:NSKeyValueObservingOptionNew
                context:NULL];
    
    [_playerItem addObserver:self
                  forKeyPath:@"status"
                     options:NSKeyValueObservingOptionNew
                     context:NULL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinish) name:AVPlayerItemDidPlayToEndTimeNotification object: _playerItem];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"rate"]) {
//        float rate = [change[NSKeyValueChangeNewKey] floatValue];
//        if (rate == 0.0) {
//            if (_playbackStateChanged)
//                _playbackStateChanged(MideaPlaybackStatePaused);
//        } else if (rate == 1.0) {
//            if (_playbackStateChanged)
//                _playbackStateChanged(MideaPlaybackStatePlaying);
//        } else if (rate == -1.0) {
//            // Reverse playback
//        }
    } else if ([keyPath isEqualToString:@"status"]) {
        NSInteger status = [change[NSKeyValueChangeNewKey] integerValue];
        if (status == AVPlayerStatusFailed) {
//            if (_playbackStateChanged)
//                _playbackStateChanged(MideaPlaybackStateFailed);
        }
    }
}

- (void)playFinish
{
    AVPlayerViewController *AVVC = (AVPlayerViewController*)_playerViewController;
    [[AVVC player] seekToTime:CMTimeMultiply([AVVC player].currentTime, 0)];
}

- (void)play
{
    AVPlayerViewController *AVVC = (AVPlayerViewController*)_playerViewController;
    
    [[AVVC player] play];
}

- (void)pause
{
    AVPlayerViewController *AVVC = (AVPlayerViewController*)_playerViewController;
    [[AVVC player] pause];
}


@end
