---
layout: post
date: 2018-04-29 16:56:30 +0800
title: 读懂 thread dump
nocomments: false
---

本文简单总结了下thread dump给出了哪些信息。

> TL;DR; thread dump能看到所有线程一个时刻的状态和调用栈，绑定的操作系统线程id; `jstack -l`能给出线程持有和等待锁的信息以及检测到的死锁。

JVM的thread dump是某一时刻线程状态的快照。通过thread dump可以很方便地看到某个时刻每个线程正在做什么事情。

创建thread dump的有多种方式，最简单的，可以用`jstack <PID>`。
下面是是本地运行一个java程序后，通过`jstack 31441`看到的一个java进程的thread dump。
（使用的java版本是1.8.0_171，jvm是HotSpot64位build 25.171-b11)

```
2018-04-29 17:45:39
Full thread dump Java HotSpot(TM) 64-Bit Server VM (25.171-b11 mixed mode):

"Attach Listener" #10 daemon prio=9 os_prio=0 tid=0x00007f7c40001000 nid=0x7b27 waiting on condition [0x0000000000000000]
   java.lang.Thread.State: RUNNABLE

"Service Thread" #9 daemon prio=9 os_prio=0 tid=0x00007f7c78248800 nid=0x7aeb runnable [0x0000000000000000]
   java.lang.Thread.State: RUNNABLE

"C1 CompilerThread2" #8 daemon prio=9 os_prio=0 tid=0x00007f7c78246000 nid=0x7aea waiting on condition [0x0000000000000000]
   java.lang.Thread.State: RUNNABLE

"C2 CompilerThread1" #7 daemon prio=9 os_prio=0 tid=0x00007f7c78241800 nid=0x7ae9 waiting on condition [0x0000000000000000]
   java.lang.Thread.State: RUNNABLE

"C2 CompilerThread0" #6 daemon prio=9 os_prio=0 tid=0x00007f7c78240000 nid=0x7ae8 waiting on condition [0x0000000000000000]
   java.lang.Thread.State: RUNNABLE

"Monitor Ctrl-Break" #5 daemon prio=5 os_prio=0 tid=0x00007f7c78236800 nid=0x7ae7 runnable [0x00007f7c646ba000]
   java.lang.Thread.State: RUNNABLE
	at java.net.SocketInputStream.socketRead0(Native Method)
	at java.net.SocketInputStream.socketRead(SocketInputStream.java:116)
	at java.net.SocketInputStream.read(SocketInputStream.java:171)
	at java.net.SocketInputStream.read(SocketInputStream.java:141)
	at sun.nio.cs.StreamDecoder.readBytes(StreamDecoder.java:284)
	at sun.nio.cs.StreamDecoder.implRead(StreamDecoder.java:326)
	at sun.nio.cs.StreamDecoder.read(StreamDecoder.java:178)
	- locked <0x00000000d8f6e248> (a java.io.InputStreamReader)
	at java.io.InputStreamReader.read(InputStreamReader.java:184)
	at java.io.BufferedReader.fill(BufferedReader.java:161)
	at java.io.BufferedReader.readLine(BufferedReader.java:324)
	- locked <0x00000000d8f6e248> (a java.io.InputStreamReader)
	at java.io.BufferedReader.readLine(BufferedReader.java:389)
	at com.intellij.rt.execution.application.AppMainV2$1.run(AppMainV2.java:64)
"Signal Dispatcher" #4 daemon prio=9 os_prio=0 tid=0x00007f7c78181800 nid=0x7ae1 runnable [0x0000000000000000]
   java.lang.Thread.State: RUNNABLE

"Finalizer" #3 daemon prio=8 os_prio=0 tid=0x00007f7c7814d800 nid=0x7adf in Object.wait() [0x00007f7c64d46000]
   java.lang.Thread.State: WAITING (on object monitor)
	at java.lang.Object.wait(Native Method)
	- waiting on <0x00000000d8e08ed0> (a java.lang.ref.ReferenceQueue$Lock)
	at java.lang.ref.ReferenceQueue.remove(ReferenceQueue.java:143)
	- locked <0x00000000d8e08ed0> (a java.lang.ref.ReferenceQueue$Lock)
	at java.lang.ref.ReferenceQueue.remove(ReferenceQueue.java:164)
	at java.lang.ref.Finalizer$FinalizerThread.run(Finalizer.java:212)

"Reference Handler" #2 daemon prio=10 os_prio=0 tid=0x00007f7c78149000 nid=0x7add in Object.wait() [0x00007f7c64e47000]
   java.lang.Thread.State: WAITING (on object monitor)
	at java.lang.Object.wait(Native Method)
	- waiting on <0x00000000d8e06bf8> (a java.lang.ref.Reference$Lock)
	at java.lang.Object.wait(Object.java:502)
	at java.lang.ref.Reference.tryHandlePending(Reference.java:191)
	- locked <0x00000000d8e06bf8> (a java.lang.ref.Reference$Lock)
	at java.lang.ref.Reference$ReferenceHandler.run(Reference.java:153)

"main" #1 prio=5 os_prio=0 tid=0x00007f7c7800c800 nid=0x7ad5 runnable [0x00007f7c81783000]
   java.lang.Thread.State: RUNNABLE
	at java.io.FileInputStream.readBytes(Native Method)
	at java.io.FileInputStream.read(FileInputStream.java:255)
	at java.io.BufferedInputStream.read1(BufferedInputStream.java:284)
	at java.io.BufferedInputStream.read(BufferedInputStream.java:345)
	- locked <0x00000000d8e1cf60> (a java.io.BufferedInputStream)
	at sun.nio.cs.StreamDecoder.readBytes(StreamDecoder.java:284)
	at sun.nio.cs.StreamDecoder.implRead(StreamDecoder.java:326)
	at sun.nio.cs.StreamDecoder.read(StreamDecoder.java:178)
	- locked <0x00000000d9014378> (a java.io.InputStreamReader)
	at java.io.InputStreamReader.read(InputStreamReader.java:184)
	at java.io.Reader.read(Reader.java:100)
	at java.util.Scanner.readInput(Scanner.java:804)
	at java.util.Scanner.next(Scanner.java:1369)
	at demo.AppKt.main(App.kt:6)

"VM Thread" os_prio=0 tid=0x00007f7c78141800 nid=0x7adc runnable 

"GC task thread#0 (ParallelGC)" os_prio=0 tid=0x00007f7c78021800 nid=0x7ad6 runnable 

"GC task thread#1 (ParallelGC)" os_prio=0 tid=0x00007f7c78023000 nid=0x7ad7 runnable 

"GC task thread#2 (ParallelGC)" os_prio=0 tid=0x00007f7c78025000 nid=0x7ad9 runnable 

"GC task thread#3 (ParallelGC)" os_prio=0 tid=0x00007f7c78026800 nid=0x7ada runnable 

"VM Periodic Task Thread" os_prio=0 tid=0x00007f7c7824b800 nid=0x7aec waiting on condition 

JNI global references: 12

```

