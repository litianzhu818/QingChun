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

//存取自动登录的值
-(void)SetAutoLogin:(BOOL)value;
-(BOOL)GetAutoLogin;

//存取是否已经登录的值
-(void)SetAlreadyLogin:(BOOL)value;
-(BOOL)GetAlreadyLogin;

//存取用户head_url_prefix的值
-(void)SetHeadURLPrefix:(NSString *)value;
-(NSString *)GetHeadURLPrefix;

//存取用户image_url_prefix的值
-(void)SetImageURLPrefix:(NSString *)value;
-(NSString *)GetImageURLPrefix;

//存取用户Tencent的Token值
-(void)SetTencentToken:(NSString *)value;
-(NSString *)GetTencentToken;

//存取用户Weibo的Token值
-(void)SetWeiboToken:(NSString *)value;
-(NSString *)GetWeiboToken;

//存取用户Key的值
-(void)SetUserKey:(NSString *)value;
-(NSString *)GetUserKey;

//存取用户临时的第三方头像的url的值
-(void)SetUserTempOtherSDKImageUrl:(NSString *)value;
-(NSString *)GetUserTempOtherSDKImageUrl;

//存取用户基本信息的值
-(void)SetUserInfo:(id)value;
-(id)GetUserInfo;

@end
