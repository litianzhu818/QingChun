//
//  WeiBoManager.h
//  QingChunApp
//
//  Created by Peter Lee on 15/1/17.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "LTZManager.h"

@class WeiboSDK;
@interface WeiBoManager : LTZManager

@property (strong, nonatomic, readonly) WeiboSDK *weiboSDK;


+ (WeiBoManager *)sharedInstance;
+ (id)allocWithZone:(NSZone *)zone;

- (id)copyWithZone:(NSZone *)zone;

+ (BOOL)HandleOpenURL:(NSURL *)url;

- (void)authorize;
- (void)authorizeInSafari:(BOOL)inSafari;

@end

@protocol WeiBoManagerDelegate <NSObject>

@required

@optional

@end
