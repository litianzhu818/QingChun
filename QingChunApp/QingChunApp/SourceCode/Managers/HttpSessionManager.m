//
//  HttpRequestManager.m
//  QingChunApp
//
//  Created by  李天柱 on 14/12/30.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "HttpSessionManager.h"
#import "NSObject+AutoProperties.h"
#import "NSString+Hashes.h"
#import "HttpSessionClient.h"

@implementation HttpSessionManager

+ (id)sharedInstance
{
    static HttpSessionManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    
    return _sharedManager;
}

- (void)requestQCDMessageWithPage:(NSUInteger)page
                             type:(NSUInteger)type
                       identifier:(NSString *)identifier
                            block:(void (^)(id data, NSError *error))block
{
    NSString *path = [[SystemConfig sharedInstance] GetMessageURLStr];
  
    NSString *checksumStr = [NSString stringWithFormat:@"%@%ld%ld%@",identifier,page,type,[[SystemConfig sharedInstance] GetCheckSumSecret]];
    
    NSDictionary *params = @{@"page":[NSNumber numberWithUnsignedInteger:page],
                             @"type":[NSNumber numberWithUnsignedInteger:type],
                             @"identifier":identifier,
                             @"checksum":[checksumStr sha1]
                             };
    [[HttpSessionClient sharedClient] requestJsonDataWithPath:path
                                                   withParams:params
                                               withMethodType:HttpSessionTypePOST
                                                     andBlock:^(id data, NSError *error) {
                                                         if (data) {
                                                             id resultData = [data valueForKeyPath:@"data"];
                                                             id listData = [resultData valueForKeyPath:@"list"];
                                                             //获取头像URL的前缀
                                                             NSString *headURLPrefix = [resultData valueForKeyPath:@"headUrl"];
                                                             //获取图片信息的URL的前缀
                                                             NSString *imgURLPrefix = [resultData valueForKeyPath:@"imgUrl"];
                                                             //存储这两个信息
                                                             [[UserConfig sharedInstance] SetHeadURLPrefix:headURLPrefix];
                                                             [[UserConfig sharedInstance] SetImageURLPrefix:imgURLPrefix];
                                                             
                                                             LOG(@"%@",listData);
                                                             block(listData, nil);
                                                             
                                                         }else{
                                                             block(nil, error);
                                                         }
                                                     }];
}




@end
