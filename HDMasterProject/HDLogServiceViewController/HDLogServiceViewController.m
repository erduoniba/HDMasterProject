//
//  HDLogServiceViewController.m
//  HDMasterProject
//
//  Created by Harry on 16/6/13.
//  Copyright © 2016年 HarryDeng. All rights reserved.
//

/*
 ``r''   Open text file for reading.  The stream is positioned at the
 beginning of the file.
 
 ``r+''  Open for reading and writing.  The stream is positioned at the
 beginning of the file.
 
 ``w''   Truncate file to zero length or create text file for writing.
 The stream is positioned at the beginning of the file.
 
 ``w+''  Open for reading and writing.  The file is created if it does not
 exist, otherwise it is truncated.  The stream is positioned at
 the beginning of the file.
 
 ``a''   Open for writing.  The file is created if it does not exist.  The
 stream is positioned at the end of the file.  Subsequent writes
 to the file will always end up at the then current end of file,
 irrespective of any intervening fseek(3) or similar.
 
 ``a+''  Open for reading and writing.  The file is created if it does not
 exist.  The stream is positioned at the end of the file.  Subse-quent Subsequent
 quent writes to the file will always end up at the then current
 end of file, irrespective of any intervening fseek(3) or similar.
 */


#import "HDLogServiceViewController.h"

#include <asl.h>
#import "HDSystemLogMessage.h"

@interface HDLogServiceViewController ()

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, assign) int pipeFileHandle;

@end

@implementation HDLogServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.textView];
    
    //scanf 输入的保存在 stdin 中，对应的文件句柄是 STDIN_FILENO
    //printf 打印的保存在 stdout 中, 对应的文件句柄是 STDOUT_FILENO
    //NSLog 打印的保存在 stderr 中 对应的文件句柄是 STDERR_FILENO
    
    /*
     1: NSLog信息本来保存在 STDOUT_FILENO 句柄 中，但是因为这个文件不在 该app的沙盒中，所以只能通过 freopen 来将NSLog信息 重定向 到指定的文件中。
    */
    //[self logServiceOne];
    
    /*
     2: 通过获取手机所有的日志文件，根据该app的进程标识符来筛选该app的日志，这个也只是针对NSLog的输出，printf并没有获取
     */
//    [self logServiceTwo];
    
    /*
     3: 先将NSLog信息重定向到NSFileHandle中，然后监听NSFileHandle读入的通知，来获取NSLog信息
     */
    [self logServiceThree];
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 20 + 64, self.view.frame.size.width - 20, self.view.frame.size.height - 104)];
        _textView.editable = NO;
    }
    return _textView;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    _textView.frame = CGRectMake(10, 20 + 64, self.view.frame.size.width - 20, self.view.frame.size.height - 104);
}


- (void)logServiceOne{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"<<<<<-  logServiceOnePrefix  ->>>>>>");
        
        //获取输出信息的文件 句柄
        int originH1 = dup(STDERR_FILENO);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0];
        NSString *loggingPath = [documentsPath stringByAppendingPathComponent:@"/mylog.log"];
        
        //原本的NSLog信息都会保存在stderr句柄中 使用freopen重定向到loggingPath文件中, 9-32行代码对 “a+” 进行了说明
        freopen([loggingPath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
        
        NSLog(@"<<<<<-  logServiceOneMiddle1  ->>>>>>");
        NSLog(@"<<<<<-  logServiceOneMiddle2  ->>>>>>");
        NSLog(@"<<<<<-  logServiceOneMiddle3  ->>>>>>");
        
        // 将 输出信息的文件 重定向到 原来的 句柄中，以后的NSLog将再次打印
        dup2(originH1, STDERR_FILENO);
        close(originH1);
        NSLog(@"<<<<<-  logServiceOneSuffix  ->>>>>>");
        
        NSData *data = [NSData dataWithContentsOfFile:loggingPath];
        NSString *log = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _textView.text = [NSString stringWithFormat:@"log文件地址: %@ \nlog日志: %@", loggingPath, log];
        });
        
    });
}


//下面这个代码选自 Flex,这几乎是一段标准的代码
- (void)logServiceTwo{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"<<<<<-  logServiceTwoPrefix  ->>>>>>");
        
        printf("xxxxx");
        
        asl_object_t query = asl_new(ASL_TYPE_QUERY);
        
        //在ios7以后,为了安全,已经不能够读取别的应用的日志了,这里的过滤,只是为了减少工作量, 这个也只是针对NSLog的输出，printf并没有获取
        NSString *pidString = [NSString stringWithFormat:@"%d", [NSProcessInfo processInfo].processIdentifier];
        asl_set_query(query, ASL_KEY_PID, [pidString UTF8String], ASL_QUERY_OP_EQUAL);
        aslresponse response = asl_search(NULL, query);
        aslmsg aslMessage = NULL;
        
        NSMutableArray *logMessages = [NSMutableArray array];
        while ((aslMessage = asl_next(response))) {
            [logMessages addObject:[HDSystemLogMessage logMessageFromASLMessage:aslMessage]];
        }
        asl_release(response);
        
        __block NSMutableString *logString = [NSMutableString string];
        [logMessages enumerateObjectsUsingBlock:^(HDSystemLogMessage *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [logString appendFormat:@" << id:%lld message:%@ sender:%@ date:%@>> \n", obj.messageID, obj.messageText, obj.sender, obj.date];
        }];
        
       dispatch_async(dispatch_get_main_queue(), ^{
          _textView.text = logString;
       });
        
        NSLog(@"<<<<<-  logServiceTwoSuffix  ->>>>>>");
    });
    
}


- (void)logServiceThree{
    NSLog(@"<<<<<-  logServiceThreePrefix  ->>>>>>");
    
    [self redirectSTD:STDERR_FILENO];

    for (int i=1; i<20; i++) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            if (self) {
//
//            }
            NSLog(@"<<<<<-  logServiceThreeMiddle%d  ->>>>>>", i);
        });
    }
    
    NSLog(@"<<<<<-  logServiceThreeSuffix  ->>>>>>");
}

//采用dup2的重定向方式(选自http://lizaochengwen.iteye.com/blog/1476080)
- (void)redirectSTD:(int)fd{
    NSPipe * pipe = [NSPipe pipe] ;
    NSFileHandle *pipeReadHandle = [pipe fileHandleForReading] ;
    _pipeFileHandle = [[pipe fileHandleForWriting] fileDescriptor];
    dup2(_pipeFileHandle, fd);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(redirectNotificationHandle:)
                                                 name:NSFileHandleReadCompletionNotification
                                               object:pipeReadHandle] ;
    [pipeReadHandle readInBackgroundAndNotify];
}

- (void)redirectNotificationHandle:(NSNotification *)nf{
    NSData *data = [[nf userInfo] objectForKey:NSFileHandleNotificationDataItem];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    _textView.text = [NSString stringWithFormat:@"%@\n%@",_textView.text, str];
    NSRange range;
    range.location = [_textView.text length] - 1;
    range.length = 0;
    [_textView scrollRangeToVisible:range];
    
    [[nf object] readInBackgroundAndNotify];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //记得一定要还原 NSLog 的保存地址
    dup2(STDERR_FILENO, _pipeFileHandle);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
