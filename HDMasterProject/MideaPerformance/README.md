# iOS性能监控组件

<div align=center><img width="230" src="README_Images/Results_show01.PNG"/><img width="230" src="README_Images/Results_show02.PNG"/><img width="230" src="README_Images/Results_show03.PNG"/></div>

## 如何使用

### 1、导入 MideaPerformance

可通过pod引入的方式 `pod 'MideaPerformance'`

也可以手动拖入项目中

### 2、调用 showPerformaceView 方法

```
#import "AppDelegate.h"
#import "MideaPerformance.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 展示监控视图
    [MideaPerformance showMonitorView];
    
    return YES;
}

@end
```

## 一、CPU占用率

CPU作为手机的中央处理器，可以说是手机最关键的组成部分，所有应用程序都需要它来调度运行，资源有限。所以当我们的APP因设计不当，使 CPU 持续以高负载运行，将会出现APP卡顿、手机发热发烫、电量消耗过快等等严重影响用户体验的现象

APP在运行的时候，会开启多条线程，包括主线程和子线程，每条线程都会占用CPU的资源。所以我们可以先获取每条线程的CPU占用率，然后把他们累加起来，就能得到该APP的的CPU占有率了。

iOS的线程技术是基于Mach线程技术实现的，APP在运行的时候，会对应一个`Mach Task`，而Task下可能有多条线程同时执行任务。在Mach层中`thread_basic_info`结构体封装了单个线程的基本信息，其中`cpu_usage`就是该线程的CPU使用率。

<div align=center><img width="700" src="README_Images/Mach-thread_basic_info-struct.png"/></div>

一个`Mach Task`包含它的线程列表。内核提供了`task_threads`函数调用获取指定 task 的线程列表，然后可以通过`thread_info`函数调用来查询指定线程的信息，在 thread_act.h 中有相关定义。

task_threads将target_task任务中的所有线程保存在act_list数组中，act_listCnt表示线程个数：

<div align=center><img width="700" src="README_Images/task_threads-API.png"/></div>

<div align=center><img width="700" src="README_Images/thread_info.png"/></div>

代码实现

```
/// 获取CPU使用率
+ (double)getCpuUsage {
    kern_return_t           kr;
    thread_array_t          threadList;         // 保存当前Mach task的线程列表
    mach_msg_type_number_t  threadCount;        // 保存当前Mach task的线程个数
    thread_info_data_t      threadInfo;         // 保存单个线程的信息列表
    mach_msg_type_number_t  threadInfoCount;    // 保存当前线程的信息列表大小
    thread_basic_info_t     threadBasicInfo;    // 线程的基本信息
    
    /*
     1、获取当前程序的线程列表
     通过“task_threads”API调用获取指定 task 的线程列表
     mach_task_self()，表示获取当前的 Mach task
     */
    kr = task_threads(mach_task_self(), &threadList, &threadCount);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    double cpuUsage = 0;
    // 遍历线程
    for (int i = 0; i < threadCount; i++) {
        threadInfoCount = THREAD_INFO_MAX;
        
        /*
         2、取出单个线程的基本信息
         通过“thread_info”API调用来查询指定线程的信息
         flavor参数传的是THREAD_BASIC_INFO，使用这个类型会返回线程的基本信息，
         定义在 thread_basic_info_t 结构体，包含了用户和系统的运行时间、运行状态和调度优先级等
         */
        kr = thread_info(threadList[i], THREAD_BASIC_INFO, (thread_info_t)threadInfo, &threadInfoCount);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        /*
         3、根据线程信息，获取当前线程的CUP使用率，并累加
         */
        threadBasicInfo = (thread_basic_info_t)threadInfo;
        if (!(threadBasicInfo->flags & TH_FLAGS_IDLE)) {
            cpuUsage += threadBasicInfo->cpu_usage;
        }
    }
    
    // 回收内存，防止内存泄漏
    vm_deallocate(mach_task_self(), (vm_offset_t)threadList, threadCount * sizeof(thread_t));
    
    // 返回各个线程占用CPU的总和
    return cpuUsage / (double)TH_USAGE_SCALE * 100.0;
}

```

## 二、内存

虽然现在的手机内存越来越大，但毕竟是有限的，如果因为我们的应用设计不当造成内存过高，可能面临被系统“干掉”的风险，这对用户来说是毁灭性的体验。

