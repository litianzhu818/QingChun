//
//  LoginHelper.m
//  QingChunApp
//
//  Created by Peter Lee on 15/1/17.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "LoginHelper.h"
#import "WeiBoManager.h"
#import "TencentManager.h"
#import "LTZLocationManager.h"
#import "OtherSDKInfo.h"

@interface LoginHelper ()<WeiBoManagerDelegate, TencentManagerDelage>
{
    WeiBoManager                *_weiBoManager;
    TencentManager              *_tencentManager;
    
    CompleteHandler             _completeHandler;
}
@end

@implementation LoginHelper

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Singleton class methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
static LoginHelper *sharedInstance = nil;

+ (LoginHelper *)sharedInstance
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
            sharedInstance = [[LoginHelper alloc] init];
        }
    }
    return sharedInstance;
}
+ (BOOL)HandleOpenURL:(NSURL *)url
{
    BOOL result = NO;
    
    if (!url) return result;
    
    if ([[url scheme] isEqualToString:WeiBoAppURLScheme]) {
        result = [WeiBoManager HandleOpenURL:url];
    }else if ([[url scheme] isEqualToString:TenCentAppURLScheme]){
        result = [TencentManager HandleOpenURL:url];
    }
    
    return result;
}

/**
 * Designated initializer.
 **/
- (id)initWithDispatchQueue:(dispatch_queue_t)queue
{
    if ((self = [super initWithDispatchQueue:queue]))
    {
        [self initParameters];
    }
    return self;
}

- (void)initParameters
{
    dispatch_block_t block = ^{ @autoreleasepool {
        
        [self _initParameters];
        
    }};
    
    if (dispatch_get_specific(managerQueueTag))
        block();
    else
        dispatch_async(managerQueue, block);
}

#pragma mark - object dealloc method
- (void)dealloc
{
    [self.tencentManager removeDelegate:self];
    [self.weiBoManager removeDelegate:self];
    
    _completeHandler = NULL;
    
    _tencentManager = nil;
    _weiBoManager = nil;
    
#if !OS_OBJECT_USE_OBJC
    dispatch_release(managerQueue);
#endif
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark properties
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (WeiBoManager *)weiBoManager
{
    __block WeiBoManager *result = nil;
    
    dispatch_block_t block = ^{
        
        result = _weiBoManager;
    };
    
    if (dispatch_get_specific(managerQueueTag))
        block();
    else
        dispatch_sync(managerQueue, block);
    
    return result;
}

- (TencentManager *)tencentManager
{
    __block TencentManager *result = nil;
    
    dispatch_block_t block = ^{
        
        result = _tencentManager;
    };
    
    if (dispatch_get_specific(managerQueueTag))
        block();
    else
        dispatch_sync(managerQueue, block);
    
    return result;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark object private methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)_initParameters
{
    if (!dispatch_get_specific(managerQueueTag)) return;
    
    if (!_tencentManager) {
        _tencentManager = ({
            TencentManager *tencentManager = [[TencentManager alloc] initWithDispatchQueue:managerQueue];
            [tencentManager addDelegate:self delegateQueue:managerQueue];
            tencentManager;
        });
    }
    
    if (!_weiBoManager) {
        _weiBoManager = ({
            WeiBoManager *weiBoManager = [[WeiBoManager alloc] initWithDispatchQueue:managerQueue];
            [weiBoManager addDelegate:self delegateQueue:managerQueue];
            weiBoManager;
        });
    }
    
}

static inline NSError *ErrorFactory(LoginErrorCode loginErrorCode, NSString *description) {
    
    NSError *error = nil;
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:description                                                                      forKey:NSLocalizedDescriptionKey];
    error = [NSError errorWithDomain:CustomLoginErrorDomain code:loginErrorCode userInfo:userInfo];
    
    return error;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - object public methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)authorizeWithID:(NSString *)loginID
               password:(NSString *)password
        completeHandler:(void (^)(LoginType loginType, id userInfo, NSError *error))completeHandler
{

}
- (void)authorizeWithLoginType:(LoginType)loginType
               completeHandler:(void (^)(LoginType loginType, id userInfo, NSError *error))completeHandler
{
    dispatch_block_t block = ^{ @autoreleasepool {
        
        _completeHandler = completeHandler;
        
        if (loginType == LoginTypeTencent) {
            [self.tencentManager authorize];
        }else if (loginType == LoginTypeWeibo){
            [self.weiBoManager authorize];
        }
        
    }};
    
    if (dispatch_get_specific(managerQueueTag))
        block();
    else
        dispatch_async(managerQueue, block);
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - TencentManagerDelegate methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//登录成功
- (void)tencentManager:(TencentManager *)tencentManager didLoginSucceedWithTencentOAuth:(TencentOAuth *)tencentOAuth
{
    
}
//登录失败
- (void)tencentManager:(TencentManager *)tencentManager didLoginFailedWithTencentOAuth:(TencentOAuth *)tencentOAuth
{
    NSError *error = ErrorFactory(LoginErrorCodeFailed, @"login with no token information.");
    
    _completeHandler(LoginTypeTencent,nil,error);
}
//没有网络
- (void)tencentManager:(TencentManager *)tencentManager didHasNoNetworkWithTencentOAuth:(TencentOAuth *)tencentOAuth
{
    NSError *error = ErrorFactory(LoginErrorCodeNoNetwork, @"login with no network.");
    
    _completeHandler(LoginTypeTencent,nil,error);
}
//用户取消了登录过程
- (void)tencentManager:(TencentManager *)tencentManager didUserCancelLoginWithTencentOAuth:(TencentOAuth *)tencentOAuth
{
    NSError *error = ErrorFactory(LoginErrorCodeUserCancel, @"login paused with user's cancel.");
    
    _completeHandler(LoginTypeTencent,nil,error);
}
//获取到用户的基本信息
- (void)tencentManager:(TencentManager *)tencentManager didGetUserInfoWithTencentOAuth:(TencentOAuth *)tencentOAuth dictionary:(id)userInfo
{
    _completeHandler(LoginTypeTencent, userInfo, nil);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - WeiBoManagerDelegate methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


@end