即使不了解这个输出的结构，也不难推测出：
1. 这个进程当时一共有16个线程，除了`main`之外，有9个jvm的守护线程（`deamon`），一个`VM Thread`，4个GC线程，一个`VM Periodic Task Thread`线程。
2. 这份thread dump发生在`2018-04-29 17:45:39`时刻
3. 除了后面的6个线程，每个线程都输出了当时的调用栈，包括调用方法的层级结构，还包括对应的源文件名和代码行
4. `main`线程正在执行`java.io.FileInputStream.readBytes`这个native方法，对应到应用程序代码`App.kt`的第6行。应该是在等待输入。

## Thread Dump结构

Thread Dump的结构，在官方文档中有介绍，见[这个链接][1]。
Thread Dump包含了JVM中所有的线程的调用栈和线程状态。
每个线程都包含一个头部和调用栈，线程之间用空行隔开。执行java代码的线程在最前，跟着是jvm内部的线程。

### 头部

以主线程为例：
```
"main" #1 prio=5 os_prio=0 tid=0x00007f7c7800c800 nid=0x7ad5 runnable [0x00007f7c81783000]
```
头部包含以下信息：
字段 | 用途
----|-----
线程名字和线程id | 可以用来定位线程
线程优先级 | JVM线程使用操作系统线程实现，HotSpot当前默认1对1的，所以线程调度由操作系统负责线程，因此prio可以忽略掉，实际的优先级要看native线程
操作系统分配的优先级 | os_prio实际看并没有和top -H的优先级对应，可以忽略
十六进制的线程id | 是JVM系统所使用的线程id，暂时想不到实际用途
十六进制的native线程id | nid对应到了操作系统的线程，结合top命令能知道一个线程消耗的资源，占用的时长等
线程状态 | 见后面介绍
栈地址区间，估计值(an estimate) | 能了解这个线程在什么位置，暂时想不到实际用途

### 线程状态

名字 | 含义
----|----
NEW | 还没启动
RUNNABLE| 执行中
BLOCKED | 阻塞，等待monitor锁，通常是等待另一块synchronized代码
WAITING | 等待，通常是object.wait()
TIMED_WAITING | 带有截止时间的等待
TERMINATED | 退出执行

### 锁信息

jstack命令提供了三个选项，`-l -m -F`，当JVM进程hang住没有响应时，可以用`-F`来产生thread dump，`-m`会输出native的c/c++的调用栈，`-l`会提供额外的锁的信息。

