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
    
    LoginSuccessHandler         _loginSuccessHandler;
    LoginFailureHandler         _loginFailureHandler;
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
    
    _loginFailureHandler = NULL;
    _loginSuccessHandler = NULL;
    
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
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - object public methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)authorizeWithLoginType:(LoginType)loginType
                       success:(void (^)(LoginType loginType, NSDictionary *userInfoDictionary))success
                       failure:(void (^)(LoginType loginType, NSError *error))failure
{
    dispatch_block_t block = ^{ @autoreleasepool {
        
        _loginSuccessHandler = success;
        _loginFailureHandler = failure;
        
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
    
}
//没有网络
- (void)tencentManager:(TencentManager *)tencentManager didHasNoNetworkWithTencentOAuth:(TencentOAuth *)tencentOAuth
{
    
}
//用户取消了登录过程
- (void)tencentManager:(TencentManager *)tencentManager didUserCancelLoginWithTencentOAuth:(TencentOAuth *)tencentOAuth
{
    
}
//获取到用户的基本信息
- (void)tencentManager:(TencentManager *)tencentManager didGetUserInfoWithTencentOAuth:(TencentOAuth *)tencentOAuth dictionary:(NSDictionary *)userInfoDictionary
{
    
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - WeiBoManagerDelegate methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


@end
