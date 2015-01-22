//
//  WeiBoManager.m
//  QingChunApp
//
//  Created by Peter Lee on 15/1/17.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "WeiBoManager.h"
#import "WeiboSDK.h"
#import "WeiboUser.h"
#import "OtherSDKInfo.h"
#import "WBHttpRequest+WeiboUser.h"

@interface WeiBoManager () <WeiboSDKDelegate>
{
    WeiboSDK                *_weiboSDK;
    NSMutableDictionary     *_loginUserInfo;
    
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
    return [[WeiBoManager sharedInstance] HandleOpenURL:url];
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
#pragma mark object private methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)_initParameters
{
    if (!dispatch_get_specific(managerQueueTag)) return;
    
    if (!_loginUserInfo) {
        _loginUserInfo = [NSMutableDictionary dictionary];
    }
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:WeiBoAppID];
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - object public methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)authorize
{
    [self authorizeInSafari:NO];
}
- (void)authorizeInSafari:(BOOL)inSafari
{
    dispatch_block_t block = ^{
        
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = @"https://api.weibo.com/oauth2/default.html";
        request.scope = @"all";
        request.userInfo = @{@"SSO_From": @"QingChunDou",
                             @"Other_Info_1": [NSNumber numberWithInt:123],
                             @"Other_Info_2": @[@"obj1", @"obj2"],
                             @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
        
        [multicastDelegate weiBoManager:self willAuthorizeWithWBAuthorizeRequest:request];
        
        [WeiboSDK sendRequest:request];
    };
    
    if (dispatch_get_specific(managerQueueTag))
        block();
    else
        dispatch_async(managerQueue, block);
}

- (BOOL)HandleOpenURL:(NSURL *)url
{
    return [WeiboSDK handleOpenURL:url delegate:self];
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
    //暂时未实现
}

/**
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]){
        /*
        NSString *title = NSLocalizedString(@"发送结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        if (accessToken)
        {
            self.wbtoken = accessToken;
        }
        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        if (userID) {
            self.wbCurrentUserID = userID;
        }
        [alert show];
        [alert release];
         
         */
    }else if ([response isKindOfClass:WBAuthorizeResponse.class]){
        
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess){//成功
            
            //[(WBAuthorizeResponse *)response accessToken];
            //[(WBAuthorizeResponse *)response userID];
            
            [_loginUserInfo setObject:[(WBAuthorizeResponse *)response accessToken] forKey:@"token"];
            [_loginUserInfo setObject:[(WBAuthorizeResponse *)response userID] forKey:@"openid"];
            
            //请求用户信息
            [WBHttpRequest requestForUserProfile:[(WBAuthorizeResponse *)response userID]
                                 withAccessToken:[(WBAuthorizeResponse *)response accessToken]
                              andOtherProperties:nil
                                           queue:nil
                           withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
                               
                               if (!error) {
                                   
                                    WeiboUser *user = result;
                                   
                                   [_loginUserInfo setObject:[NSNumber numberWithInteger:[user.gender isEqualToString:@"m"] ? 1:2] forKey:@"sex"];
                                   [_loginUserInfo setObject:user.avatarLargeUrl forKey:@"img"];
                                   [_loginUserInfo setObject:user.screenName forKey:@"userName"];
                                   [_loginUserInfo  setObject:[NSNumber numberWithInteger:4] forKey:@"type"];
                                   [_loginUserInfo  setObject:user.profileUrl forKey:@"url"];
                                   [multicastDelegate weiBoManager:self didGetUserInfoWithWithWeiboUser:user dictionary:_loginUserInfo];
                               }
                            
                           }];
            
        }else if (response.statusCode == WeiboSDKResponseStatusCodeAuthDeny){//授权失败
            [multicastDelegate weiBoManager:self didLoginFailedWithWithWBAuthorizeResponse:(WBAuthorizeResponse *)response];
        }else if (response.statusCode == WeiboSDKResponseStatusCodeUserCancel){//用户取消发送
            [multicastDelegate weiBoManager:self didUserCancelLoginWithWithWBAuthorizeResponse:(WBAuthorizeResponse *)response];
        }else if (response.statusCode == WeiboSDKResponseStatusCodeSentFail){//发送失败
            [multicastDelegate weiBoManager:self didLoginFailedWithWithWBAuthorizeResponse:(WBAuthorizeResponse *)response];
        }else if (response.statusCode == WeiboSDKResponseStatusCodeUserCancelInstall){//用户取消安装微博客户端
            [multicastDelegate weiBoManager:self didUserCancelLoginWithWithWBAuthorizeResponse:(WBAuthorizeResponse *)response];
        }
        
    }else if ([response isKindOfClass:WBPaymentResponse.class]){
        /*
        NSString *title = NSLocalizedString(@"支付结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.payStatusCode: %@\nresponse.payStatusMessage: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBPaymentResponse *)response payStatusCode], [(WBPaymentResponse *)response payStatusMessage], NSLocalizedString(@"响应UserInfo数据", nil),response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
         
         */
    }
}
@end
