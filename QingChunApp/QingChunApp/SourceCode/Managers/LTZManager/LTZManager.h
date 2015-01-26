//
//  LTZManager.h
//  QingChunApp
//
//  Created by Peter Lee on 15/1/17.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDMulticastDelegate.h"

#define RETURN_WITH_QUEUE_TAG(managerQueueTag) if (!dispatch_get_specific(managerQueueTag)) return;

@interface LTZManager : NSObject
{
    dispatch_queue_t            managerQueue;
    void                        *managerQueueTag;
    
    id                          multicastDelegate;
}

@property (readonly) dispatch_queue_t managerQueue;
@property (readonly) void *managerQueueTag;

- (id)init;
- (id)initWithDispatchQueue:(dispatch_queue_t)queue;

- (void)addDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;
- (void)removeDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;
- (void)removeDelegate:(id)delegate;

- (NSString *)managerName;

@end
