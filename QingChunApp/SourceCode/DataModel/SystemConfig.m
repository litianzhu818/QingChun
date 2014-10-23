//
//  SystemConfig.m
//  QingChunApp
//
//  Created by  李天柱 on 14-10-22.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "SystemConfig.h"

@implementation SystemConfig
Single_implementation(SystemConfig);

//存取FistLoading的标志
-(void)SetFistLoading:(BOOL)value;
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:FIRST_LOADING];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)GetFistLoading
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:FIRST_LOADING];
}




@end
