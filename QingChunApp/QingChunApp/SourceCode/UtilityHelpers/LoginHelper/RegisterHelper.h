//
//  RegisterHelper.h
//  QingChunApp
//
//  Created by Peter Lee on 15/1/26.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "LTZManager.h"

FOUNDATION_EXTERN NSString *const CustomRegisterErrorDomain;

typedef void (^CompleteHandler)(id userInfo, NSError *error);

@interface RegisterHelper : LTZManager

+ (RegisterHelper *)sharedHelper;
+ (id)allocWithZone:(NSZone *)zone;

- (id)copyWithZone:(NSZone *)zone;

- (void)registerWithUseKey:(NSString *)userkey
                  userName:(NSString *)userName
                  password:(NSString *)password
                     email:(NSString *)email
                       img:(NSString *)imgUrlStr
           completeHandler:(CompleteHandler)completeHandler;

@end
