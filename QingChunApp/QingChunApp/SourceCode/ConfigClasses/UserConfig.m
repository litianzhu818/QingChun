//
//  UserConfig.m
//  QingChunApp
//
//  Created by  李天柱 on 14-10-22.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "UserConfig.h"
#import "UserConfigKeyValue.h"

@implementation UserConfig
Single_implementation(UserConfig);

//User login name
-(void)SetUserName:(NSString *)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:qcdUserName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)GetUserName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:qcdUserName];
}

//存取用户密码的值
-(void)SetUserPassword:(NSString *)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:qcdUserPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)GetUserPassword
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:qcdUserPassword];
}

//存取自动登录的值
-(void)SetAutoLogin:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:value] forKey:qcdUserAutoLogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)GetAutoLogin
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:qcdUserAutoLogin] boolValue];
}


@end