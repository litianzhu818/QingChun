//
//  TencentManager.m
//  QingChunApp
//
//  Created by Peter Lee on 15/1/17.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "TencentManager.h"
#import <TencentOpenAPI/TencentOpenSDK.h>
#import "OtherSDKInfo.h"

@interface TencentManager ()<TencentSessionDelegate>
{
    TencentOAuth            *_tencentOAuth;
    NSArray                 *_permissions;
}
@end

@implementation TencentManager

Single_implementation(TencentManager);

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
        dispatch_sync(managerQueue, block);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark properties
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (TencentOAuth *)tencentOAuth
{
    __block TencentOAuth *result = nil;
    
    dispatch_block_t block = ^{
        
        result = _tencentOAuth;
    };
    
    if (dispatch_get_specific(managerQueueTag))
        block();
    else
        dispatch_sync(managerQueue, block);
    
    return result;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark object public methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)authorize
{
    [self authorizeInSafari:NO];
}

- (void)authorizeInSafari:(BOOL)inSafari
{
    dispatch_block_t block = ^{
        
        [multicastDelegate tencentManager:self willAuthorizeWithTencentOAuth:self.tencentOAuth];
        
        [self.tencentOAuth authorize:_permissions inSafari:inSafari];
    };
    
    if (dispatch_get_specific(managerQueueTag))
        block();
    else
        dispatch_sync(managerQueue, block);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark object private methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)_initParameters
{
    if (!dispatch_get_specific(managerQueueTag)) return;
    
    if (!_tencentOAuth) {
        _tencentOAuth = ({
            TencentOAuth *tencentOAuth = [[TencentOAuth alloc] initWithAppId:TenCentAppID andDelegate:self];
            tencentOAuth.redirectURI = @"www.qq.com";//www.qcd.me
            tencentOAuth;
        });
    }
    
    if (!_permissions) {
        _permissions = ({
            NSArray *permissions =  [NSArray arrayWithObjects:
                                     kOPEN_PERMISSION_GET_USER_INFO,
                                     kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                     kOPEN_PERMISSION_ADD_ALBUM,
                                     kOPEN_PERMISSION_ADD_IDOL,
                                     kOPEN_PERMISSION_ADD_ONE_BLOG,
                                     kOPEN_PERMISSION_ADD_PIC_T,
                                     kOPEN_PERMISSION_ADD_SHARE,
                                     kOPEN_PERMISSION_ADD_TOPIC,
                                     kOPEN_PERMISSION_CHECK_PAGE_FANS,
                                     kOPEN_PERMISSION_DEL_IDOL,
                                     kOPEN_PERMISSION_DEL_T,
                                     kOPEN_PERMISSION_GET_FANSLIST,
                                     kOPEN_PERMISSION_GET_IDOLLIST,
                                     kOPEN_PERMISSION_GET_INFO,
                                     kOPEN_PERMISSION_GET_OTHER_INFO,
                                     kOPEN_PERMISSION_GET_REPOST_LIST,
                                     kOPEN_PERMISSION_LIST_ALBUM,
                                     kOPEN_PERMISSION_UPLOAD_PIC,
                                     kOPEN_PERMISSION_GET_VIP_INFO,
                                     kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                                     kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
                                     kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
                                     nil];
            permissions;
        });
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark TencentSessionDelegate methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//TeccentLoginDelegate methods
- (void)tencentDidLogin
{
    LOG(@"%@",@"登录完成");
    [multicastDelegate tencentManager:self didCompletedLoginWithTencentOAuth:self.tencentOAuth];
    
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        //  记录登录用户的OpenID、Token以及过期时间
        LOG(@"Token===>%@",_tencentOAuth.accessToken);
    }
    else
    {
        LOG(@"%@",@"登录不成功 没有获取accesstoken");
    }
}

//TencentSessionDelegate methods
-(void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled)
    {
        //_labelTitle.text = @"用户取消登录";
    }
    else
    {
        //_labelTitle.text = @"登录失败";
    }
}

//TencentSessionDelegate methods
-(void)tencentDidNotNetWork
{
    LOG(@"%@",@"无网络连接，请设置网络");
} 

@end
