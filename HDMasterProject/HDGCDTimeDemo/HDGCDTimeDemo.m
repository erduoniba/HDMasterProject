//
//  HDGCDTimeDemo.m
//  HDMasterProject
//
//  Created by 邓立兵 on 2019/1/17.
//  Copyright © 2019 HarryDeng. All rights reserved.
//

#import "HDGCDTimeDemo.h"

@interface HDGCDTimeDemo ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, assign) NSInteger number;

@end

@implementation HDGCDTimeDemo {
    dispatch_source_t _timer;
    BOOL _isRun;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _isRun = NO;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (IBAction)startAction:(id)sender {
    _number = 0;
    if (!_timer) {
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
        dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(_timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                self->_number ++;
                self->_label.text = [NSString stringWithFormat:@"%ld", (long)self->_number];
            });
        });
        dispatch_resume(_timer);
    }
    else {
        if (_isRun) {
            dispatch_suspend(_timer);
        }
        dispatch_resume(_timer);
    }
    _isRun = YES;
}
- (IBAction)pauseAction:(id)sender {
    if (_timer) {
        if (_isRun) {
            dispatch_suspend(_timer);
        }
        _isRun = NO;
    }
}

- (IBAction)recoverAction:(id)sender {
    if (_timer) {
        if (_isRun) {
            dispatch_suspend(_timer);
        }
        dispatch_resume(_timer);
        _isRun = YES;
    }
}

- (IBAction)cancel:(id)sender {
    if (_timer) {
        if (!_isRun) {
            dispatch_resume(_timer);
        }
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
    
    _number = 0;
    self->_label.text = [NSString stringWithFormat:@"%ld", (long)self->_number];
}

@end
