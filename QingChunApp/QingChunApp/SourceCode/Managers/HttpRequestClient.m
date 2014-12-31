//
//  HttpRequestClient.m
//  QingChunApp
//
//  Created by  李天柱 on 14/12/29.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "HttpRequestClient.h"
#import "SystemConfig.h"
#import "UserConfig.h"

@implementation HttpRequestClient

+ (id)sharedClient
{
    static HttpRequestClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HttpRequestClient alloc] initWithBaseURL:[NSURL URLWithString:[[SystemConfig sharedInstance] GetBaseURLStr]]];
    });
    
    return _sharedClient;
}

+ (void)saveCookieData
{
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookies) {
        // Here I see the correct rails session cookie
        LOG(@"\nSave cookie: \n====================\n%@", cookie);
    }
    
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    [[SystemConfig sharedInstance] SetSession:cookiesData];
}
+ (void)removeCookieData
{
    NSURL *url = [NSURL URLWithString:[[SystemConfig sharedInstance] GetBaseURLStr]];
    if (url) {
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
        for (int i = 0; i < [cookies count]; i++) {
            NSHTTPCookie *cookie = (NSHTTPCookie *)[cookies objectAtIndex:i];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
            LOG(@"\nDelete cookie: \n====================\n%@", cookie);
        }
    }
    [[SystemConfig sharedInstance] RemoveSession];
}

+ (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(HttpRequestType)requestType
                       andBlock:(void (^)(id data, NSError *error))block
{
    [[HttpRequestClient sharedClient] requestJsonDataWithPath:aPath
                                                   withParams:params withMethodType:requestType andBlock:block];
}
+ (void)uploadImage:(UIImage *)image path:(NSString *)path name:(NSString *)name
       successBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
       failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
      progerssBlock:(void (^)(CGFloat progressValue))progress
{
    [[HttpRequestClient sharedClient] uploadImage:image
                                             path:path
                                             name:name
                                     successBlock:success
                                     failureBlock:failure
                                    progerssBlock:progress];
}

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(HttpRequestType)requestType
                       andBlock:(void (^)(id data, NSError *error))block
{
    //log请求数据
    LOG(@"\n===========request===========\n%@:\n%@", aPath, params);
    aPath = [aPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //发起请求
    switch (requestType) {
        case HttpRequestTypeGET:{
            [self GET:aPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                LOG(@"\n%@===========response===========:\n%@", aPath, responseObject);
                id error = [self handleResponse:responseObject];
                if (error) {
                    block(nil, error);
                }else{
                    block(responseObject, nil);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                LOG(@"\n%@===========response===========:\n%@", aPath, error);
                block(nil, error);
            }];
            break;}
        case HttpRequestTypePOST:{
            [self POST:aPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                LOG(@"\n%@===========response===========:\n%@", aPath, responseObject);
                //NSString *shabi =  [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                id error = [self handleResponse:responseObject];
                if (error) {
                    block(nil, error);
                }else{
                    if ([aPath isEqualToString:[[SystemConfig sharedInstance] GetLoginURLStr]]) {
                        [HttpRequestClient saveCookieData];
                    }
                    block(responseObject, nil);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                LOG(@"\n%@===========response===========:\n%@", aPath, error);
                //[self showError:error];
                block(nil, error);
            }];
            break;}
        case HttpRequestTypePUT:{
            [self PUT:aPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                LOG(@"\n%@===========response===========:\n%@", aPath, responseObject);
                id error = [self handleResponse:responseObject];
                if (error) {
                    block(nil, error);
                }else{
                    block(responseObject, nil);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                LOG(@"\n%@===========response===========:\n%@", aPath, error);
                //[self showError:error];
                block(nil, error);
            }];
            break;}
        case HttpRequestTypeDELETE:{
            [self DELETE:aPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                LOG(@"\n%@===========response===========:\n%@", aPath, responseObject);
                id error = [self handleResponse:responseObject];
                if (error) {
                    block(nil, error);
                }else{
                    block(responseObject, nil);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                LOG(@"\n%@===========response===========:\n%@", aPath, error);
                //[self showError:error];
                block(nil, error);
            }];}
        default:
            break;
    }
}

- (void)uploadImage:(UIImage *)image path:(NSString *)path name:(NSString *)name
       successBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
       failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
      progerssBlock:(void (^)(CGFloat progressValue))progress
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    if ((float)data.length/1024 > 1000) {
        data = UIImageJPEGRepresentation(image, 1024*1000.0/(float)data.length);
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *timeStr = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@_%@.jpg", [[UserConfig sharedInstance] GetUserName], timeStr];
    LOG(@"\nuploadImageSize\n%@ : %.0f", fileName, (float)data.length/1024);
    
    AFHTTPRequestOperation *operation = [self POST:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        if (success) {
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
        if (failure) {
            failure(operation, error);
        }
    }];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        CGFloat progressValue = (float)totalBytesWritten/(float)totalBytesExpectedToWrite;
        if (progress) {
            progress(progressValue);
        }
    }];
    [operation start];
}
#pragma mark - private methods
- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    //self.requestSerializer = [AFHTTPRequestSerializer serializer];
    //self.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json",@"text/html", nil];
    
    
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    self.securityPolicy.allowInvalidCertificates = YES;
    
    return self;
}

-(id)handleResponse:(id)responseJSON{
    NSError *error = nil;
    //code为200时，表示正常
    NSNumber *resultCode = [responseJSON valueForKeyPath:@"code"];
    
    if (resultCode.intValue != 200) {
        error = [NSError errorWithDomain:[[SystemConfig sharedInstance] GetBaseURLStr] code:resultCode.intValue userInfo:responseJSON];
        LOG(@"GET Data Error:%@",error.description);
        /*
        if (resultCode.intValue == 1000) {//用户未登录
            [self loginOutToLoginVC];
        }
         */
    }
    
    return error;
}



@end
