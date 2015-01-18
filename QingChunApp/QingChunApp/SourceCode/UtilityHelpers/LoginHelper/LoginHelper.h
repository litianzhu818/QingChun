//
//  LoginHelper.h
//  QingChunApp
//
//  Created by Peter Lee on 15/1/17.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "LTZManager.h"

typedef void (^LoginSuccessHandler)(NSUInteger loginType, NSDictionary *userInfoDictionary);
typedef void (^LoginFailureHandler)(NSUInteger loginType, NSError *error);

typedef NS_ENUM(NSUInteger, LoginType) {
    LoginTypeDefault = 0,
    LoginTypeTencent,
    LoginTypeWeibo
};

@class WeiBoManager;
@class TencentManager;
@protocol TencentManagerDelage;
@protocol WeiBoManagerDelegate;

@interface LoginHelper : LTZManager

@property (strong, nonatomic, readonly) WeiBoManager *weiBoManager;
@property (strong, nonatomic, readonly) TencentManager *tencentManager;


+ (LoginHelper *)sharedInstance;
+ (id)allocWithZone:(NSZone *)zone;

- (id)copyWithZone:(NSZone *)zone;

+ (BOOL)HandleOpenURL:(NSURL *)url;

- (void)authorizeWithLoginType:(LoginType)loginType
                       success:(void (^)(LoginType loginType, NSDictionary *userInfoDictionary))success
                       failure:(void (^)(LoginType loginType, NSError *error))failure;

@end

@protocol LoginHelperDelegate <NSObject, TencentManagerDelage, WeiBoManagerDelegate>

@optional

- (void)loginHelper:(LoginHelper *)loginHelper didCompleteSuccessWithLoginType:(LoginType)loginType userInfoDic:(NSDictionary *)userInfoDic;
- (void)loginHelper:(LoginHelper *)loginHelper didCompleteFailureWithLoginType:(LoginType)loginType error:(NSError *)error;

@end

