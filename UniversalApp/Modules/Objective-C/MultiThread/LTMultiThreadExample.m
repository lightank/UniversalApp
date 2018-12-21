//
//  LTMultiThreadExample.m
//  UniversalApp
//
//  Created by 李桓宇 on 2018/12/14.
//  Copyright © 2018 huanyu.li. All rights reserved.
//

#import "LTMultiThreadExample.h"

@interface LTMultiThreadExample ()

@end

@implementation LTMultiThreadExample

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self GCDQueue];
}

// @see https://bujige.net/blog/iOS-Complete-learning-GCD.html
#pragma mark - ---------------- GCD Begain ----------------
/*
 Grand Central Dispatch(GCD) 是 Apple 开发的一个多核编程的较新的解决方法。它主要用于优化应用程序以支持多核处理器以及其他对称多处理系统。它是一个在线程池模式的基础上执行的并发任务。在 Mac OS X 10.6 雪豹中首次推出，也可在 iOS 4 及以上版本使用。
 
 GCD 有很多好处啊，具体如下：
     GCD 可用于多核的并行运算
     GCD 会自动利用更多的 CPU 内核（比如双核、四核）
     GCD 会自动管理线程的生命周期（创建线程、调度任务、销毁线程）
     程序员只需要告诉 GCD 想要执行什么任务，不需要编写任何线程管理代码
 
 GCD 中两个核心概念：任务和队列
 
 任务：就是执行操作的意思，换句话说就是你在线程中执行的那段代码。在 GCD 中是放在 block 中的。执行任务有两种方式：同步执行（sync）和异步执行（async）。两者的主要区别是：是否等待队列的任务执行结束，以及是否具备开启新线程的能力。
 
     同步执行（sync）：
         同步添加任务到指定的队列中，在添加的任务执行结束之前，会一直等待，直到队列里面的任务完成之后再继续执行。
         只能在当前线程中执行任务，不具备开启新线程的能力。
    异步执行（async）：
         异步添加任务到指定的队列中，它不会做任何等待，可以继续执行任务。
         可以在新的线程中执行任务，具备开启新线程的能力。
    注意：异步执行（async）虽然具有开启新线程的能力，但是并不一定开启新线程。这跟任务所指定的队列类型有关（下面会讲）。
 
 队列（Dispatch Queue）：这里的队列指执行任务的等待队列，即用来存放任务的队列。队列是一种特殊的线性表，采用 FIFO（先进先出）的原则，即新任务总是被插入到队列的末尾，而读取任务的时候总是从队列的头部开始读取。每读取一个任务，则从队列中释放一个任务。队列的结构可参考下图
 
                                队列(Dispatch Queue)
                       |------------------------------|
     任务3   ----------|-->  任务3   任务2   任务1   ---|---->   正在执行的任务
                      |-----------------------------|
 
 在 GCD 中有两种队列：串行队列和并发队列。两者都符合 FIFO（先进先出）的原则。两者的主要区别是：执行顺序不同，以及开启线程数不同。
 
    串行队列（Serial Dispatch Queue）：
         每次只有一个任务被执行。让任务一个接着一个地执行。一个任务执行完毕后，再执行下一个任务。
         只开启一个新线程（或者不开启新线程，在当前线程执行任务）。
    并发队列（Concurrent Dispatch Queue）：
         可以让多个任务并发（同时）执行。
         可以开启多个线程，并且同时执行任务。
    注意：并发队列的并发功能只有在异步（dispatch_async）函数下才有效。
 
 GCD 的使用步骤其实很简单，只有两步。
     创建一个队列（串行队列或并发队列）
     将任务追加到任务的等待队列中，然后系统就会根据任务类型执行任务（同步执行或异步执行）
 */
