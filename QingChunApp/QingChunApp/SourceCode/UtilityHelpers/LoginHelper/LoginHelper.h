//
//  LoginHelper.h
//  QingChunApp
//
//  Created by Peter Lee on 15/1/17.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "LTZManager.h"

typedef void (^CompleteHandler)(NSUInteger loginType, id userInfo, NSError *error);

typedef NS_ENUM(NSUInteger, LoginType) {
    LoginTypeDefault = 0,
    LoginTypeTencent,
    LoginTypeWeibo
};

typedef NS_ENUM(NSUInteger, LoginErrorCode) {
    LoginErrorCodeNoNetwork = -1000,
    LoginErrorCodeUserCancel,
    LoginErrorCodeFailed
};

#define CustomLoginErrorDomain @"com.qcd.login.error"

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
completeHandler:(void (^)(LoginType loginType, id userInfo, NSError *error))completeHandler;

- (void)authorizeWithID:(NSString *)loginID
               password:(NSString *)password
        completeHandler:(void (^)(LoginType loginType, id userInfo, NSError *error))completeHandler;

@end

@protocol LoginHelperDelegate <NSObject, TencentManagerDelage, WeiBoManagerDelegate>

@optional

- (void)loginHelper:(LoginHelper *)loginHelper didCompleteSuccessWithLoginType:(LoginType)loginType userInfoDic:(NSDictionary *)userInfoDic;
- (void)loginHelper:(LoginHelper *)loginHelper didCompleteFailureWithLoginType:(LoginType)loginType error:(NSError *)error;

@end