来给上面的App.kt加个锁，然后重新通过`jstack -l <PID>`创建一个thread dump：

```
"main" #1 prio=5 os_prio=0 tid=0x00007f94d000c800 nid=0x2a49 runnable [0x00007f94d8539000]
   java.lang.Thread.State: RUNNABLE
	at java.io.FileInputStream.readBytes(Native Method)
	at java.io.FileInputStream.read(FileInputStream.java:255)
	at java.io.BufferedInputStream.read1(BufferedInputStream.java:284)
	at java.io.BufferedInputStream.read(BufferedInputStream.java:345)
	- locked <0x00000000d8e1cf60> (a java.io.BufferedInputStream)
	at sun.nio.cs.StreamDecoder.readBytes(StreamDecoder.java:284)
	at sun.nio.cs.StreamDecoder.implRead(StreamDecoder.java:326)
	at sun.nio.cs.StreamDecoder.read(StreamDecoder.java:178)
	- locked <0x00000000d901a438> (a java.io.InputStreamReader)
	at java.io.InputStreamReader.read(InputStreamReader.java:184)
	at java.io.Reader.read(Reader.java:100)
	at java.util.Scanner.readInput(Scanner.java:804)
	at java.util.Scanner.next(Scanner.java:1369)
	at demo.AppKt.main(App.kt:10)

   Locked ownable synchronizers:
	- <0x00000000d8fe9db8> (a java.util.concurrent.locks.ReentrantLock$NonfairSync)
```

可以看到在`main`线程调用栈的下面多了一行锁的信息，能看到`main`线程持有了一个ReentrantLock锁，对应一个十六进制id，暂且认为是锁对象的id。

而其他线程也包含了这行，由于没有持有锁，所以显示的都是`None`：
```
"Reference Handler" #2 daemon prio=10 os_prio=0 tid=0x00007f94d0149000 nid=0x2a53 in Object.wait() [0x00007f94abc45000]
   java.lang.Thread.State: WAITING (on object monitor)
	at java.lang.Object.wait(Native Method)
	- waiting on <0x00000000d8e06bf8> (a java.lang.ref.Reference$Lock)
	at java.lang.Object.wait(Object.java:502)
	at java.lang.ref.Reference.tryHandlePending(Reference.java:191)
	- locked <0x00000000d8e06bf8> (a java.lang.ref.Reference$Lock)
	at java.lang.ref.Reference$ReferenceHandler.run(Reference.java:153)

   Locked ownable synchronizers:
	- None
```

而jstack除了能显示锁信息外，还能找出一些死锁，例如下面的一段验证死锁的代码：

```kotlin
val a = ReentrantLock()
val b = ReentrantLock()

val latch = CountDownLatch(2)

fun main(args: Array<String>) {

    Thread(Runnable {
        a.lock()
        latch.countDown()
        latch.await()
        b.lock()
        println("a b")
        b.unlock()
        a.unlock()
    }).start()

    Thread(Runnable {
        b.lock()
        latch.countDown()
        latch.await()
        a.lock()
        println("b a")
        a.unlock()
        b.unlock()
    }).start()

    val name = Scanner(System.`in`).next()
    System.out.println("hello $name")
}
```

对应jstack看到的输出，可以看出`Thread-1`持有锁`0x00000000d8feb1a0`，在等待锁`0x00000000d8feb170`；
而`Thread-0`持有锁`0x00000000d8feb170`，在等待锁`0x00000000d8feb1a0`。

而在thread dump的结尾部分，检测到了这次死锁，并给出了对应的两个线程和他们持有以及等待的锁。