- (void)GCDQueue
{
    /*
     创建一个队列
     label:表示队列的唯一标识符，用于 DEBUG，可为空，Dispatch Queue 的名称推荐使用应用程序 ID 这种逆序全程域名
     attr:用来识别是串行队列还是并发队列。DISPATCH_QUEUE_SERIAL 表示串行队列，DISPATCH_QUEUE_CONCURRENT 表示并发队列。
     dispatch_queue_create(<#const char * _Nullable label#>, <#dispatch_queue_attr_t  _Nullable attr#>)
     */
    // 串行队列的创建
    __unused dispatch_queue_t serialQueue = dispatch_queue_create("huanyu.li.serial.queue", DISPATCH_QUEUE_SERIAL);
    // 并发队列的创建
    __unused dispatch_queue_t concurrentQueue = dispatch_queue_create("huanyu.li.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    /*
     对于串行队列，GCD 提供了的一种特殊的串行队列：主队列（Main Dispatch Queue）。
         所有放在主队列中的任务，都会放到主线程中执行。
         可使用dispatch_get_main_queue()获得主队列。
     */
    // 主队列的获取
    __unused dispatch_queue_t mainQueue = dispatch_get_main_queue();
    /*
     对于并发队列，GCD 默认提供了全局并发队列（Global Dispatch Queue）。
     identifier:表示队列优先级，一般用DISPATCH_QUEUE_PRIORITY_DEFAULT。
     flags:暂时没用，用0即可。
     dispatch_get_global_queue(<#long identifier#>, <#unsigned long flags#>);
     */
    // 全局并发队列的获取
    __unused dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 任务的创建方法
    // GCD 提供了同步执行任务的创建方法dispatch_sync和异步执行任务创建方法dispatch_async
    // 同步执行任务创建方法
    dispatch_sync(serialQueue, ^{
        // 这里放同步执行任务代码
    });
    // 异步执行任务创建方法
    dispatch_async(serialQueue, ^{
        // 这里放异步执行任务代码
    });
    
    /*
     两种队列（串行队列/并发队列）+ 两种任务执行方式（同步执行/异步执行）组合
     特殊队列：全局并发队列、主队列。全局并发队列可以作为普通并发队列来使用。但是主队列因为有点特殊，所以我们就又多了两种组合方式
     共计6种组合
     区别          并发队列                    串行队列                       主队列
     同步(sync)    没有开启新线程，串行执行任务    没有开启新线程，串行执行任务       主线程调用：死锁卡住不执行
                                                                           其他线程调用：没有开启新线程，串行执行任务
     异步(async)    有开启新线程，并发执行任务     有开启新线程(1条)，串行执行任务    没有开启新线程，串行执行任务
     */
    
    // 同步执行 + 并发队列: 在当前线程中执行任务，不会开启新线程，执行完一个任务，再执行下一个任务
    //[self syncTaskWithQueue:concurrentQueue];
    
    // 异步执行 + 并发队列：可以开启多个线程，任务交替（同时）执行。
    //[self asyncTaskWithQueue:concurrentQueue];
    
    // 同步执行 + 串行队列：不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务。
    //[self syncTaskWithQueue:serialQueue];
    
    // 异步执行 + 串行队列：会开启新线程，但是因为任务是串行的，执行完一个任务，再执行下一个任务。
    //[self asyncTaskWithQueue:serialQueue];
    
    // 同步执行 + 主队列
    // 在主线程中调用同步执行 + 主队列：互相等待卡住
    //[self syncTaskWithQueue:mainQueue];
    // 在其他线程中调用同步执行 + 主队列：不会开启新线程，执行完一个任务，再执行下一个任务
    //[NSThread detachNewThreadSelector:@selector(syncTaskWithQueue:) toTarget:self withObject:mainQueue];
    
    // 异步执行 + 主队列：只在主线程中执行任务，执行完一个任务，再执行下一个任务。
    //[self asyncTaskWithQueue:mainQueue];
    
    // 线程间通讯
    //[self threadCommunication];
    
    // 栅栏方法：dispatch_barrier_async
    //[self barrierAsyncTask];
    
    // 延时执行方法：dispatch_after
    //[self afterTask];
    
    // 一次性代码（只执行一次）：dispatch_once 能保证某段代码在程序运行过程中只被执行1次，并且即使在多线程的环境下，dispatch_once也可以保证线程安全。
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 只执行1次的代码(这里面默认是线程安全的)
        // code to be executed once
    });
    
    // 快速迭代方法：dispatch_apply
    //[self applyTask];
    
    /*
     队列组：dispatch_group
     有时候我们会有这样的需求：分别异步执行2个耗时任务，然后当2个耗时任务都执行完毕后再回到主线程执行任务。这时候我们可以用到 GCD 的队列组。
         调用队列组的 dispatch_group_async 先把任务放到队列中，然后将队列放入队列组中。或者使用队列组的 dispatch_group_enter、dispatch_group_leave 组合 来实现dispatch_group_async。
         调用队列组的 dispatch_group_notify 回到指定线程执行任务。或者使用 dispatch_group_wait 回到当前线程继续向下执行（会阻塞当前线程）。
     */
    // dispatch_group_notify: 监听 group 中任务的完成状态，当所有的任务都执行完成后，追加任务到 group 中，并执行任务
    //[self groupNotifyTask];
    
    // dispatch_group_wait:暂停当前线程（阻塞当前线程），等待指定的 group 中的任务执行完成后，才会往下继续执行。
    //[self groupWaitTask];
    
    /*
     dispatch_group_enter、dispatch_group_leave
         dispatch_group_enter 标志着一个任务追加到 group，执行一次，相当于 group 中未执行完毕任务数+1
         dispatch_group_leave 标志着一个任务离开了 group，执行一次，相当于 group 中未执行完毕任务数-1。
         当 group 中未执行完毕任务数为0的时候，才会使dispatch_group_wait解除阻塞，以及执行追加到dispatch_group_notify中的任务。
     */
    //[self groupEnterAndLeaveTask];
    
    /*
     dispatch_semaphore: GCD 信号量
     GCD 中的信号量是指 Dispatch Semaphore，是持有计数的信号。类似于过高速路收费站的栏杆。可以通过时，打开栏杆，不可以通过时，关闭栏杆。在 Dispatch Semaphore 中，使用计数来完成这个功能，计数为0时等待，不可通过。计数为1或大于1时，计数减1且不等待，可通过。
     
     Dispatch Semaphore 提供了三个函数。
     
         dispatch_semaphore_create：创建一个Semaphore并初始化信号的总量
         dispatch_semaphore_signal：发送一个信号，让信号总量加1
         dispatch_semaphore_wait：可以使总信号量减1，当信号总量为0时就会一直等待（阻塞所在线程），否则就可以正常执行。
         注意：信号量的使用前提是：想清楚你需要处理哪个线程等待（阻塞），又要哪个线程继续执行，然后使用信号量。
     
     Dispatch Semaphore 在实际开发中主要用于：
     
     保持线程同步，将异步执行任务转换为同步执行任务
     保证线程安全，为线程加锁
     */
    // Dispatch Semaphore 线程同步
    //[self semaphoreSyncTask];
    
    // Dispatch Semaphore 线程锁
    //[self semaphoreLockTask];
}

