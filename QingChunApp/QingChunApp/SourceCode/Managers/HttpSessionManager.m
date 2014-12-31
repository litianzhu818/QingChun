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
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
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
  
    NSString *checksumStr = [NSString stringWithFormat:@"%@%d%d%@",identifier,page,type,[[SystemConfig sharedInstance] GetCheckSumSecret]];
    
    NSDictionary *params = @{@"page":[NSNumber numberWithUnsignedInteger:page],
                             @"type":[NSNumber numberWithUnsignedInteger:type],
                             @"identifier":identifier,
                             @"checksum":[checksumStr sha1]
                             };
    [HttpSessionClient requestJsonDataWithPath:path
                                                   withParams:params
                                               withMethodType:HttpSessionTypePOST
                                                     andBlock:^(id data, NSError *error) {
                                                         if (data) {
                                                             id resultData = [data valueForKeyPath:@"data"];
                                                             LOG(@"%@",resultData);
                                                             //Project *resultA = [NSObject objectOfClass:@"Project" fromJSON:resultData];
                                                             //block(resultA, nil);
                                                         }else{
                                                             block(nil, error);
                                                         }
                                                     }];
}




@end
