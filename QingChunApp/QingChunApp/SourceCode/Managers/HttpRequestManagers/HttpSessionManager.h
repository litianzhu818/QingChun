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
//第三方登录接口
- (void)loginWithIdentifier:(NSString *)identifier
                     params:(id)params
                      block:(void (^)(id data, NSError *error))block;
//自己登录接口
- (void)login2WithIdentifier:(NSString *)identifier
                      params:(id)params
                       block:(void (^)(id data, NSError *error))block;
//第三方注册接口
- (void)registerWithIdentifier:(NSString *)identifier
                        params:(id)params
                         block:(void (^)(id data, NSError *error))block;
//自己注册接口
- (void)register2WithIdentifier:(NSString *)identifier
                        params:(id)params
                         block:(void (^)(id data, NSError *error))block;
//读取青春风铃的信息数字
- (void)requsetBellNumberWithIdentifier:(NSString *)identifier
                                 params:(id)params
                                  block:(void (^)(id data, NSError *error))block;

//发送说说
- (void)sendTweetWithIdentifier:(NSString *)identifier
                         params:(id)params
                          block:(void (^)(id data, NSError *error))block;

// 上传说说图片
//- (void)uploadTweetImage



@end