- (void)syncTaskWithQueue:(dispatch_queue_t)queue
{
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncTask---begin");
    
    dispatch_sync(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i)
        {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_sync(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i)
        {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_sync(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i)
        {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"syncTask---end");
    
    /*
     同步执行 + 并发队列:
     打印信息：
     currentThread---<NSThread: 0x6000003ea5c0>{number = 1, name = main}
     syncTask---begin
     1---<NSThread: 0x60000104ebc0>{number = 1, name = main}
     1---<NSThread: 0x60000104ebc0>{number = 1, name = main}
     2---<NSThread: 0x60000104ebc0>{number = 1, name = main}
     2---<NSThread: 0x60000104ebc0>{number = 1, name = main}
     3---<NSThread: 0x60000104ebc0>{number = 1, name = main}
     3---<NSThread: 0x60000104ebc0>{number = 1, name = main}
     syncTask---end
     
     从同步执行 + 并发队列中可看到：
     所有任务都是在当前线程（主线程）中执行的，没有开启新的线程（同步执行不具备开启新线程的能力）。
     所有任务都在打印的syncTask---begin和syncTask---end之间执行的（同步任务需要等待队列的任务执行结束）。
     任务按顺序执行的。按顺序执行的原因：虽然并发队列可以开启多个线程，并且同时执行多个任务。但是因为本身不能创建新线程，只有当前线程这一个线程（同步任务不具备开启新线程的能力），所以也就不存在并发。而且当前线程只有等待当前队列中正在执行的任务执行完毕之后，才能继续接着执行下面的操作（同步任务需要等待队列的任务执行结束）。所以任务只能一个接一个按顺序执行，不能同时被执行。
     
     
     同步执行 + 串行队列：
     打印信息：
     currentThread---<NSThread: 0x6000031bb400>{number = 1, name = main}
     syncTask---begin
     1---<NSThread: 0x6000031bb400>{number = 1, name = main}
     1---<NSThread: 0x6000031bb400>{number = 1, name = main}
     2---<NSThread: 0x6000031bb400>{number = 1, name = main}
     2---<NSThread: 0x6000031bb400>{number = 1, name = main}
     3---<NSThread: 0x6000031bb400>{number = 1, name = main}
     3---<NSThread: 0x6000031bb400>{number = 1, name = main}
     syncTask---end
     
     从同步执行 + 串行队列可以看到：
         所有任务都是在当前线程（主线程）中执行的，并没有开启新的线程（同步执行不具备开启新线程的能力）。
         所有任务都在打印的syncTask---begin和syncTask---end之间执行（同步任务需要等待队列的任务执行结束）。
         任务是按顺序执行的（串行队列每次只有一个任务被执行，任务一个接一个按顺序执行）。
     
     
     在主线程中调用同步执行 + 主队列：
     互相等待卡住
     
     
     在其他线程中调用同步执行 + 主队列：
     打印信息：
     currentThread---<NSThread: 0x6000012dd0c0>{number = 3, name = (null)}
     syncTask---begin
     1---<NSThread: 0x600001f7dc80>{number = 1, name = main}
     1---<NSThread: 0x600001f7dc80>{number = 1, name = main}
     2---<NSThread: 0x600001f7dc80>{number = 1, name = main}
     2---<NSThread: 0x600001f7dc80>{number = 1, name = main}
     3---<NSThread: 0x600001f7dc80>{number = 1, name = main}
     3---<NSThread: 0x600001f7dc80>{number = 1, name = main}
     syncTask---end
     
     从其他线程中使用同步执行 + 主队列可看到：
         所有任务都是在主线程（非当前线程）中执行的，没有开启新的线程（所有放在主队列中的任务，都会放到主线程中执行）。
         所有任务都在打印的syncTask---begin和syncTask---end之间执行（同步任务需要等待队列的任务执行结束）。
         任务是按顺序执行的（主队列是串行队列，每次只有一个任务被执行，任务一个接一个按顺序执行）。
     为什么现在就不会卡住了呢？
     因为syncTaskWithQueue 任务放到了其他线程里，而任务1、任务2、任务3都在追加到主队列中，这三个任务都会在主线程中执行。syncMain 任务在其他线程中执行到追加任务1到主队列中，因为主队列现在没有正在执行的任务，所以，会直接执行主队列的任务1，等任务1执行完毕，再接着执行任务2、任务3。所以这里不会卡住线程。
     */
    // 利用 Dispatch Semaphore 实现线程同步，将异步执行任务转换为同步执行任务。
    [self semaphoreSyncTask];
}


- (void)asyncTaskWithQueue:(dispatch_queue_t)queue
{
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncTask---begin");
    
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i)
        {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i)
        {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i)
        {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"asyncTask---end");
    
    /*
     异步执行 + 并发队列：
     打印信息：
     currentThread---<NSThread: 0x600001635540>{number = 1, name = main}
     asyncTask---begin
     asyncTask---end
     2---<NSThread: 0x600001ba5d80>{number = 3, name = (null)}
     1---<NSThread: 0x600001bb6500>{number = 4, name = (null)}
     3---<NSThread: 0x600001ba4600>{number = 5, name = (null)}
     2---<NSThread: 0x600001ba5d80>{number = 3, name = (null)}
     1---<NSThread: 0x600001bb6500>{number = 4, name = (null)}
     3---<NSThread: 0x600001ba4600>{number = 5, name = (null)}
     
     从异步执行 + 并发队列中可以看出：
         除了当前线程（主线程），系统又开启了3个线程，并且任务是交替/同时执行的。（异步执行具备开启新线程的能力。且并发队列可开启多个线程，同时执行多个任务）。
         所有任务是在打印的asyncTask---begin和asyncTask---end之后才执行的。说明当前线程没有等待，而是直接开启了新线程，在新线程中执行任务（异步执行不做等待，可以继续执行任务）。
     
     异步执行 + 串行队列：
     打印信息：
     currentThread---<NSThread: 0x600001524b40>{number = 1, name = main}
     asyncTask---begin
     asyncTask---end
     1---<NSThread: 0x60000188a1c0>{number = 3, name = (null)}
     1---<NSThread: 0x60000188a1c0>{number = 3, name = (null)}
     2---<NSThread: 0x60000188a1c0>{number = 3, name = (null)}
     2---<NSThread: 0x60000188a1c0>{number = 3, name = (null)}
     3---<NSThread: 0x60000188a1c0>{number = 3, name = (null)}
     3---<NSThread: 0x60000188a1c0>{number = 3, name = (null)}
     
     从异步执行 + 串行队列中可以看出：
         开启了一条新线程（异步执行具备开启新线程的能力，串行队列只开启一个线程）。
         所有任务是在打印的asyncTask---begin和asyncTask---end之后才开始执行的（异步执行不会做任何等待，可以继续执行任务）。
         任务是按顺序执行的（串行队列每次只有一个任务被执行，任务一个接一个按顺序执行）。
     
     
     异步执行 + 主队列：
     打印信息：
     currentThread---<NSThread: 0x60000003dc80>{number = 1, name = main}
     asyncTask---begin
     asyncTask---end
     1---<NSThread: 0x60000003dc80>{number = 1, name = main}
     1---<NSThread: 0x60000003dc80>{number = 1, name = main}
     2---<NSThread: 0x60000003dc80>{number = 1, name = main}
     2---<NSThread: 0x60000003dc80>{number = 1, name = main}
     3---<NSThread: 0x60000003dc80>{number = 1, name = main}
     3---<NSThread: 0x60000003dc80>{number = 1, name = main}
     
     从异步执行 + 主队列可以看到：
         所有任务都是在当前线程（主线程）中执行的，并没有开启新的线程（虽然异步执行具备开启线程的能力，但因为是主队列，所以所有任务都在主线程中）。
         所有任务是在打印的syncConcurrent—-begin和syncConcurrent—-end之后才开始执行的（异步执行不会做任何等待，可以继续执行任务）。
         任务是按顺序执行的（因为主队列是串行队列，每次只有一个任务被执行，任务一个接一个按顺序执行）。
     */
}

- (void)threadCommunication
{
    // 获取全局并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 获取主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    // 异步追加任务
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i)
        {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
        
        // 回到主线程
        dispatch_async(mainQueue, ^{
            // 追加在主线程中执行的任务
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        });
    });
    
    /*
     打印结果：
     1---<NSThread: 0x6000010527c0>{number = 3, name = (null)}
     1---<NSThread: 0x6000010527c0>{number = 3, name = (null)}
     2---<NSThread: 0x600001d0ad00>{number = 1, name = main}
     
     可以看到在其他线程中先执行任务，执行完了之后回到主线程执行主线程的相应操作。
     */
}

