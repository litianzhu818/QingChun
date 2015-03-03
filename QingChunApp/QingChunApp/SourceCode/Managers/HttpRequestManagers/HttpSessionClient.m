//
//  HttpSessionClient.m
//  AFNetworking iOS Example
//
//  Created by Peter Lee on 14/12/31.
//  Copyright (c) 2014年 Gowalla. All rights reserved.
//

#import "HttpSessionClient.h"
#import "SystemConfig.h"
#import "UserConfig.h"

@implementation HttpSessionClient

+ (id)sharedClient
{
    static HttpSessionClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HttpSessionClient alloc] initWithBaseURL:[NSURL URLWithString:[[SystemConfig sharedInstance] GetBaseURLStr]]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
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


#pragma mark - private methods

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json",@"text/html", nil];
        
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        self.securityPolicy.allowInvalidCertificates = YES;
    }
    
    return self;
}

-(id)handleResponse:(id)responseJSON
{
    NSError *error = nil;
    //code为200时，表示正常
    NSNumber *resultCode = [responseJSON valueForKeyPath:@"code"];

    if (resultCode.intValue != 200) {
        error = [NSError errorWithDomain:[[SystemConfig sharedInstance] GetBaseURLStr] code:resultCode.intValue userInfo:responseJSON];
        NSLog(@"get Data Error:%@",error.description);
        /*
         //6104为无排行
         //1110加密KEY错误
         if (resultCode.intValue == 1000) {//用户未登录
         [self loginOutToLoginVC];
         }
         */
    }
    
    return error;
}

#pragma mark - class public request method
+ (id)requestJsonDataWithPath:(NSString *)aPath
                   withParams:(NSDictionary*)params
               withMethodType:(HttpSessionType)sessionType
                     andBlock:(void (^)(id data, NSError *error))block
{
    return [[HttpSessionClient sharedClient] requestJsonDataWithPath:aPath
                                                          withParams:params
                                                      withMethodType:sessionType
                                                            andBlock:block];
}


#pragma mark - public request method

- (NSURLSessionDataTask *)requestJsonDataWithPath:(NSString *)aPath
                                       withParams:(NSDictionary*)params
                                   withMethodType:(HttpSessionType)sessionType
                                         andBlock:(void (^)(id data, NSError *error))block
{
    //log请求数据
    NSLog(@"\n===========request===========\n%@:\n%@", aPath, params);
    aPath = [aPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask *urlSessionDataTask = nil;
    
    //发起请求
    switch (sessionType) {
        case HttpSessionTypeGET:
        {
            urlSessionDataTask = [self GET:aPath
                                parameters:params
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       
                                       id error = [self handleResponse:responseObject];
                                       if (error) {
                                           block(nil, error);
                                       }else{
                                           block(responseObject, nil);
                                       }
                                       
                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       
                                       block(nil, error);
                                    
                                   }];
            
            break;
        }
            
        case HttpSessionTypePOST:
        {
            urlSessionDataTask = [self POST:aPath
                                 parameters:params
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        LOG(@"\n%@===========response===========:\n%@", aPath, responseObject);
                                        id error = [self handleResponse:responseObject];
                                        if (error) {
                                            block(nil, error);
                                        }else{
                                            if (![aPath isEqualToString:[[SystemConfig sharedInstance] GetLoginURLStr]]) {
                                                [HttpSessionClient saveCookieData];
                                            }
                                            block(responseObject, nil);
                                        }

                                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        block(nil, error);
                                    }];
            break;
        }
            
        case HttpSessionTypePUT:
        {
            urlSessionDataTask = [self PUT:aPath
                                parameters:params
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       LOG(@"\n%@===========response===========:\n%@", aPath, responseObject);
                                       id error = [self handleResponse:responseObject];
                                       if (error) {
                                           block(nil, error);
                                       }else{
                                           block(responseObject, nil);
                                       }
                                       
                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       block(nil, error);
                                   }];
            break;
        }
            
        case HttpSessionTypeDELETE:
        {
            urlSessionDataTask = [self DELETE:aPath
                                   parameters:params
                                      success:^(NSURLSessionDataTask *task, id responseObject) {
                                          LOG(@"\n%@===========response===========:\n%@", aPath, responseObject);
                                          id error = [self handleResponse:responseObject];
                                          if (error) {
                                              block(nil, error);
                                          }else{
                                              block(responseObject, nil);
                                          }
                                          
                                      } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                          block(nil, error);
                                      }];
            break;
        }
        default:
            break;
    }
    
    return urlSessionDataTask;
}

- (NSURLSessionUploadTask *)uploadImage:(UIImage *)image
                                   path:(NSString *)path
                                   name:(NSString *)name
                             withParams:(NSDictionary*)params
                               progress:(NSProgress * __autoreleasing *)progress
                           successBlock:(void (^)(NSURLSessionUploadTask *task, id responseObject))success
                           failureBlock:(void (^)(NSURLSessionUploadTask *task, NSError *error))failure
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    if ((float)data.length/1024 > 1000) {
        data = UIImageJPEGRepresentation(image, (1024*1000.0)/(float)data.length);
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *timeStr = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@_%@.jpg", [[UserConfig sharedInstance] GetUserName], timeStr];
    NSLog(@"\nuploadImageSize\n%@ : %.0f", fileName, (float)data.length/1024);
    
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
                                                                                              URLString:@"图片上传地址"
                                                                                             parameters:nil
                                                                              constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                                                  [formData appendPartWithFileData:data
                                                                                                              name:@"upfile"
                                                                                                          fileName:fileName
                                                                                                          mimeType:@"image/jpeg"];
                                                                                  
                                                                              } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request
                                                                       progress:progress
                                                              completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            failure(uploadTask,error);
        } else {
            success(uploadTask,responseObject);

        }
                                                                  
    }];
        
    [uploadTask resume];
    
    return uploadTask;
}
/*//Creating an Upload Task for a Multi-Part Request, with Progress
 NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://example.com/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
 [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
 } error:nil];
 
 AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
 NSProgress *progress = nil;
 
 NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
 if (error) {
 NSLog(@"Error: %@", error);
 } else {
 NSLog(@"%@ %@", response, responseObject);
 }
 }];
 
 [uploadTask resume];
 */

/*//Creating a Download Task
 NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
 AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
 
 NSURL *URL = [NSURL URLWithString:@"http://example.com/download.zip"];
 NSURLRequest *request = [NSURLRequest requestWithURL:URL];
 
 NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
 NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
 return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
 } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
 NSLog(@"File downloaded to: %@", filePath);
 }];
 [downloadTask resume];
*/

/*//Creating a Data Task
 NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
 AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
 
 NSURL *URL = [NSURL URLWithString:@"http://example.com/upload"];
 NSURLRequest *request = [NSURLRequest requestWithURL:URL];
 
 NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
 if (error) {
 NSLog(@"Error: %@", error);
 } else {
 NSLog(@"%@ %@", response, responseObject);
 }
 }];
 [dataTask resume];
 */

@end
