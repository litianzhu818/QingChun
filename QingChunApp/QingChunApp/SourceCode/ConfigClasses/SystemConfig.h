//
//  SystemConfig.h
//  QingChunApp
//
//  Created by  李天柱 on 14-10-22.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingletonManager.h"


@interface SystemConfig : NSObject
Single_interface(SystemConfig);

//存取FistLoading的值
-(void)SetFistLoading:(BOOL)value;
-(BOOL)GetFistLoading;

//存取主站点的值
-(void)SetBaseURLStr:(NSString *)value;
-(NSString *)GetBaseURLStr;

//存取Session的值
-(void)SetSession:(NSData *)value;
-(NSData *)GetSession;
-(void)RemoveSession;

//登录的API路径
-(void)SetLoginURLStr:(NSString *)value;
-(NSString *)GetLoginURLStr;
@end
