//
//  WeiBoManager.h
//  QingChunApp
//
//  Created by Peter Lee on 15/1/17.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "LTZManager.h"

@class WeiboSDK;
@class WeiboUser;
@class WBAuthorizeRequest;
@class WBAuthorizeResponse;
@protocol WeiboSDKDelegate;

@interface WeiBoManager : LTZManager

@property (strong, nonatomic, readonly) WeiboSDK *weiboSDK;


+ (WeiBoManager *)sharedInstance;
+ (id)allocWithZone:(NSZone *)zone;

- (id)copyWithZone:(NSZone *)zone;

+ (BOOL)HandleOpenURL:(NSURL *)url;

- (void)authorize;
- (void)authorizeInSafari:(BOOL)inSafari;

@end

@protocol WeiBoManagerDelegate <NSObject>

@required

@optional

//- (void)weiBoManager:(WeiBoManager *)weiBoManager
//即将执行微博登录验证
- (void)weiBoManager:(WeiBoManager *)weiBoManager willAuthorizeWithWBAuthorizeRequest:(WBAuthorizeRequest *)equest;

//完成微博登录验证
- (void)weiBoManager:(WeiBoManager *)weiBoManager didCompletedLoginWithWBAuthorizeResponse:(WBAuthorizeResponse *)response;
//登录成功
- (void)weiBoManager:(WeiBoManager *)weiBoManager didLoginSucceedWithWithWBAuthorizeResponse:(WBAuthorizeResponse *)response;
//登录失败
- (void)weiBoManager:(WeiBoManager *)weiBoManager didLoginFailedWithWithWBAuthorizeResponse:(WBAuthorizeResponse *)response;
//没有网络
- (void)weiBoManager:(WeiBoManager *)weiBoManager didHasNoNetworkWithWithWBAuthorizeResponse:(WBAuthorizeResponse *)response;
//用户取消了登录过程
- (void)weiBoManager:(WeiBoManager *)weiBoManager didUserCancelLoginWithWithWBAuthorizeResponse:(WBAuthorizeResponse *)response;
//获取到用户的基本信息
- (void)weiBoManager:(WeiBoManager *)weiBoManager didGetUserInfoWithWithWeiboUser:(WeiboUser *)user dictionary:(id)userInfo;
@end
