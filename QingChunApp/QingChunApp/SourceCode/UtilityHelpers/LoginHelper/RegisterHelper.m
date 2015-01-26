//
//  RegisterHelper.m
//  QingChunApp
//
//  Created by Peter Lee on 15/1/26.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "RegisterHelper.h"
#import "HttpSessionManager.h"

NSString *const CustomRegisterErrorDomain = @"com.qcd.register.error";

@interface RegisterHelper ()
{
    CompleteHandler             _completeHandler;
}
@end

@implementation RegisterHelper

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Singleton class methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
static RegisterHelper *_sharedHelper = nil;

+ (RegisterHelper *)sharedHelper
{
    @synchronized (self){
        if (_sharedHelper == nil) {
            _sharedHelper = [[self alloc] init];
        }
    }
    return _sharedHelper;
}

+ (id)allocWithZone:(NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHelper = [super allocWithZone:zone];
    });
    return _sharedHelper;
}

- (id)copyWithZone:(NSZone *)zone
{
    @synchronized (self){
        if (_sharedHelper == nil) {
            _sharedHelper = [[RegisterHelper alloc] init];
        }
    }
    return _sharedHelper;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public object methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)registerWithUseKey:(NSString *)userkey
                  userName:(NSString *)userName
                  password:(NSString *)password
                     email:(NSString *)email
                       img:(NSString *)imgUrlStr
           completeHandler:(CompleteHandler)completeHandler
{
    dispatch_block_t block = ^{ @autoreleasepool {
        
        [self _registerWithUseKey:userkey
                         userName:userName
                         password:password
                            email:email
                              img:imgUrlStr
                  completeHandler:completeHandler];
        
        
    }};
    
    if (dispatch_get_specific(managerQueueTag))
        block();
    else
        dispatch_async(managerQueue, block);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private object methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)_registerWithUseKey:(NSString *)userkey
                   userName:(NSString *)userName
                   password:(NSString *)password
                      email:(NSString *)email
                        img:(NSString *)imgUrlStr
            completeHandler:(CompleteHandler)completeHandler
{
    RETURN_WITH_QUEUE_TAG(managerQueueTag);
    
    _completeHandler = completeHandler;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:userkey forKey:@"userKey"];
    [params setObject:userName forKey:@"userName"];
    [params setObject:password forKey:@"password"];
    [params setObject:email forKey:@"email"];
    [params setObject:imgUrlStr forKey:@"img"];
    
    [[HttpSessionManager sharedInstance] registerWithIdentifier:@"register"
                                                         params:params
                                                          block:^(id data, NSError *error) {
                                                              
                                                              if (!error) {
                                                                  _completeHandler(data,nil);
                                                              }else{
                                                                  _completeHandler(nil,ErrorFactory(error.code, [self stringValueWithErrorCode:error.code]));
                                                              }
                                                              
                                                          }];
}

- (NSString *)stringValueWithErrorCode:(NSInteger)errorCode
{
    NSString *result = nil;
   
    switch (errorCode) {
        case 2012:
            result = LTZLocalizedString(@"email_formal_error");
            break;
        case 2013:
            result = LTZLocalizedString(@"email_existing");
            break;
        case 2014:
            result = LTZLocalizedString(@"user_name_formal_error");
            break;
        case 2015:
            result = LTZLocalizedString(@"user_name_existing");
            break;
        case 2016:
            result = LTZLocalizedString(@"user_pwd__formal_error");
            break;
    
        default:
            break;
    }
    
    return result;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - inline methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

FOUNDATION_STATIC_INLINE NSError *ErrorFactory(NSInteger errorCode, NSString *description) {
    
    NSError *error = nil;
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:description
                                                         forKey:NSLocalizedDescriptionKey];
    error = [NSError errorWithDomain:CustomRegisterErrorDomain code:errorCode userInfo:userInfo];
    
    return error;
}


@end
