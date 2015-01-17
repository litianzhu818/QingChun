//
//  TencentManager.h
//  QingChunApp
//
//  Created by Peter Lee on 15/1/17.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "LTZManager.h"

@class TencentOAuth;
@protocol TencentManagerDelage;

@interface TencentManager : LTZManager

@property (strong, nonatomic, readonly) TencentOAuth *tencentOAuth;

+ (TencentManager *)sharedInstance;
+ (id)allocWithZone:(NSZone *)zone;

- (id)copyWithZone:(NSZone *)zone;

+ (BOOL)HandleOpenURL:(NSURL *)url;

- (void)authorize;
- (void)authorizeInSafari:(BOOL)inSafari;

@end

@protocol TencentManagerDelage <NSObject>

@required

@optional
//即将执行腾讯登录验证
- (void)tencentManager:(TencentManager *)tencentManager willAuthorizeWithTencentOAuth:(TencentOAuth *)tencentOAuth;
//完成腾讯登录验证
- (void)tencentManager:(TencentManager *)tencentManager didCompletedLoginWithTencentOAuth:(TencentOAuth *)tencentOAuth;
//登录成功
- (void)tencentManager:(TencentManager *)tencentManager didLoginSucceedWithTencentOAuth:(TencentOAuth *)tencentOAuth;
//登录失败
- (void)tencentManager:(TencentManager *)tencentManager didLoginFailedWithTencentOAuth:(TencentOAuth *)tencentOAuth;
//没有网络
- (void)tencentManager:(TencentManager *)tencentManager didHasNoNetworkWithTencentOAuth:(TencentOAuth *)tencentOAuth;
//用户取消了登录过程
- (void)tencentManager:(TencentManager *)tencentManager didUserCancelLoginWithTencentOAuth:(TencentOAuth *)tencentOAuth;
//获取到用户的基本信息
- (void)tencentManager:(TencentManager *)tencentManager didGetUserInfoWithTencentOAuth:(TencentOAuth *)tencentOAuth dictionary:(NSDictionary *)userInfoDictionary;

@end
