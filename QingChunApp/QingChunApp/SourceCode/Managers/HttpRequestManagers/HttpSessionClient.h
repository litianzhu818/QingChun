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


+ (id)sharedClient;

// operate the cookie data
+ (void)saveCookieData;
+ (void)removeCookieData;

+ (id)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(HttpSessionType)sessionType
                       andBlock:(void (^)(id data, NSError *error))block;

+ (id)uploadImage:(UIImage *)image
             path:(NSString *)path
             name:(NSString *)name
       withParams:(NSDictionary*)params
         progress:(NSProgress * __autoreleasing *)progress
     successBlock:(void (^)(NSURLSessionUploadTask *task, id responseObject))success
     failureBlock:(void (^)(NSURLSessionUploadTask *task, NSError *error))failure;


- (NSURLSessionDataTask *)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(HttpSessionType)sessionType
                       andBlock:(void (^)(id data, NSError *error))block;

- (NSURLSessionUploadTask *)uploadImage:(UIImage *)image
                                   path:(NSString *)path
                                   name:(NSString *)name
                             withParams:(NSDictionary*)params
                               progress:(NSProgress * __autoreleasing *)progress
                           successBlock:(void (^)(NSURLSessionUploadTask *task, id responseObject))success
                           failureBlock:(void (^)(NSURLSessionUploadTask *task, NSError *error))failure;


@end
