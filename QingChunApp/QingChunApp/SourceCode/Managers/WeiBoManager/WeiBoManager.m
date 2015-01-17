//
//  WeiBoManager.m
//  QingChunApp
//
//  Created by Peter Lee on 15/1/17.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "WeiBoManager.h"
#import "WeiboSDK.h"

@interface WeiBoManager ()<WeiboSDKDelegate>
{
    WeiboSDK *_weiboSDK;
}
@end

@implementation WeiBoManager

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Singleton class methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
static WeiBoManager *sharedInstance = nil;

+ (WeiBoManager *)sharedInstance
{
    @synchronized (self){
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super allocWithZone:zone];
    });
    return sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone
{
    @synchronized (self){
        if (sharedInstance == nil) {
            sharedInstance = [[WeiBoManager alloc] init];
        }
    }
    return sharedInstance;
}

+ (BOOL)HandleOpenURL:(NSURL *)url
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

/**
 * Designated initializer.
 **/
- (id)initWithDispatchQueue:(dispatch_queue_t)queue
{
    if ((self = [super initWithDispatchQueue:queue]))
    {
        //[self initParameters];
    }
    return self;
}

- (WeiboSDK *)weiboSDK
{
    __block WeiboSDK *result = nil;
    
    dispatch_block_t block = ^{
        
        result = _weiboSDK;
    };
    
    if (dispatch_get_specific(managerQueueTag))
        block();
    else
        dispatch_sync(managerQueue, block);
    
    return result;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - object public methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)authorize
{

}
- (void)authorizeInSafari:(BOOL)inSafari
{

}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - WeiboSDKDelegate methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/**
 收到一个来自微博客户端程序的请求
 
 收到微博的请求后，第三方应用应该按照请求类型进行处理，处理完后必须通过 [WeiboSDK sendResponse:] 将结果回传给微博
 @param request 具体的请求对象
 */
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{

}

/**
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{

}
@end