Mach task 的内存使用信息存放在`mach_task_basic_info`结构体中 ，其中`resident_size` 为应用使用的物理内存大小，`virtual_size`为虚拟内存大小，在`task_info.h`中：

<div align=center><img width="700" src="README_Images/mach_task_basic_info-stuct.png"/></div>

获取方式是通过`task_info` API 根据指定的 flavor 类型，返回 target_task 的信息，在task.h中：

<div align=center><img width="700" src="README_Images/get-task_info-Api.png"/></div>

具体实现如下：

```
/// 获取当前应用的内存占用情况，和Xcode数值相差较大
+ (double)getResidentMemory {
    struct mach_task_basic_info info;
    mach_msg_type_number_t count = MACH_TASK_BASIC_INFO_COUNT;
    
    /*
     mach_task_self()：表示获取当前的 Mach task
     MACH_TASK_BASIC_INFO： Mach task 基本信息类型
     info：存放基本信息数据
     count：个数
     */
    kern_return_t kernelReturn = task_info(mach_task_self(),
                                           MACH_TASK_BASIC_INFO,
                                           (task_info_t)&info,
                                           &count);

    if (kernelReturn == KERN_SUCCESS) {
        // 获取使用的物理内存大小
        return info.resident_size / (1024 * 1024);
    } else {
        return -1.0;
    }
}
```

但是测试的时候，我们会发现这个跟我们在 Xcode 和 Instruments 里面看到的内存大小不一样，有时候甚至差别很大。更加准确的方式应该是用 `phys_footprint`：

```
/// 获取当前应用的内存占用情况，和Xcode数值相近
+ (double)getMemoryUsage {
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    
    kern_return_t kernelReturn = task_info(mach_task_self(),
                                           TASK_VM_INFO,
                                           (task_info_t)&vmInfo,
                                           &count);
    
    if(kernelReturn == KERN_SUCCESS) {
        return (double)vmInfo.phys_footprint / (1024 * 1024);
    } else {
        return -1.0;
    }
}

```

## 三、FPS

`FPS`是`Frames Per Second` 的简称缩写，意思是每秒传输帧数，也就是我们常说的“刷新率”（单位为Hz）。FPS是测量用于保存、显示动态视频的信息数量。每秒钟帧数愈多，所显示的画面就会愈流畅，FPS值越低就越卡顿，所以这个值在一定程度上可以衡量应用在图像绘制渲染处理时的性能。一般我们的APP的FPS只要保持在 `50-60` 之间，用户体验都是比较流畅的。

我们可以通过`CADisplayLink`来监控我们的`FPS`。`CADisplayLink`是`CoreAnimation`提供的另一个类似于`NSTimer`的类，它总是在屏幕完成一次更新之前启动，它的接口设计的和NSTimer很类似，所以它实际上就是一个内置实现的替代，但是和timeInterval以秒为单位不同，CADisplayLink有一个整型的frameInterval属性，指定了间隔多少帧之后才执行。默认值是1，意味着每次屏幕更新之前都会执行一次。但是如果动画的代码执行起来超过了六十分之一秒，你可以指定frameInterval为2，就是说动画每隔一帧执行一次（一秒钟30帧）。

```
@implementation MDFPSLabel {
    CADisplayLink *_link;
    NSUInteger _count;
    NSTimeInterval _lastTime;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.textAlignment = NSTextAlignmentCenter;
    self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
    
    // 创建CADisplayLink，设置代理和回调
    _link = [CADisplayLink displayLinkWithTarget:[MDWeakProxy proxyWithTarget:self]
                                        selector:@selector(tick:)];
    // 并添加到当前runloop的NSRunLoopCommonModes
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    return self;
}

- (void)dealloc {
    [_link invalidate];
}

// 计算 fps
- (void)tick:(CADisplayLink *)link {
    
    if (_lastTime == 0) { // 当前时间戳
        _lastTime = link.timestamp;
        return;
    }
    
    _count++; // 执行次数
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    float fps = _count / delta; // fps
    _count = 0;
    
    // 更新 fps 
    CGFloat progress = fps / 60.0;
    self.text = [NSString stringWithFormat:@"%d",(int)round(fps)];
    self.textColor = [UIColor colorWithHue:0.27 * (progress - 0.2)
                                saturation:1
                                brightness:0.9
                                     alpha:1];
}

@end

```

## 未完，待续……