```
"Thread-1" #11 prio=5 os_prio=0 tid=0x00007f2064258000 nid=0x31f6 waiting on condition [0x00007f204c24b000]
   java.lang.Thread.State: WAITING (parking)
	at sun.misc.Unsafe.park(Native Method)
	- parking to wait for  <0x00000000d8feb170> (a java.util.concurrent.locks.ReentrantLock$NonfairSync)
	at java.util.concurrent.locks.LockSupport.park(LockSupport.java:175)
	at java.util.concurrent.locks.AbstractQueuedSynchronizer.parkAndCheckInterrupt(AbstractQueuedSynchronizer.java:836)
	at java.util.concurrent.locks.AbstractQueuedSynchronizer.acquireQueued(AbstractQueuedSynchronizer.java:870)
	at java.util.concurrent.locks.AbstractQueuedSynchronizer.acquire(AbstractQueuedSynchronizer.java:1199)
	at java.util.concurrent.locks.ReentrantLock$NonfairSync.lock(ReentrantLock.java:209)
	at java.util.concurrent.locks.ReentrantLock.lock(ReentrantLock.java:285)
	at demo.AppKt$main$2.run(App.kt:32)
	at java.lang.Thread.run(Thread.java:748)

   Locked ownable synchronizers:
	- <0x00000000d8feb1a0> (a java.util.concurrent.locks.ReentrantLock$NonfairSync)

"Thread-0" #10 prio=5 os_prio=0 tid=0x00007f2064255800 nid=0x31f5 waiting on condition [0x00007f204c34c000]
   java.lang.Thread.State: WAITING (parking)
	at sun.misc.Unsafe.park(Native Method)
	- parking to wait for  <0x00000000d8feb1a0> (a java.util.concurrent.locks.ReentrantLock$NonfairSync)
	at java.util.concurrent.locks.LockSupport.park(LockSupport.java:175)
	at java.util.concurrent.locks.AbstractQueuedSynchronizer.parkAndCheckInterrupt(AbstractQueuedSynchronizer.java:836)
	at java.util.concurrent.locks.AbstractQueuedSynchronizer.acquireQueued(AbstractQueuedSynchronizer.java:870)
	at java.util.concurrent.locks.AbstractQueuedSynchronizer.acquire(AbstractQueuedSynchronizer.java:1199)
	at java.util.concurrent.locks.ReentrantLock$NonfairSync.lock(ReentrantLock.java:209)
	at java.util.concurrent.locks.ReentrantLock.lock(ReentrantLock.java:285)
	at demo.AppKt$main$1.run(App.kt:20)
	at java.lang.Thread.run(Thread.java:748)

   Locked ownable synchronizers:
	- <0x00000000d8feb170> (a java.util.concurrent.locks.ReentrantLock$NonfairSync)

......

JNI global references: 12


Found one Java-level deadlock:
=============================
"Thread-1":
  waiting for ownable synchronizer 0x00000000d8feb170, (a java.util.concurrent.locks.ReentrantLock$NonfairSync),
  which is held by "Thread-0"
"Thread-0":
  waiting for ownable synchronizer 0x00000000d8feb1a0, (a java.util.concurrent.locks.ReentrantLock$NonfairSync),
  which is held by "Thread-1"

Java stack information for the threads listed above:
===================================================
"Thread-1":
	at sun.misc.Unsafe.park(Native Method)
	- parking to wait for  <0x00000000d8feb170> (a java.util.concurrent.locks.ReentrantLock$NonfairSync)
	at java.util.concurrent.locks.LockSupport.park(LockSupport.java:175)
	at java.util.concurrent.locks.AbstractQueuedSynchronizer.parkAndCheckInterrupt(AbstractQueuedSynchronizer.java:836)
	at java.util.concurrent.locks.AbstractQueuedSynchronizer.acquireQueued(AbstractQueuedSynchronizer.java:870)
	at java.util.concurrent.locks.AbstractQueuedSynchronizer.acquire(AbstractQueuedSynchronizer.java:1199)
	at java.util.concurrent.locks.ReentrantLock$NonfairSync.lock(ReentrantLock.java:209)
	at java.util.concurrent.locks.ReentrantLock.lock(ReentrantLock.java:285)
	at demo.AppKt$main$2.run(App.kt:32)
	at java.lang.Thread.run(Thread.java:748)
"Thread-0":
	at sun.misc.Unsafe.park(Native Method)
	- parking to wait for  <0x00000000d8feb1a0> (a java.util.concurrent.locks.ReentrantLock$NonfairSync)
	at java.util.concurrent.locks.LockSupport.park(LockSupport.java:175)
	at java.util.concurrent.locks.AbstractQueuedSynchronizer.parkAndCheckInterrupt(AbstractQueuedSynchronizer.java:836)
	at java.util.concurrent.locks.AbstractQueuedSynchronizer.acquireQueued(AbstractQueuedSynchronizer.java:870)
	at java.util.concurrent.locks.AbstractQueuedSynchronizer.acquire(AbstractQueuedSynchronizer.java:1199)
	at java.util.concurrent.locks.ReentrantLock$NonfairSync.lock(ReentrantLock.java:209)
	at java.util.concurrent.locks.ReentrantLock.lock(ReentrantLock.java:285)
	at demo.AppKt$main$1.run(App.kt:20)
	at java.lang.Thread.run(Thread.java:748)

Found 1 deadlock.

```

几个有用的链接，官方文档和实际案例：
[1]: [Thread Dump](https://docs.oracle.com/javase/7/docs/webnotes/tsg/TSG-VM/html/tooldescr.html#gbmpn)
[2]: [怎样分析 JAVA 的 Thread Dumps][https://segmentfault.com/a/1190000000615690]
[3]: [tomcat thread dump 分析][http://www.jiacheo.org/blog/279]
