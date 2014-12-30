//
//  SystemConfig.m
//  QingChunApp
//
//  Created by  李天柱 on 14-10-22.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "SystemConfig.h"
#import "SystemConfigKeyValue.h"

@implementation SystemConfig
Single_implementation(SystemConfig);

//存取FistLoading的标志
-(void)SetFistLoading:(BOOL)value;
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:qcdFirstLoading];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)GetFistLoading
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:qcdFirstLoading];
}

//存取主站点的值
-(void)SetBaseURLStr:(NSString *)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:qcdBaseURLStr];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)GetBaseURLStr
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:qcdBaseURLStr];
}

//存取Session的值
-(void)SetSession:(NSData *)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:qcdSession];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSData *)GetSession
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:qcdSession];
}
-(void)RemoveSession
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:qcdSession];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//登录的API路径
-(void)SetLoginURLStr:(NSString *)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:qcdLoginPath];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)GetLoginURLStr
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:qcdLoginPath];
}

-(void)SetMessageURLStr:(NSString *)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:qcdMessagePath];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)GetMessageURLStr
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:qcdMessagePath];
}

//获取加密校验值
-(void)SetCheckSumSecret:(NSString *)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:qcdCheckSumSecret];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)GetCheckSumSecret
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:qcdCheckSumSecret];
}



@end
