//
//  SLQLRunloop.m
//  textKit
//
//  Created by duha on 2017/12/7.
//  Copyright © 2017年 monph. All rights reserved.
//

#import "SLQLRunloop.h"

@interface SLQLRunloopSource:NSObject {
    
}

@property (nonatomic, copy) void (^blockSource)(), (^registerSource)(SLQLRunloopSource *), (^unregisterSource)(), (^blockSourceOver)(SLQLRunloopSource *);
@end

@implementation SLQLRunloopSource
@end

@interface SLQLRunloop () {
    CFRunLoopRef loopRef;
}

@end

@implementation SLQLRunloop

+ (SLQLRunloop *)runloop {
    static dispatch_once_t onceToken;
    static SLQLRunloop *loop = nil;
    
    dispatch_once(&onceToken, ^{
        loop = [SLQLRunloop new];
        [loop run];
    });
    
    return loop;
}

- (id)init {
    if(self = [super init]) {
        loopRef = nil;
    }
    
    return self;
}

- (void)run {
    dispatch_queue_t queue = dispatch_queue_create("SLQLRunloop", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSRunLoopCommonModes];
        loopRef = CFRunLoopGetCurrent();
        
        while(true) {
            @autoreleasepool {
                CFRunLoopRun();
            };
        }
    });
}

//当source添加进runloop的时候，调用此回调方法 <== CFRunLoopAddSource(runLoop, source, mode);
void RunLoopSourceScheduleRoutine (void *info, CFRunLoopRef rl, CFStringRef mode){
    SLQLRunloopSource *source = (__bridge SLQLRunloopSource *)(info);
    
    if(source.registerSource) {
        source.registerSource(source);
    }
}

// Listing 3-5 Performing work in the input source
//当sourcer接收到消息的时候，调用此回调方法(CFRunLoopSourceSignal(source);CFRunLoopWakeUp(runLoop);
void RunLoopSourcePerformRoutine (void *info) {
    SLQLRunloopSource *source = (__bridge SLQLRunloopSource *)(info);
    
    if(source.blockSource) {
        source.blockSource();
    }
    
    if(source.blockSourceOver) {
        source.blockSourceOver(source);
    }
}

// Listing 3-6 Invalidating an input source ＝＝
//当source 从runloop里删除的时候，调用此回调方法 <== CFRunLoopRemoveSource(runLoop, source, mode);
void RunLoopSourceCancelRoutine (void *info, CFRunLoopRef rl, CFStringRef mode) {
    SLQLRunloopSource *source = (__bridge_transfer SLQLRunloopSource *)(info);
    
    if(source.unregisterSource) {
        source.unregisterSource();
    }
}

- (void)asyncRun:(void (^)())block {
    SLQLRunloopSource *source = [SLQLRunloopSource new];
    source.blockSource = block;
    
    CFRunLoopSourceContext context = {0, (__bridge_retained void *)(source), NULL, NULL, NULL, NULL, NULL,
        &RunLoopSourceScheduleRoutine,
        &RunLoopSourceCancelRoutine,
        &RunLoopSourcePerformRoutine};
    CFRunLoopSourceRef runLoopSource = CFRunLoopSourceCreate(NULL, 0, &context);
    
    source.registerSource = ^(SLQLRunloopSource *sr){
    };
    
    source.blockSourceOver = ^(SLQLRunloopSource *sr){
        CFRunLoopRemoveSource(loopRef, runLoopSource, kCFRunLoopDefaultMode);
    };
    
    while (!loopRef) {
        usleep(5000);
    }
    
    CFRunLoopAddSource(loopRef, runLoopSource, kCFRunLoopDefaultMode);
    CFRunLoopSourceSignal(runLoopSource);
    CFRunLoopWakeUp(loopRef);
}

@end
