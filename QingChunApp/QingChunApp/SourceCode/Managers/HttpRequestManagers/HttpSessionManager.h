//
//  HttpRequestManager.h
//  QingChunApp
//
//  Created by  李天柱 on 14/12/30.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpSessionManager : NSObject

+ (id)sharedInstance;

- (void)requestQCDMessageWithPage:(NSUInteger)page
                             type:(NSUInteger)type
                       identifier:(NSString *)identifier
                            block:(void (^)(id data, NSError *error))block;
- (void)loginWithIdentifier:(NSString *)identifier
                     params:(NSDictionary*)params
                      block:(void (^)(id data, NSError *error))block;

@end
