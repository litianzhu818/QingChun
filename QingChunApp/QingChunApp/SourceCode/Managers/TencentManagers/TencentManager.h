//
//  TencentManager.h
//  QingChunApp
//
//  Created by Peter Lee on 15/1/17.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "LTZManager.h"
#import "SingletonManager.h"

@class TencentOAuth;
@protocol TencentManagerDelage;

@interface TencentManager : LTZManager

@property (strong, nonatomic, readonly) TencentOAuth *tencentOAuth;

Single_interface(TencentManager);

- (void)authorize;
- (void)authorizeInSafari:(BOOL)inSafari;

@end

@protocol TencentManagerDelage <NSObject>

@required

@optional

- (void)tencentManager:(TencentManager *)tencentManager willAuthorizeWithTencentOAuth:(TencentOAuth *)tencentOAuth;
- (void)tencentManager:(TencentManager *)tencentManager didCompletedLoginWithTencentOAuth:(TencentOAuth *)tencentOAuth;
- (void)tencentManager:(TencentManager *)tencentManager didLoginSucceedWithTencentOAuth:(TencentOAuth *)tencentOAuth;
- (void)tencentManager:(TencentManager *)tencentManager didLoginFailedWithTencentOAuth:(TencentOAuth *)tencentOAuth;
- (void)tencentManager:(TencentManager *)tencentManager didHasNoNetworkWithTencentOAuth:(TencentOAuth *)tencentOAuth;
- (void)tencentManager:(TencentManager *)tencentManager didUserCancelLoginWithTencentOAuth:(TencentOAuth *)tencentOAuth;
@end
