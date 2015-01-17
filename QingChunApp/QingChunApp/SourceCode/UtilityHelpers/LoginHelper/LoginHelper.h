//
//  LoginHelper.h
//  QingChunApp
//
//  Created by Peter Lee on 15/1/17.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WeiBoManager;
@class TencentManager;

@interface LoginHelper : NSObject

@property (strong, nonatomic, readonly) WeiBoManager *weiBoManager;
@property (strong, nonatomic, readonly) TencentManager *tencentManager;


+ (WeiBoManager *)sharedInstance;
+ (id)allocWithZone:(NSZone *)zone;

- (id)copyWithZone:(NSZone *)zone;


+ (BOOL)HandleOpenURL:(NSURL *)url;

@end

