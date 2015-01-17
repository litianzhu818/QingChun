//
//  HttpRequestClient.h
//  QingChunApp
//
//  Created by  李天柱 on 14/12/29.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

typedef NS_ENUM(NSUInteger, HttpRequestType) {
    HttpRequestTypeGET = 0,
    HttpRequestTypePOST,
    HttpRequestTypePUT,
    HttpRequestTypeDELETE
};

@interface HttpRequestClient : AFHTTPRequestOperationManager

+ (id)sharedClient;
+ (void)saveCookieData;
+ (void)removeCookieData;

+ (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(HttpRequestType)requestType
                       andBlock:(void (^)(id data, NSError *error))block;
+ (void)uploadImage:(UIImage *)image path:(NSString *)path name:(NSString *)name
       successBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
       failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
      progerssBlock:(void (^)(CGFloat progressValue))progress;

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(HttpRequestType)requestType
                       andBlock:(void (^)(id data, NSError *error))block;

- (void)uploadImage:(UIImage *)image path:(NSString *)path name:(NSString *)name
       successBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
       failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
      progerssBlock:(void (^)(CGFloat progressValue))progress;

@end
