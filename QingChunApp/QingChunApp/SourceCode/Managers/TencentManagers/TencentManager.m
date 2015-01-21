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
    NSMutableDictionary     *_loginUserInfo;
}
@end

@implementation TencentManager

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Singleton class methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
static TencentManager *sharedInstance = nil;

+ (TencentManager *)sharedInstance
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
            sharedInstance = [[TencentManager alloc] init];
        }
    }
    return sharedInstance;
}

+ (BOOL)HandleOpenURL:(NSURL *)url
{
    return [TencentOAuth HandleOpenURL:url];
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
        dispatch_async(managerQueue, block);
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
        
        if (!_loginUserInfo) {
            _loginUserInfo = [NSMutableDictionary dictionary];
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark TencentSessionDelegate methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//TeccentLoginDelegate methods
- (void)tencentDidLogin
{
    //登录完成
    [multicastDelegate tencentManager:self didCompletedLoginWithTencentOAuth:self.tencentOAuth];
    
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length]){
        //记录登录用户的OpenID、Token以及过期时间
        LOG(@"Token===>%@\nOpneid===>%@",_tencentOAuth.accessToken,_tencentOAuth.openId);
        [_loginUserInfo setObject:_tencentOAuth.accessToken forKey:@"token"];
        [_loginUserInfo setObject:_tencentOAuth.openId forKey:@"openid"];
        //获取用户基本信息
        [self.tencentOAuth getUserInfo];
        [multicastDelegate tencentManager:self didLoginSucceedWithTencentOAuth:self.tencentOAuth];
    }else{
        //登录不成功 没有获取accesstoken
        [multicastDelegate tencentManager:self didLoginFailedWithTencentOAuth:self.tencentOAuth];
    }
}

//TencentSessionDelegate methods
-(void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled){
        //用户取消登录
        [multicastDelegate tencentManager:self didUserCancelLoginWithTencentOAuth:self.tencentOAuth];
    }else{
        //登录失败
        [multicastDelegate tencentManager:self didLoginFailedWithTencentOAuth:self.tencentOAuth];
    }
}

//TencentSessionDelegate methods
-(void)tencentDidNotNetWork
{
    LOG(@"%@",@"无网络连接，请设置网络");
    [multicastDelegate tencentManager:self didHasNoNetworkWithTencentOAuth:self.tencentOAuth];
}
//Get the user sample info
- (void)getUserInfoResponse:(APIResponse*) response
{
    NSDictionary *tempDic = response.jsonResponse;
    [_loginUserInfo setObject:[NSNumber numberWithInteger:[[tempDic objectForKey:@"gender"] isEqualToString:@"男"] ? 1:2] forKey:@"sex"];
    [_loginUserInfo setObject:[tempDic objectForKey:@"figureurl_qq_2"] forKey:@"img"];
    [_loginUserInfo setObject:[tempDic objectForKey:@"nickname"] forKey:@"userName"];
    [_loginUserInfo  setObject:[NSNumber numberWithInteger:2] forKey:@"type"];
    [_loginUserInfo  setObject:@"http://www.qcd.me" forKey:@"url"];
    [multicastDelegate tencentManager:self didGetUserInfoWithTencentOAuth:self.tencentOAuth dictionary:_loginUserInfo];
}

@end
