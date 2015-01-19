//
//  LTZManager.m
//  QingChunApp
//
//  Created by Peter Lee on 15/1/17.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "LTZManager.h"

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

@implementation LTZManager

#pragma mark - object init methods
/**
 * Standard init method.
 **/
- (id)init
{
    return [self initWithDispatchQueue:NULL];
}

/**
 * Designated initializer.
 **/
- (id)initWithDispatchQueue:(dispatch_queue_t)queue
{
    if ((self = [super init]))
    {
        if (queue)
        {
            managerQueue = queue;
#if !OS_OBJECT_USE_OBJC
            dispatch_retain(managerQueue);
#endif
        }
        else
        {
            const char *managerQueueName = [[self managerName] UTF8String];
            managerQueue = dispatch_queue_create(managerQueueName, NULL);
        }
        
        managerQueueTag = &managerQueueTag;
        dispatch_queue_set_specific(managerQueue, managerQueueTag, managerQueueTag, NULL);
        
        multicastDelegate = [[GCDMulticastDelegate alloc] init];
        
    }
    return self;
}
#pragma mark - object dealloc method
- (void)dealloc
{
#if !OS_OBJECT_USE_OBJC
    dispatch_release(managerQueue);
#endif
}

#pragma mark - object properties
- (dispatch_queue_t)managerQueue
{
    return managerQueue;
}

- (void *)managerQueueTag
{
    return managerQueueTag;
}

#pragma mark - object public methods
- (void)addDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue
{
    // Asynchronous operation (if outside xmppQueue)
    
    dispatch_block_t block = ^{
        [multicastDelegate addDelegate:delegate delegateQueue:delegateQueue];
    };
    
    if (dispatch_get_specific(managerQueueTag))
        block();
    else
        dispatch_async(managerQueue, block);
}

- (void)removeDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue synchronously:(BOOL)synchronously
{
    dispatch_block_t block = ^{
        [multicastDelegate removeDelegate:delegate delegateQueue:delegateQueue];
    };
    
    if (dispatch_get_specific(managerQueueTag))
        block();
    else if (synchronously)
        dispatch_sync(managerQueue, block);
    else
        dispatch_async(managerQueue, block);
    
}
- (void)removeDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue
{
    // Synchronous operation (common-case default)
    
    [self removeDelegate:delegate delegateQueue:delegateQueue synchronously:YES];
}

- (void)removeDelegate:(id)delegate
{
    // Synchronous operation (common-case default)
    
    [self removeDelegate:delegate delegateQueue:NULL synchronously:YES];
}

- (NSString *)managerName
{
    // Override me (if needed) to provide a customized manager name.
    // This name is used as the name of the dispatch_queue which could aid in debugging.
    
    return NSStringFromClass([self class]);
}

@end
