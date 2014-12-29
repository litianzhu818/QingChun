//
//  UserConfig.h
//  QingChunApp
//
//  Created by  李天柱 on 14-10-22.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingletonManager.h"

@interface UserConfig : NSObject
Single_interface(UserConfig);

//User login name
-(void)SetUserName:(NSString *)value;
-(NSString *)GetUserName;

//存取用户密码的值
-(void)SetUserPassword:(NSString *)value;
-(NSString *)GetUserPassword;

@end
