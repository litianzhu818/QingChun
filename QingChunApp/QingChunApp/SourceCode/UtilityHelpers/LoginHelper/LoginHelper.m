//
//  LoginHelper.m
//  QingChunApp
//
//  Created by Peter Lee on 15/1/17.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "LoginHelper.h"
#import "WeiBoManager.h"
#import "TencentManager.h"
#import "OtherSDKInfo.h"

@implementation LoginHelper

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Singleton class methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
static TencentManager *sharedInstance = nil;

+ (TencentManager *)sharedInstance
{
    @synchronized (self){
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super allocWithZone:zone];
    });
    return sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone
{
    @synchronized (self){
        if (sharedInstance == nil) {
            sharedInstance = [[TencentManager alloc] init];
        }
    }
    return sharedInstance;
}
+ (BOOL)HandleOpenURL:(NSURL *)url
{
    BOOL result = NO;
    
    if (!url) return result;
    
    if ([[url scheme] isEqualToString:WeiBoAppURLScheme]) {
        result = [WeiBoManager HandleOpenURL:url];
    }else if ([[url scheme] isEqualToString:TenCentAppURLScheme]){
        result = [TencentManager HandleOpenURL:url];
    }
    
    return result;
}


@end