- (void)barrierAsyncTask
{
    /*
     我们有时需要异步执行两组操作，而且第一组操作执行完之后，才能开始执行第二组操作。这样我们就需要一个相当于栅栏一样的一个方法将两组异步执行的操作组给分割起来，当然这里的操作组里可以包含一个或多个任务。这就需要用到dispatch_barrier_async方法在两个操作组间形成栅栏。
     dispatch_barrier_async函数会等待前边追加到并发队列中的任务全部执行完毕之后，再将指定的任务追加到该异步队列中。然后在dispatch_barrier_async函数追加的任务执行完毕之后，异步队列才恢复为一般动作，接着追加任务到该异步队列并开始执行。具体如下图所示：
     
           ^
           |
           |
       并  |
       发  |     任务1                                    任务4
       队  |         任务2             barrier                 任务5
       列  |             任务3           任务                        任务6
           |
           |
     ------|--------------------------------------------------------------->
           |                        执行时间
     */
    dispatch_queue_t concurrentQueue = dispatch_queue_create("huanyu.li.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(concurrentQueue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i)
        {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(concurrentQueue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i)
        {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_barrier_async(concurrentQueue, ^{
        // 追加任务 barrier
        for (int i = 0; i < 2; ++i)
        {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"barrier---%@",[NSThread currentThread]);// 打印当前线程
        }
    });
    
    dispatch_async(concurrentQueue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i)
        {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(concurrentQueue, ^{
        // 追加任务4
        for (int i = 0; i < 2; ++i)
        {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"4---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    /*
     打印结果：
     1---<NSThread: 0x6000014b8080>{number = 4, name = (null)}
     2---<NSThread: 0x6000014b8940>{number = 3, name = (null)}
     1---<NSThread: 0x6000014b8080>{number = 4, name = (null)}
     2---<NSThread: 0x6000014b8940>{number = 3, name = (null)}
     barrier---<NSThread: 0x6000014b8080>{number = 4, name = (null)}
     barrier---<NSThread: 0x6000014b8080>{number = 4, name = (null)}
     3---<NSThread: 0x6000014b8080>{number = 4, name = (null)}
     4---<NSThread: 0x6000014443c0>{number = 5, name = (null)}
     4---<NSThread: 0x6000014443c0>{number = 5, name = (null)}
     3---<NSThread: 0x6000014b8080>{number = 4, name = (null)}
     
     从dispatch_barrier_async执行结果中可以看出：
        在执行完栅栏前面的操作之后，才执行栅栏操作，最后再执行栅栏后边的操作。
     */
}

- (void)afterTask
{
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncMain---begin");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 2.0秒后异步追加任务代码到主队列，并开始执行
        NSLog(@"after---%@",[NSThread currentThread]);  // 打印当前线程
    });
    
    /*
     打印结果：
     currentThread---<NSThread: 0x600003b9d580>{number = 1, name = main}
     asyncMain---begin
     after---<NSThread: 0x600003b9d580>{number = 1, name = main}

     在打印 asyncMain---begin 之后大约 2.0 秒的时间，打印了 after---<NSThread: 0x600003b9d580>{number = 1, name = main}
     
     需要注意的是：dispatch_after函数并不是在指定时间之后才开始执行处理，而是在指定时间之后将任务追加到主队列中。严格来说，这个时间并不是绝对准确的，但想要大致延迟执行任务，dispatch_after函数是很有效的。
     */
}

- (void)applyTask
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSLog(@"apply---begin");
    dispatch_apply(6, queue, ^(size_t index) {
        NSLog(@"%zd---%@",index, [NSThread currentThread]);
    });
    NSLog(@"apply---end");
    
    /*
     打印结果：
     apply---begin
     1---<NSThread: 0x600003d38fc0>{number = 3, name = (null)}
     3---<NSThread: 0x600003d30c80>{number = 5, name = (null)}
     2---<NSThread: 0x600003d30f40>{number = 4, name = (null)}
     0---<NSThread: 0x600003096980>{number = 1, name = main}
     4---<NSThread: 0x600003d38fc0>{number = 3, name = (null)}
     5---<NSThread: 0x600003d30c80>{number = 5, name = (null)}
     apply---end
     
     因为是在并发队列中异步队执行任务，所以各个任务的执行时间长短不定，最后结束顺序也不定。但是apply---end一定在最后执行。这是因为dispatch_apply函数会等待全部任务执行完毕。
     
     通常我们会用 for 循环遍历，但是 GCD 给我们提供了快速迭代的函数 dispatch_apply。dispatch_apply 按照指定的次数将指定的任务追加到指定的队列中，并等待全部队列执行结束。
     如果是在串行队列中使用 dispatch_apply，那么就和 for 循环一样，按顺序同步执行。可这样就体现不出快速迭代的意义了。
     我们可以利用并发队列进行异步执行。比如说遍历 0~5 这6个数字，for 循环的做法是每次取出一个元素，逐个遍历。dispatch_apply 可以 在多个线程中同时（异步）遍历多个数字。
     还有一点，无论是在串行队列，还是异步队列中，dispatch_apply 都会等待全部任务执行完毕，这点就像是同步操作，也像是队列组中的 dispatch_group_wait方法。
     */
}

- (dispatch_group_t)group
{
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t group =  dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i)
        {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    return group;
}

- (void)groupNotifyTask
{
    // dispatch_group_notify: 监听 group 中任务的完成状态，当所有的任务都执行完成后，追加任务到 group 中，并执行任务
    dispatch_group_notify([self group], dispatch_get_main_queue(), ^{
        // 等前面的异步任务1、任务2都执行完毕后，回到主线程执行下边任务
        for (int i = 0; i < 2; ++i)
        {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
        NSLog(@"group---end");
    });
    
    /*
     打印结果：
     currentThread---<NSThread: 0x600003445c80>{number = 1, name = main}
     group---begin
     1---<NSThread: 0x6000039e8d40>{number = 3, name = (null)}
     2---<NSThread: 0x6000039e89c0>{number = 4, name = (null)}
     2---<NSThread: 0x6000039e89c0>{number = 4, name = (null)}
     1---<NSThread: 0x6000039e8d40>{number = 3, name = (null)}
     3---<NSThread: 0x600003445c80>{number = 1, name = main}
     3---<NSThread: 0x600003445c80>{number = 1, name = main}
     group---end
     
     从dispatch_group_notify相关代码运行输出结果可以看出：
     当所有任务都执行完成之后，才执行dispatch_group_notify block 中的任务
     */
}

- (void)groupWaitTask
{
    // 等待group已有的任务全部完成后，会往下继续执行（会阻塞当前线程）
    dispatch_group_wait([self group], DISPATCH_TIME_FOREVER);
    
    NSLog(@"group---end");
    
    /*
     打印结果：
     currentThread---<NSThread: 0x600001d67b00>{number = 1, name = main}
     group---begin
     2---<NSThread: 0x6000010cc000>{number = 4, name = (null)}
     1---<NSThread: 0x6000010cc500>{number = 3, name = (null)}
     1---<NSThread: 0x6000010cc500>{number = 3, name = (null)}
     2---<NSThread: 0x6000010cc000>{number = 4, name = (null)}
     group---end
     
     从dispatch_group_wait相关代码运行输出结果可以看出：
     当所有任务执行完成之后，才执行 dispatch_group_wait 之后的操作。但是，使用dispatch_group_wait 会阻塞当前线程。
     */
}

- (void)groupEnterAndLeaveTask
{
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步操作都执行完毕后，回到主线程.
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
        NSLog(@"group---end");
    });
    
//    // 等待上面的任务全部完成后，会往下继续执行（会阻塞当前线程）
//    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
//
//    NSLog(@"group---end");
    
    /*
     打印结果：
     currentThread---<NSThread: 0x600000d23840>{number = 1, name = main}
     group---begin
     1---<NSThread: 0x600000080e40>{number = 3, name = (null)}
     2---<NSThread: 0x600000081040>{number = 4, name = (null)}
     2---<NSThread: 0x600000081040>{number = 4, name = (null)}
     1---<NSThread: 0x600000080e40>{number = 3, name = (null)}
     3---<NSThread: 0x600000d23840>{number = 1, name = main}
     3---<NSThread: 0x600000d23840>{number = 1, name = main}
     group---end
     
     从dispatch_group_enter、dispatch_group_leave相关代码运行结果中可以看出：当所有任务执行完成之后，才执行 dispatch_group_notify 中的任务。这里的dispatch_group_enter、dispatch_group_leave组合，其实等同于dispatch_barrier_async。
     */
}

- (void)semaphoreSyncTask
{
    //Dispatch Semaphore 线程同步
    /*
     我们在开发中，会遇到这样的需求：异步执行耗时任务，并使用异步执行的结果进行一些额外的操作。换句话说，相当于，将将异步执行任务转换为同步执行任务。比如说：AFNetworking 中 AFURLSessionManager.m 里面的 tasksForKeyPath: 方法。通过引入信号量的方式，等待异步执行任务结果，获取到 tasks，然后再返回该 tasks。
     
     
     - (NSArray *)tasksForKeyPath:(NSString *)keyPath {
     __block NSArray *tasks = nil;
     dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
     [self.session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
         if ([keyPath isEqualToString:NSStringFromSelector(@selector(dataTasks))]) {
            tasks = dataTasks;
         } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(uploadTasks))]) {
            tasks = uploadTasks;
         } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(downloadTasks))]) {
            tasks = downloadTasks;
         } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(tasks))]) {
            tasks = [@[dataTasks, uploadTasks, downloadTasks] valueForKeyPath:@"@unionOfArrays.self"];
         }
     
         dispatch_semaphore_signal(semaphore);
     }];
     
     dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
     
     return tasks;
     }
     */
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block int number = 0;
    dispatch_async(queue, ^{
        // 追加任务1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        number = 100;
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"semaphore---end,number = %d",number);
    
    /*
     打印结果：
     currentThread---<NSThread: 0x6000008ae980>{number = 1, name = main}
     semaphore---begin
     1---<NSThread: 0x600000501ec0>{number = 3, name = (null)}
     semaphore---end,number = 100

     从 Dispatch Semaphore 实现线程同步的代码可以看到：
     
     semaphore---end 是在执行完 number = 100; 之后才打印的。而且输出结果 number 为 100。
     这是因为异步执行不会做任何等待，可以继续执行任务。异步执行将任务1追加到队列之后，不做等待，接着执行dispatch_semaphore_wait方法。此时 semaphore == 0，当前线程进入等待状态。然后，异步任务1开始执行。任务1执行到dispatch_semaphore_signal之后，总信号量，此时 semaphore == 1，dispatch_semaphore_wait方法使总信号量减1，正在被阻塞的线程（主线程）恢复继续执行。最后打印semaphore---end,number = 100。这样就实现了线程同步，将异步执行任务转换为同步执行任务。
     */
}

- (void)semaphoreLockTask
{
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");
    
    semaphoreLock = dispatch_semaphore_create(1);
    
    // queue1 代表北京火车票售卖窗口
    dispatch_queue_t queue1 = dispatch_queue_create("net.bujige.testQueue1", DISPATCH_QUEUE_SERIAL);
    // queue2 代表上海火车票售卖窗口
    dispatch_queue_t queue2 = dispatch_queue_create("net.bujige.testQueue2", DISPATCH_QUEUE_SERIAL);
    
    __weak typeof(self) weakSelf = self;
    
    BOOL safe = NO;
    
    dispatch_async(queue1, ^{
        [weakSelf saleTicketWithSafeStauts:safe lock:safe ? semaphoreLock : nil];
    });
    
    dispatch_async(queue2, ^{
        [weakSelf saleTicketWithSafeStauts:safe lock:safe ? semaphoreLock : nil];
    });
}

static int kTicketSurplusCount = 50;
static dispatch_semaphore_t semaphoreLock = nil;

- (void)saleTicketWithSafeStauts:(BOOL)safe lock:(dispatch_semaphore_t)lock
{
    while (1)
    {
        if (safe)
        {
            // 相当于加锁
            dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
        }
        
        if (kTicketSurplusCount > 0)
        {  //如果还有票，继续售卖
            kTicketSurplusCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%d 窗口：%@", kTicketSurplusCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        }
        else
        { //如果已卖完，关闭售票窗口
            NSLog(@"所有火车票均已售完");
            if (safe)
            {
                // 相当于解锁
                dispatch_semaphore_signal(lock);
            }
            break;
        }
        
        if (safe)
        {
            // 相当于解锁
            dispatch_semaphore_signal(lock);
        }
    }
    
    /*
     根据打印结果，在safe为YEW情况下票数是有序递减的，为NO情况下无序递减的，可以看出，在考虑了线程安全的情况下，使用 dispatch_semaphore
     机制之后，得到的票数是正确的，没有出现混乱的情况。我们也就解决了多个线程同步的问题。
     */
}

#pragma mark - ---------------- GCD End ----------------


#pragma mark - ---------------- pthread Begain ----------------
#pragma mark - ---------------- pthread End ----------------

#pragma mark - ---------------- NSThread Begain ----------------
#pragma mark - ---------------- NSThread End ----------------

@end
