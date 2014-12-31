//
//  HttpSessionClient.h
//  AFNetworking iOS Example
//
//  Created by Peter Lee on 14/12/31.
//  Copyright (c) 2014年 Gowalla. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

typedef NS_ENUM(NSUInteger, HttpSessionType) {
    HttpSessionTypeGET = 0,
    HttpSessionTypePOST,
    HttpSessionTypePUT,
    HttpSessionTypeDELETE
};

@interface HttpSessionClient : AFHTTPSessionManager


+ (instancetype)sharedClient;

+ (void)saveCookieData;
+ (void)removeCookieData;

+ (id)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(HttpSessionType)sessionType
                       andBlock:(void (^)(id data, NSError *error))block;

+ (void)uploadImage:(UIImage *)image
               path:(NSString *)path
               name:(NSString *)name
       successBlock:(void (^)(NSURLSessionDataTask *task, id responseObject))success
       failureBlock:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
      progerssBlock:(void (^)(CGFloat progressValue))progress;

- (NSURLSessionDataTask *)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(HttpSessionType)sessionType
                       andBlock:(void (^)(id data, NSError *error))block;

- (void)uploadImage:(UIImage *)image
               path:(NSString *)path
               name:(NSString *)name
       successBlock:(void (^)(NSURLSessionDataTask *task, id responseObject))success
       failureBlock:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
      progerssBlock:(void (^)(CGFloat progressValue))progress;


@end
